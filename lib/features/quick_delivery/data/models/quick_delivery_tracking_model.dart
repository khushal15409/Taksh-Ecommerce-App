import 'package:taksh_e_commerce/features/quick_delivery/domain/entities/quick_delivery_tracking.dart';

class QuickDeliveryTrackingModel extends QuickDeliveryTracking {
  const QuickDeliveryTrackingModel({
    required super.orderId,
    required super.orderStatus,
    required super.riderLocation,
    required super.message,
  });

  factory QuickDeliveryTrackingModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final locationRaw =
        data['location'] ??
        data['rider_location'] ??
        data['riderLocation'] ??
        data['delivery_location'] ??
        json['location'] ??
        json['rider_location'] ??
        json['riderLocation'] ??
        json['delivery_location'];

    return QuickDeliveryTrackingModel(
      orderId: _toInt(data['order_id'] ?? data['id'] ?? json['order_id']) ?? 0,
      orderStatus:
          (data['order_status'] ?? data['status'] ?? json['order_status'] ?? '')
              .toString(),
      riderLocation:
          _parseLocation(locationRaw) ??
          _parseLocation(data) ??
          _parseLocation(json),
      message:
          ((data['message'] ?? data['tracking_message'] ?? json['message']) ??
                  '')
              .toString(),
    );
  }

  static GeoPoint? _parseLocation(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;

    for (final nestedKey in const [
      'location',
      'rider_location',
      'riderLocation',
      'delivery_location',
      'coordinates',
    ]) {
      final nested = raw[nestedKey];
      if (nested is Map<String, dynamic>) {
        final parsed = _parseLocation(nested);
        if (parsed != null) {
          return parsed;
        }
      }
    }

    final lat = _toDouble(
      raw['lat'] ??
          raw['latitude'] ??
          raw['customer_lat'] ??
          raw['customer_latitude'] ??
          raw['rider_lat'] ??
          raw['rider_latitude'] ??
          raw['delivery_lat'] ??
          raw['delivery_latitude'],
    );
    final lng = _toDouble(
      raw['lng'] ??
          raw['lon'] ??
          raw['long'] ??
          raw['longitude'] ??
          raw['customer_lng'] ??
          raw['customer_longitude'] ??
          raw['rider_lng'] ??
          raw['rider_longitude'] ??
          raw['delivery_lng'] ??
          raw['delivery_longitude'],
    );

    if (lat == null || lng == null) return null;
    return GeoPoint(latitude: lat, longitude: lng);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
