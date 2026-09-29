import 'dart:async';

import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/websocket/config/websocket_config.dart';
import 'package:taksh_e_commerce/core/websocket/exceptions/websocket_exceptions.dart';
import 'package:taksh_e_commerce/core/websocket/models/websocket_connection_state.dart';
import 'package:taksh_e_commerce/core/websocket/service/websocket_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Concrete [WebSocketService] backed by [WebSocketChannel].
///
/// This class owns exactly one socket at a time.  It does not perform
/// reconnection — that responsibility belongs to [WebSocketManager].
class WebSocketServiceImpl implements WebSocketService {
  final _log = loggerWithContext({
    'feature': 'websocket',
    'class': 'WebSocketServiceImpl',
  });

  // ── Internal streams ────────────────────────────────────────────────────────

  final _messageController = StreamController<String>.broadcast();
  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();

  // ── Ongoing connection ──────────────────────────────────────────────────────

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _channelSub;
  WebSocketConnectionState _currentState = const WsDisconnected();

  // ── Public API ──────────────────────────────────────────────────────────────

  @override
  Stream<String> get messageStream => _messageController.stream;

  @override
  Stream<WebSocketConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  @override
  WebSocketConnectionState get currentState => _currentState;

  @override
  bool get isConnected => _currentState is WsConnected;

  // ── connect ─────────────────────────────────────────────────────────────────

  @override
  Future<void> connect(WebSocketConfig config) async {
    if (_currentState is WsConnected || _currentState is WsConnecting) {
      _log.warnWithContext(
        'connect() called while already connecting/connected — ignoring',
        {'state': _currentState.toString()},
      );
      return;
    }

    _emitState(const WsConnecting());
    _log.infoWithContext(
      'Opening WebSocket connection',
      {'url': config.resolvedUri.toString()},
    );

    try {
      // IOWebSocketChannel works on mobile/desktop; for web use
      // HtmlWebSocketChannel.connect() instead.
      _channel = IOWebSocketChannel.connect(
        config.resolvedUri,
        pingInterval: config.heartbeatInterval,
      );

      // Wait for the ready future so we get an immediate error on fail.
      await _channel!.ready;

      _emitState(WsConnected());
      _log.infoWithContext(
        'WebSocket connected',
        {'url': config.resolvedUri.toString()},
      );

      // Fan out frames from the channel to our broadcast stream.
      _channelSub = _channel!.stream.listen(
        _onFrame,
        onError: _onChannelError,
        onDone: _onChannelDone,
        cancelOnError: false,
      );
    } catch (e, st) {
      _log.errorWithContext(
        'WebSocket connection failed',
        {'url': config.resolvedUri.toString()},
        e,
        st,
      );
      _emitState(
        WsDisconnected(reason: 'Connection failed: $e'),
      );
      throw WebSocketConnectionException('Connection failed: $e');
    }
  }

  // ── send ────────────────────────────────────────────────────────────────────

  @override
  void send(String message) {
    if (!isConnected || _channel == null) {
      throw StateError(
        'Cannot send message: WebSocket is not connected '
        '(current state: $_currentState)',
      );
    }
    _log.debugWithContext(
      'Sending WebSocket message',
      {'length': message.length},
    );
    _channel!.sink.add(message);
  }

  // ── disconnect ──────────────────────────────────────────────────────────────

  @override
  Future<void> disconnect({String? reason}) async {
    _log.infoWithContext(
      'Disconnecting WebSocket',
      {'reason': reason ?? 'explicit disconnect'},
    );
    await _closeChannel();
    _emitState(WsDisconnected(reason: reason));
  }

  // ── dispose ─────────────────────────────────────────────────────────────────

  @override
  Future<void> dispose() async {
    _log.infoWithContext('Disposing WebSocketService', {});
    await _closeChannel();
    await _messageController.close();
    await _connectionStateController.close();
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  void _onFrame(dynamic frame) {
    if (frame is String) {
      _log.debugWithContext(
        'WebSocket frame received',
        {'length': frame.length},
      );
      if (!_messageController.isClosed) {
        _messageController.add(frame);
      }
    } else if (frame is List<int>) {
      // Binary frames: convert to string (UTF-8) and forward.
      final text = String.fromCharCodes(frame);
      if (!_messageController.isClosed) {
        _messageController.add(text);
      }
    }
  }

  void _onChannelError(Object error, StackTrace st) {
    _log.errorWithContext(
      'WebSocket channel error',
      {'error': error.toString()},
      error,
      st,
    );
    _emitState(WsDisconnected(reason: error.toString()));
    // Forward error to message stream so manager can react.
    if (!_messageController.isClosed) {
      _messageController.addError(error, st);
    }
  }

  void _onChannelDone() {
    final closeCode = _channel?.closeCode;
    final closeReason = _channel?.closeReason;

    _log.infoWithContext(
      'WebSocket channel closed by remote',
      {'closeCode': closeCode, 'closeReason': closeReason},
    );
    _emitState(
      WsDisconnected(reason: closeReason ?? 'Channel closed by server'),
    );
  }

  Future<void> _closeChannel() async {
    await _channelSub?.cancel();
    _channelSub = null;
    await _channel?.sink.close();
    _channel = null;
  }

  void _emitState(WebSocketConnectionState state) {
    _currentState = state;
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
  }
}
