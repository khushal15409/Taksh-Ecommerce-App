import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Exceptions (data layer)
// ─────────────────────────────────────────────────────────────────────────────

/// Thrown when the initial WebSocket handshake / upgrade fails.
class WebSocketConnectionException extends AppException {
  const WebSocketConnectionException([
    super.message = 'WebSocket connection failed',
  ]);
}

/// Thrown when all reconnection attempts have been exhausted.
class WebSocketReconnectExhaustedException extends AppException {
  final int attempts;

  const WebSocketReconnectExhaustedException(this.attempts)
      : super('WebSocket reconnection exhausted after $attempts attempt(s)');
}

/// Thrown when a heartbeat round-trip times out.
class WebSocketHeartbeatTimeoutException extends AppException {
  const WebSocketHeartbeatTimeoutException([
    super.message = 'WebSocket heartbeat timed out',
  ]);
}

/// Thrown when an inbound frame cannot be parsed.
class WebSocketParseException extends AppException {
  const WebSocketParseException([
    super.message = 'Failed to parse WebSocket message',
  ]);
}

/// Thrown when the server closes the connection with an error code.
class WebSocketServerCloseException extends AppException {
  final int? closeCode;
  final String? closeReason;

  WebSocketServerCloseException({this.closeCode, this.closeReason})
      : super(
          'Server closed WebSocket'
          '${closeCode != null ? ' (code: $closeCode)' : ''}'
          '${closeReason != null ? ': $closeReason' : ''}',
        );
}

// ─────────────────────────────────────────────────────────────────────────────
// Failures (domain layer)
// ─────────────────────────────────────────────────────────────────────────────

/// Base class for WebSocket-related domain failures.
abstract class WebSocketFailure extends Failure {
  const WebSocketFailure(super.message);
}

class WebSocketConnectionFailure extends WebSocketFailure {
  const WebSocketConnectionFailure([
    super.message = 'WebSocket connection failed',
  ]);
}

class WebSocketReconnectExhaustedFailure extends WebSocketFailure {
  final int attempts;

  const WebSocketReconnectExhaustedFailure(this.attempts)
      : super('WebSocket reconnection exhausted after $attempts attempt(s)');

  @override
  List<Object?> get props => [message, attempts];
}

class WebSocketHeartbeatTimeoutFailure extends WebSocketFailure {
  const WebSocketHeartbeatTimeoutFailure([
    super.message = 'WebSocket heartbeat timed out',
  ]);
}

class WebSocketParseFailure extends WebSocketFailure {
  const WebSocketParseFailure([
    super.message = 'Failed to parse WebSocket message',
  ]);
}
