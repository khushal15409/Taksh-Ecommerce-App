import 'package:taksh_e_commerce/core/websocket/config/websocket_config.dart';
import 'package:taksh_e_commerce/core/websocket/models/websocket_connection_state.dart';

/// Low-level contract for a single WebSocket channel.
///
/// Responsibilities:
///  - Opening and closing the underlying socket.
///  - Exposing a raw `Stream<String>` of inbound frames.
///  - Exposing a `Stream<WebSocketConnectionState>` for lifecycle events.
///  - Sending outbound string frames.
///
/// Reconnection, back-off, heartbeat, and subscription fan-out are handled
/// by the higher-level [WebSocketManager]; this interface stays minimal and
/// therefore easy to mock in tests.
abstract interface class WebSocketService {
  /// Stream of raw inbound text frames from the server.
  Stream<String> get messageStream;

  /// Stream of connection lifecycle state changes.
  Stream<WebSocketConnectionState> get connectionStateStream;

  /// The current connection state (synchronous snapshot).
  WebSocketConnectionState get currentState;

  /// Opens the WebSocket connection described by [config].
  ///
  /// Completes when the initial handshake succeeds or throws a
  /// [WebSocketConnectionException] on failure.
  Future<void> connect(WebSocketConfig config);

  /// Sends [message] over the open channel.
  ///
  /// Throws [StateError] if the socket is not connected.
  void send(String message);

  /// Gracefully closes the connection with an optional [reason].
  Future<void> disconnect({String? reason});

  /// Whether the socket is currently in [WsConnected] state.
  bool get isConnected;

  /// Frees all resources — must be called before discarding the service.
  Future<void> dispose();
}
