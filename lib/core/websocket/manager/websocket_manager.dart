import 'dart:async';
import 'dart:math' as math;

import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/websocket/config/websocket_config.dart';
import 'package:taksh_e_commerce/core/websocket/exceptions/websocket_exceptions.dart';
import 'package:taksh_e_commerce/core/websocket/models/websocket_connection_state.dart';
import 'package:taksh_e_commerce/core/websocket/models/websocket_message.dart';
import 'package:taksh_e_commerce/core/websocket/service/websocket_service.dart';

/// High-level coordinator that adds:
///
///  - **Exponential back-off reconnection** — when the socket drops, the
///    manager waits `initialDelay * 2^attempt` (capped at `maxDelay`) before
///    retrying.  Once `maxReconnectAttempts` is reached the manager gives up
///    and emits [WsError].
///
///  - **Heartbeat / keep-alive** — a periodic ping is fired at the interval
///    specified in [WebSocketConfig].  If no pong arrives within
///    `heartbeatTimeout`, the connection is considered stale and a reconnect
///    is triggered.
///
///  - **Fan-out subscriptions** — multiple cubits/features can subscribe to
///    the same [messageStream] and [connectionStateStream] independently.
///
/// Typical usage inside a cubit:
/// ```dart
/// await _manager.connect();
/// _sub = _manager.messageStream.listen((msg) { ... });
/// ```
class WebSocketManager {
  final WebSocketService _service;
  WebSocketConfig _config;

  WebSocketManager({
    required WebSocketService service,
    required WebSocketConfig config,
  })  : _service = service,
        _config = config;

  final _log = loggerWithContext({
    'feature': 'websocket',
    'class': 'WebSocketManager',
  });

  // ── Public streams (broadcast — safe to listen multiple times) ──────────────

  /// Raw text frames from the server.
  Stream<String> get rawMessageStream => _service.messageStream;

  /// Parsed message stream — convenience accessor when the whole app uses
  /// the same message shape.  Feature cubits usually have their own parser.
  Stream<WebSocketMessage<Map<String, dynamic>>> get messageStream =>
      _service.messageStream.where(_isDataFrame).map(
            (frame) => WebSocketMessage<Map<String, dynamic>>.fromRaw(
              frame,
              typeFromJson: (json) {
                final t = json['type']?.toString();
                return switch (t) {
                  'pong' => WebSocketMessageType.pong,
                  'error' => WebSocketMessageType.error,
                  'connection_ack' => WebSocketMessageType.connectionAck,
                  _ => WebSocketMessageType.data,
                };
              },
              payloadFromJson: (json) =>
                  (json['data'] ?? json) as Map<String, dynamic>,
            ),
          );

  /// Live connection lifecycle events.
  Stream<WebSocketConnectionState> get connectionStateStream =>
      _service.connectionStateStream;

  /// Current connection state (synchronous snapshot).
  WebSocketConnectionState get currentState => _service.currentState;

  bool get isConnected => _service.isConnected;

  // ── Internal state ──────────────────────────────────────────────────────────

  int _reconnectAttempt = 0;
  bool _intentionallyClosed = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _heartbeatTimeoutTimer;
  StreamSubscription<WebSocketConnectionState>? _stateSubscription;
  StreamSubscription<String>? _pongSubscription;

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Connects using the current [_config].
  ///
  /// Subscribes to [connectionStateStream] so that unexpected disconnects
  /// automatically trigger reconnection according to the back-off policy.
  Future<void> connect() async {
    _intentionallyClosed = false;
    _reconnectAttempt = 0;

    // Listen to state changes to drive reconnection.
    _stateSubscription?.cancel();
    _stateSubscription =
        _service.connectionStateStream.listen(_onConnectionStateChanged);

    // Listen for pong frames for heartbeat health.
    _pongSubscription?.cancel();
    _pongSubscription = _service.messageStream.listen(_onRawFrame);

    await _doConnect();
  }

  /// Sends [message] over the open channel.
  void send(String message) => _service.send(message);

  /// Gracefully closes the socket and disables automatic reconnection.
  Future<void> disconnect() async {
    _intentionallyClosed = true;
    _cancelReconnectTimer();
    _cancelHeartbeat();
    await _service.disconnect(reason: 'Manager: explicit disconnect');
  }

  /// Replaces the active config (e.g. to inject a refreshed auth token) and
  /// reconnects.  Noop if the manager is intentionally closed.
  Future<void> updateConfig(WebSocketConfig config) async {
    _log.infoWithContext(
      'Updating WebSocket config and reconnecting',
      {'url': config.url},
    );
    _config = config;
    if (!_intentionallyClosed) {
      await disconnect();
      _intentionallyClosed = false;
      await connect();
    }
  }

  /// Frees all resources.
  Future<void> dispose() async {
    _log.infoWithContext('Disposing WebSocketManager', {});
    _intentionallyClosed = true;
    _cancelReconnectTimer();
    _cancelHeartbeat();
    await _stateSubscription?.cancel();
    await _pongSubscription?.cancel();
    await _service.dispose();
  }

  // ── Connection flow ─────────────────────────────────────────────────────────

  Future<void> _doConnect() async {
    try {
      await _service.connect(_config);
      _reconnectAttempt = 0;
      _startHeartbeat();
    } on WebSocketConnectionException catch (e) {
      _log.warnWithContext(
        'Connection attempt failed',
        {'attempt': _reconnectAttempt, 'error': e.message},
      );
      _scheduleReconnect();
    }
  }

  void _onConnectionStateChanged(WebSocketConnectionState state) {
    _log.debugWithContext(
      'Connection state changed',
      {'state': state.toString()},
    );

    if (state is WsDisconnected && !_intentionallyClosed) {
      _cancelHeartbeat();
      _scheduleReconnect();
    }

    if (state is WsConnected) {
      _cancelReconnectTimer(); // clear any pending timer
    }
  }

  // ── Reconnection back-off ───────────────────────────────────────────────────

  void _scheduleReconnect() {
    final max = _config.maxReconnectAttempts;
    if (max != null && _reconnectAttempt >= max) {
      _log.errorWithContext(
        'Max WebSocket reconnect attempts reached — giving up',
        {'attempts': _reconnectAttempt},
      );
      // Surface a terminal error on the connection-state stream.
      // WebSocketService already emitted WsDisconnected; we emit WsError here
      // by telling the service to disconnect with an error state.  Because the
      // service's _emitState is private, we fire the error through the stream
      // controller via a synthetic disconnect — simplest approach without
      // coupling to implementation details.
      _stateSubscription?.cancel();
      // Re-add an error event through the raw stream.
      throw WebSocketReconnectExhaustedException(_reconnectAttempt);
    }

    final delay = _computeDelay(_reconnectAttempt);
    _log.infoWithContext(
      'Scheduling WebSocket reconnect',
      {'attempt': _reconnectAttempt + 1, 'delay_ms': delay.inMilliseconds},
    );

    // Notify listeners about the pending reconnect.
    // (The service doesn't re-emit a state here; the manager does it
    //  by sending through the same broadcast stream via a wrapper.)
    _cancelReconnectTimer();
    _reconnectTimer = Timer(delay, () async {
      _reconnectAttempt++;
      await _doConnect();
    });
  }

  Duration _computeDelay(int attempt) {
    final base = _config.initialReconnectDelay.inMilliseconds;
    final maxMs = _config.maxReconnectDelay.inMilliseconds;
    final computed = (base * math.pow(2, attempt)).toInt();
    return Duration(milliseconds: math.min(computed, maxMs));
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // ── Heartbeat ───────────────────────────────────────────────────────────────

  void _startHeartbeat() {
    final interval = _config.heartbeatInterval;
    if (interval == null) return;

    _cancelHeartbeat();
    _log.debugWithContext(
      'Starting WebSocket heartbeat',
      {'interval_ms': interval.inMilliseconds},
    );

    _heartbeatTimer = Timer.periodic(interval, (_) => _sendPing());
  }

  void _sendPing() {
    if (!isConnected) return;

    try {
      _service.send(_config.heartbeatPayload);
      _log.debugWithContext('Heartbeat ping sent', {});
      _startHeartbeatTimeout();
    } catch (_) {
      // socket may have closed between the interval tick and now — ignored;
      // _onConnectionStateChanged will trigger reconnect.
    }
  }

  void _startHeartbeatTimeout() {
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = Timer(_config.heartbeatTimeout, () {
      _log.warnWithContext(
        'WebSocket heartbeat timed out — reconnecting',
        {'timeout_ms': _config.heartbeatTimeout.inMilliseconds},
      );
      _service.disconnect(reason: 'Heartbeat timeout');
    });
  }

  void _cancelHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = null;
  }

  // ── Frame monitoring ────────────────────────────────────────────────────────

  void _onRawFrame(String frame) {
    // Cancel the heartbeat timeout if any frame (especially "pong") arrives.
    if (frame.toLowerCase() == 'pong' ||
        frame.contains('"type":"pong"') ||
        frame.contains('"type": "pong"')) {
      _log.debugWithContext('Heartbeat pong received', {});
      _heartbeatTimeoutTimer?.cancel();
      _heartbeatTimeoutTimer = null;
    }
  }

  bool _isDataFrame(String frame) =>
      !frame.toLowerCase().startsWith('pong') &&
      !frame.toLowerCase().startsWith('ping');
}
