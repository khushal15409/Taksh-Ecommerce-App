import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_location.dart';

part 'order_location_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderLocationModel extends OrderLocation {
  const OrderLocationModel({
    required super.id,
    required super.name,
    super.parentId,
    super.pincode,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderLocationModel.fromJson(DataMap json) {
    int? parseOptionalInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    String parseString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is String) return value;
      return value.toString();
    }

    DateTime parseDate(dynamic value) {
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    // Handle different JSON structures for state, city, and area
    return OrderLocationModel(
      id: parseOptionalInt(json['id']) ?? 0,
      name: parseString(json['name'], fallback: 'Unknown'),
      parentId:
          parseOptionalInt(json['state_id']) ??
          parseOptionalInt(json['city_id']) ??
          parseOptionalInt(json['parent_id']),
      pincode: json['pincode'] == null ? null : parseString(json['pincode']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at'] ?? json['created_at']),
    );
  }

  DataMap toJson() => _$OrderLocationModelToJson(this);
}
