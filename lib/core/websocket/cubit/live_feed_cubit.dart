import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/websocket/cubit/live_feed_state.dart';
import 'package:taksh_e_commerce/core/websocket/manager/websocket_manager.dart';
import 'package:taksh_e_commerce/core/websocket/models/websocket_connection_state.dart';

/// Abstract base cubit that drives any feature requiring a live WebSocket feed.
///
/// Subclasses only need to implement:
///
/// ```dart
/// @override
/// T? parseMessage(String rawFrame) { ... }
/// ```
///
/// Everything else — connecting, subscribing, reconnect tracking, state
/// transitions, stale-data preservation — is handled here.
///
/// Example subclass:
/// ```dart
/// class OrderTrackingCubit extends LiveFeedCubit<OrderStatus> {
///   OrderTrackingCubit(WebSocketManager manager) : super(manager);
///
///   @override
///   OrderStatus? parseMessage(String rawFrame) {
///     try {
///       return OrderStatus.fromJson(jsonDecode(rawFrame) as Map<String, dynamic>);
///     } catch (_) {
///       return null; // returning null silently drops the frame
///     }
///   }
/// }
/// ```
abstract class LiveFeedCubit<T> extends Cubit<LiveFeedState<T>> {
  final WebSocketManager _manager;

  StreamSubscription<String>? _messageSub;
  StreamSubscription<WebSocketConnectionState>? _connStateSub;

  /// The last successfully parsed data payload — preserved when the state
  /// transitions to disconnected / reconnecting / error.
  T? _lastData;

  LiveFeedCubit(WebSocketManager manager)
      : _manager = manager,
        super(LiveFeedInitial<T>());

  final _log = loggerWithContext({
    'feature': 'websocket',
    'class': 'LiveFeedCubit',
  });

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  /// Opens the WebSocket connection and starts streaming data.
  ///
  /// Safe to call multiple times — subsequent calls are ignored if already
  /// connecting or connected.
  Future<void> connect() async {
    if (state is LiveFeedConnecting || state is LiveFeedConnected) {
      _log.debugWithContext(
        'connect() called while already active — ignoring',
        {'state': state.toString()},
      );
      return;
    }

    emit(const LiveFeedConnecting());
    _subscribeToConnectionState();

    try {
      await _manager.connect();
      _subscribeToMessages();
    } catch (e) {
      _log.errorWithContext(
        'LiveFeedCubit.connect() failed',
        {'error': e.toString()},
      );
      emit(LiveFeedError<T>(message: e.toString(), error: e));
    }
  }

  /// Sends a raw text frame.  Useful for subscriptions requests or commands
  /// that the server expects once connected.
  ///
  /// Throws if not connected.
  void send(String message) => _manager.send(message);

  /// Disconnects and sets state back to [LiveFeedDisconnected].
  Future<void> disconnect() async {
    await _manager.disconnect();
    emit(LiveFeedDisconnected<T>(lastData: _lastData, reason: 'user request'));
  }

  // ── Abstract API ────────────────────────────────────────────────────────────

  /// Parses a raw WebSocket [frame] string into [T].
  ///
  /// Return `null` to silently skip the frame (e.g. it's a control or
  /// irrelevant message).  Throw to report a parse error.
  T? parseMessage(String frame);

  // ── Cubit close ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() async {
    _log.infoWithContext('Closing LiveFeedCubit', {});
    await _messageSub?.cancel();
    await _connStateSub?.cancel();
    await _manager.dispose();
    return super.close();
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  void _subscribeToMessages() {
    _messageSub?.cancel();
    _messageSub = _manager.rawMessageStream.listen(
      _onRawFrame,
      onError: _onStreamError,
      cancelOnError: false,
    );
  }

  void _subscribeToConnectionState() {
    _connStateSub?.cancel();
    _connStateSub = _manager.connectionStateStream.listen(
      _onConnectionState,
      cancelOnError: false,
    );
  }

  void _onRawFrame(String frame) {
    // Skip pure heartbeat control frames.
    final lower = frame.toLowerCase().trim();
    if (lower == 'ping' || lower == 'pong') return;

    try {
      final parsed = parseMessage(frame);
      if (parsed == null) return;

      final previous = _lastData;
      _lastData = parsed;

      emit(LiveFeedData<T>(data: parsed, previousData: previous));
    } catch (e, st) {
      _log.errorWithContext(
        'Failed to parse WebSocket message',
        {'frame_length': frame.length},
        e,
        st,
      );
      // Emit error but preserve last valid data so the UI stays meaningful.
      emit(LiveFeedError<T>(
        message: 'Failed to parse message: $e',
        error: e,
        lastData: _lastData,
      ));
    }
  }

  void _onConnectionState(WebSocketConnectionState wsState) {
    _log.debugWithContext(
      'LiveFeedCubit received connection state',
      {'state': wsState.toString()},
    );

    switch (wsState) {
      case WsConnecting():
        if (state is! LiveFeedConnecting) {
          emit(LiveFeedConnecting<T>());
        }
      case WsConnected():
        emit(LiveFeedConnected<T>());
      case WsReconnecting(attempt: final attempt, delay: final delay):
        emit(LiveFeedReconnecting<T>(
          attempt: attempt,
          nextDelay: delay,
          lastData: _lastData,
        ));
      case WsDisconnected(reason: final reason):
        if (state is! LiveFeedReconnecting) {
          emit(LiveFeedDisconnected<T>(lastData: _lastData, reason: reason));
        }
      case WsError(message: final msg, error: final err):
        emit(LiveFeedError<T>(
          message: msg,
          error: err,
          lastData: _lastData,
        ));
    }
  }

  void _onStreamError(Object error, StackTrace st) {
    _log.errorWithContext(
      'LiveFeedCubit stream error',
      {'error': error.toString()},
      error,
      st,
    );
    emit(LiveFeedError<T>(
      message: error.toString(),
      error: error,
      lastData: _lastData,
    ));
  }
}
