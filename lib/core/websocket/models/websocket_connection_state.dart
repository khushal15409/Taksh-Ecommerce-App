import 'package:equatable/equatable.dart';

/// Describes every state the WebSocket connection lifecycle can be in.
///
/// Emitted on the [WebSocketService.connectionStateStream] so that UI layers
/// can react to drops, reconnections, and errors independently of data events.
sealed class WebSocketConnectionState extends Equatable {
  const WebSocketConnectionState();

  @override
  List<Object?> get props => [];
}

/// The socket is not connected and no connection attempt is in progress.
final class WsDisconnected extends WebSocketConnectionState {
  /// Non-null when the disconnect was caused by an error.
  final String? reason;

  const WsDisconnected({this.reason});

  @override
  List<Object?> get props => [reason];

  @override
  String toString() => 'WsDisconnected(reason: $reason)';
}

/// A connection attempt is underway (first connect or manual reconnect).
final class WsConnecting extends WebSocketConnectionState {
  const WsConnecting();

  @override
  String toString() => 'WsConnecting()';
}

/// The socket is open and healthy.
final class WsConnected extends WebSocketConnectionState {
  /// When the connection was established.
  final DateTime connectedAt;

  WsConnected({DateTime? connectedAt})
      : connectedAt = connectedAt ?? DateTime.now();

  @override
  List<Object?> get props => [connectedAt];

  @override
  String toString() => 'WsConnected(connectedAt: $connectedAt)';
}

/// The connection was lost and the manager is waiting before retrying.
final class WsReconnecting extends WebSocketConnectionState {
  /// Zero-based attempt index (0 = first retry).
  final int attempt;

  /// How long the manager will wait before the next connect call.
  final Duration delay;

  const WsReconnecting({required this.attempt, required this.delay});

  @override
  List<Object?> get props => [attempt, delay];

  @override
  String toString() => 'WsReconnecting(attempt: $attempt, delay: $delay)';
}

/// A non-recoverable error occurred (e.g. max retries exhausted, auth failure).
final class WsError extends WebSocketConnectionState {
  final String message;
  final Object? error;

  const WsError({required this.message, this.error});

  @override
  List<Object?> get props => [message, error];

  @override
  String toString() => 'WsError(message: $message)';
}
