import 'package:equatable/equatable.dart';

/// Snapshot of a live order tracking event pushed by the server.
///
/// Produced by [LiveOrderTrackingCubit.parseMessage].  Extend or replace
/// with your real domain model once the API contract is finalised.
class LiveOrderTrackingData extends Equatable {
  /// Order identifier this event belongs to.
  final String orderId;

  /// Current delivery status, e.g. "ACCEPTED", "PICKED_UP", "OUT_FOR_DELIVERY".
  final String status;

  /// Human-readable status message.
  final String? statusMessage;

  /// Delivery agent's current latitude (may be null if not shared yet).
  final double? agentLatitude;

  /// Delivery agent's current longitude.
  final double? agentLongitude;

  /// Server-side timestamp of this event (ISO-8601 string).
  final DateTime? eventTime;

  /// Estimated time of arrival in minutes, if provided by the server.
  final int? etaMinutes;

  const LiveOrderTrackingData({
    required this.orderId,
    required this.status,
    this.statusMessage,
    this.agentLatitude,
    this.agentLongitude,
    this.eventTime,
    this.etaMinutes,
  });

  bool get hasAgentLocation => agentLatitude != null && agentLongitude != null;

  factory LiveOrderTrackingData.fromJson(Map<String, dynamic> json) {
    return LiveOrderTrackingData(
      orderId: json['order_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'UNKNOWN',
      statusMessage: json['status_message']?.toString(),
      agentLatitude: (json['agent_lat'] as num?)?.toDouble(),
      agentLongitude: (json['agent_lng'] as num?)?.toDouble(),
      eventTime: json['event_time'] != null
          ? DateTime.tryParse(json['event_time'].toString())
          : null,
      etaMinutes: json['eta_minutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'status': status,
        if (statusMessage != null) 'status_message': statusMessage,
        if (agentLatitude != null) 'agent_lat': agentLatitude,
        if (agentLongitude != null) 'agent_lng': agentLongitude,
        if (eventTime != null) 'event_time': eventTime!.toIso8601String(),
        if (etaMinutes != null) 'eta_minutes': etaMinutes,
      };

  LiveOrderTrackingData copyWith({
    String? orderId,
    String? status,
    String? statusMessage,
    double? agentLatitude,
    double? agentLongitude,
    DateTime? eventTime,
    int? etaMinutes,
  }) {
    return LiveOrderTrackingData(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      agentLatitude: agentLatitude ?? this.agentLatitude,
      agentLongitude: agentLongitude ?? this.agentLongitude,
      eventTime: eventTime ?? this.eventTime,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        status,
        statusMessage,
        agentLatitude,
        agentLongitude,
        eventTime,
        etaMinutes,
      ];

  @override
  String toString() =>
      'LiveOrderTrackingData(orderId: $orderId, status: $status, '
      'eta: $etaMinutes min)';
}
