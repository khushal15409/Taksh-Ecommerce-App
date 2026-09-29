import 'dart:convert';

import 'package:taksh_e_commerce/core/websocket/cubit/live_feed_cubit.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/live_order_tracking_data.dart';

/// Live-feed cubit that streams real-time order tracking updates.
///
/// **How to use in a widget:**
///
/// ```dart
/// // 1. Obtain from DI (registered in order_di.dart)
/// final cubit = context.read<LiveOrderTrackingCubit>();
///
/// // 2. Start streaming for a specific order
/// cubit.startTracking('ORDER-123');
///
/// // 3. React to state changes
/// BlocBuilder<LiveOrderTrackingCubit, LiveFeedState<LiveOrderTrackingData>>(
///   builder: (context, state) => switch (state) {
///     LiveFeedData<LiveOrderTrackingData>(:final data) =>
///       Text('Status: ${data.status}, ETA: ${data.etaMinutes} min'),
///     LiveFeedConnecting() => const CircularProgressIndicator(),
///     LiveFeedReconnecting(:final attempt) =>
///       Text('Reconnecting (attempt $attempt)…'),
///     LiveFeedError(:final message) => Text('Error: $message'),
///     _ => const SizedBox.shrink(),
///   },
/// )
///
/// // 4. Stop tracking when done (e.g. order delivered)
/// cubit.stopTracking();
/// ```
///
/// **Wiring in DI (order_di.dart):**
/// ```dart
/// getIt.registerFactory(
///   () => LiveOrderTrackingCubit(
///     getIt<WebSocketManagerFactory>().create(
///       WebSocketConfig(
///         url: 'wss://example.com/ws/orders',   // replace with real URL
///         maxReconnectAttempts: 8,
///       ),
///     ),
///   ),
/// );
/// ```
class LiveOrderTrackingCubit extends LiveFeedCubit<LiveOrderTrackingData> {
  LiveOrderTrackingCubit(super.manager);

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Connects and sends a subscription request for [orderId].
  ///
  /// The server is expected to start pushing [LiveOrderTrackingData] payloads
  /// for the given order after receiving this message.
  Future<void> startTracking(String orderId) async {
    await connect();
    // Send subscription payload once connected.
    // Adjust the message format to match your server's protocol.
    try {
      send(jsonEncode({
        'action': 'subscribe',
        'channel': 'order_tracking',
        'order_id': orderId,
      }));
    } catch (_) {
      // The socket may not be fully open yet on the first call; the manager
      // will deliver the message once reconnected.  In production you may
      // want to queue the subscription message and re-send on WsConnected.
    }
  }

  /// Sends an unsubscribe message and disconnects.
  Future<void> stopTracking() async {
    try {
      send(jsonEncode({
        'action': 'unsubscribe',
        'channel': 'order_tracking',
      }));
    } catch (_) {}
    await disconnect();
  }

  // ── LiveFeedCubit override ──────────────────────────────────────────────────

  @override
  LiveOrderTrackingData? parseMessage(String frame) {
    final json = jsonDecode(frame) as Map<String, dynamic>;

    // Skip non-data frames (heartbeats, acks, etc.)
    final type = json['type']?.toString();
    if (type == 'pong' ||
        type == 'connection_ack' ||
        type == 'subscription_ack') {
      return null;
    }

    // The actual data payload may be nested under a 'data' key.
    final data =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;

    return LiveOrderTrackingData.fromJson(data);
  }
}
