import 'package:json_annotation/json_annotation.dart';

/// Converter for handling price values that can come as either String or num from API
class PriceConverter implements JsonConverter<double, dynamic> {
  const PriceConverter();

  @override
  double fromJson(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  @override
  dynamic toJson(double value) => value;
}

/// Converter for handling string values that might come as objects or other types
class SafeStringConverter implements JsonConverter<String?, dynamic> {
  const SafeStringConverter();

  @override
  String? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      // If it's a map, try to extract a meaningful value
      if (value.containsKey('url')) return value['url'] as String?;
      if (value.containsKey('name')) return value['name'] as String?;
      return null;
    }
    return value.toString();
  }

  @override
  dynamic toJson(String? value) => value;
}
