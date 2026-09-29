import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_product.dart';

part 'order_product_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderProductModel extends OrderProduct {
  const OrderProductModel({
    required super.id,
    required super.categoryId,
    required super.brandId,
    super.fulfillmentCenterId,
    super.lmCenterId,
    super.vendorId,
    required super.name,
    required super.slug,
    super.description,
    super.shortDescription,
    required super.status,
    super.isTrending,
    super.isLatest,
    super.isExpress30,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderProductModel.fromJson(DataMap json) {
    int? parseOptionalInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseRequiredInt(dynamic value, {int fallback = 0}) {
      return parseOptionalInt(value) ?? fallback;
    }

    String parseString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is String) return value;
      return value.toString();
    }

    bool? parseOptionalBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == '1') return true;
        if (normalized == 'false' || normalized == '0') return false;
      }
      return null;
    }

    DateTime parseDate(dynamic value) {
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    return OrderProductModel(
      id: parseRequiredInt(json['id']),
      categoryId: parseRequiredInt(json['category_id']),
      brandId: parseOptionalInt(json['brand_id']),
      fulfillmentCenterId: parseOptionalInt(json['fulfillment_center_id']),
      lmCenterId: parseOptionalInt(json['lm_center_id']),
      vendorId: parseOptionalInt(json['vendor_id']),
      name: parseString(json['name'], fallback: 'Unknown Product'),
      slug: parseString(json['slug'], fallback: ''),
      description: json['description'] == null
          ? null
          : parseString(json['description']),
      shortDescription: json['short_description'] == null
          ? null
          : parseString(json['short_description']),
      status: parseString(json['status'], fallback: 'active'),
      isTrending: parseOptionalBool(json['is_trending']),
      isLatest: parseOptionalBool(json['is_latest']),
      isExpress30:
          parseOptionalBool(json['is_express30']) ??
          parseOptionalBool(json['is_express_30']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at'] ?? json['created_at']),
    );
  }

  DataMap toJson() => _$OrderProductModelToJson(this);
}
