/// Configuration for a WebSocket connection.
///
/// Encapsulates the endpoint URL, reconnection policy, heartbeat settings,
/// and authentication token injection — keeping all tunable constants in
/// one place so they can be swapped per-environment without touching logic.
class WebSocketConfig {
  /// Full WebSocket URL, e.g. `wss://example.com/ws` or `ws://10.0.2.2:8080`.
  final String url;

  /// Maximum number of reconnection attempts before giving up.
  /// Set to `null` for unlimited retries.
  final int? maxReconnectAttempts;

  /// Base delay between reconnection attempts.
  /// Actual delay is calculated with exponential back-off:
  ///   `delay = initialReconnectDelay * 2^attempt` (capped at [maxReconnectDelay]).
  final Duration initialReconnectDelay;

  /// Upper ceiling for the exponential back-off delay.
  final Duration maxReconnectDelay;

  /// How often a ping frame is sent to keep the connection alive.
  /// Set to `null` to disable heartbeats.
  final Duration? heartbeatInterval;

  /// Payload sent as the ping message (server-specific, may be `"ping"` or `"{}"`).
  final String heartbeatPayload;

  /// How long to wait for the server to respond to a ping before treating the
  /// connection as stale and triggering a reconnect.
  final Duration heartbeatTimeout;

  /// Optional bearer token appended as a query parameter `?token=<value>`.
  /// Prefer passing tokens via headers when the server supports it; many WS
  /// servers only support query-param auth during the HTTP upgrade handshake.
  final String? authToken;

  /// Additional query parameters appended to [url] on connect.
  final Map<String, String> queryParameters;

  const WebSocketConfig({
    required this.url,
    this.maxReconnectAttempts = 5,
    this.initialReconnectDelay = const Duration(seconds: 1),
    this.maxReconnectDelay = const Duration(seconds: 30),
    this.heartbeatInterval = const Duration(seconds: 25),
    this.heartbeatPayload = 'ping',
    this.heartbeatTimeout = const Duration(seconds: 10),
    this.authToken,
    this.queryParameters = const {},
  });

  /// Builds the final connection [Uri] including query parameters and auth token.
  Uri get resolvedUri {
    final params = Map<String, String>.from(queryParameters);
    if (authToken != null && authToken!.isNotEmpty) {
      params['token'] = authToken!;
    }
    final base = Uri.parse(url);
    return base.replace(
      queryParameters: {...base.queryParameters, ...params},
    );
  }

  WebSocketConfig copyWith({
    String? url,
    int? maxReconnectAttempts,
    Duration? initialReconnectDelay,
    Duration? maxReconnectDelay,
    Duration? heartbeatInterval,
    String? heartbeatPayload,
    Duration? heartbeatTimeout,
    String? authToken,
    Map<String, String>? queryParameters,
  }) {
    return WebSocketConfig(
      url: url ?? this.url,
      maxReconnectAttempts: maxReconnectAttempts ?? this.maxReconnectAttempts,
      initialReconnectDelay:
          initialReconnectDelay ?? this.initialReconnectDelay,
      maxReconnectDelay: maxReconnectDelay ?? this.maxReconnectDelay,
      heartbeatInterval: heartbeatInterval ?? this.heartbeatInterval,
      heartbeatPayload: heartbeatPayload ?? this.heartbeatPayload,
      heartbeatTimeout: heartbeatTimeout ?? this.heartbeatTimeout,
      authToken: authToken ?? this.authToken,
      queryParameters: queryParameters ?? this.queryParameters,
    );
  }

  @override
  String toString() =>
      'WebSocketConfig(url: $url, maxReconnectAttempts: $maxReconnectAttempts, '
      'heartbeatInterval: $heartbeatInterval)';
}
