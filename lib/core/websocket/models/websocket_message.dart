import 'dart:convert';

/// Represents the type of a WebSocket message.
///
/// Extend this or use a feature-specific enum to discriminate event types
/// coming from the server without reaching for raw JSON keys everywhere.
enum WebSocketMessageType {
  /// A data payload meant for consumption by a feature.
  data,

  /// Server-side error acknowledgement.
  error,

  /// Server's reply to a client heartbeat.
  pong,

  /// Connection lifecycle notification from the server.
  connectionAck,

  /// Subscription acknowledgement.
  subscriptionAck,

  /// Generic/unknown message — callers should inspect [rawPayload].
  unknown,
}

/// A strongly-typed envelope that wraps a single WebSocket frame.
///
/// [T] is the decoded payload type.  For JSON messages, [T] is typically
/// `Map<String, dynamic>`.  The service layer leaves decoding to the consumer
/// so each feature cubit can deserialise into its own domain model.
class WebSocketMessage<T> {
  /// Logical message type decoded from the frame.
  final WebSocketMessageType type;

  /// The decoded payload (may be `null` for control messages).
  final T? payload;

  /// The original raw string received from the channel — useful for logging
  /// and for consumers that need to inspect fields not captured in [payload].
  final String rawPayload;

  /// Server-assigned correlation id, if any.
  final String? messageId;

  /// When the message was received locally.
  final DateTime receivedAt;

  WebSocketMessage({
    required this.type,
    required this.rawPayload,
    this.payload,
    this.messageId,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  /// Parses a raw WebSocket [frame] into a [WebSocketMessage].
  ///
  /// [typeFromJson] maps the decoded JSON map to a [WebSocketMessageType];
  /// return `null` to fall back to [WebSocketMessageType.unknown].
  ///
  /// [payloadFromJson] extracts and casts the typed payload from the map.
  factory WebSocketMessage.fromRaw(
    String frame, {
    WebSocketMessageType Function(Map<String, dynamic>)? typeFromJson,
    T Function(Map<String, dynamic>)? payloadFromJson,
  }) {
    try {
      final decoded = jsonDecode(frame) as Map<String, dynamic>;
      final type = typeFromJson?.call(decoded) ?? WebSocketMessageType.data;
      final payload = payloadFromJson?.call(decoded);
      final messageId = decoded['id']?.toString() ??
          decoded['message_id']?.toString() ??
          decoded['messageId']?.toString();

      return WebSocketMessage<T>(
        type: type,
        rawPayload: frame,
        payload: payload,
        messageId: messageId,
      );
    } catch (_) {
      // Non-JSON frames (e.g. plain "pong" strings) land here.
      return WebSocketMessage<T>(
        type: frame.toLowerCase() == 'pong'
            ? WebSocketMessageType.pong
            : WebSocketMessageType.unknown,
        rawPayload: frame,
      );
    }
  }

  @override
  String toString() => 'WebSocketMessage(type: $type, messageId: $messageId, '
      'receivedAt: $receivedAt)';
}
