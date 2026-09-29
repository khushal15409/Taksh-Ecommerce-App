import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_product_variant.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_product_model.dart';

part 'order_product_variant_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderProductVariantModel extends OrderProductVariant {
  @JsonKey(name: 'product')
  final OrderProductModel? productModel;

  const OrderProductVariantModel({
    required super.id,
    required super.productId,
    required super.sku,
    required super.price,
    required super.salePrice,
    super.weight,
    super.length,
    super.width,
    super.height,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    this.productModel,
  }) : super(product: productModel);

  factory OrderProductVariantModel.fromJson(DataMap json) {
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

    String? parseOptionalString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString();
    }

    String parseString(dynamic value, {String fallback = ''}) {
      return parseOptionalString(value) ?? fallback;
    }

    DateTime parseDate(dynamic value) {
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    final productJson = json['product'];

    return OrderProductVariantModel(
      id: parseRequiredInt(json['id']),
      productId: parseRequiredInt(json['product_id']),
      sku: parseString(json['sku']),
      price: parseString(json['price'], fallback: '0'),
      salePrice: parseString(json['sale_price'], fallback: '0'),
      weight: parseOptionalString(json['weight']),
      length: parseOptionalString(json['length']),
      width: parseOptionalString(json['width']),
      height: parseOptionalString(json['height']),
      status: parseString(json['status'], fallback: 'active'),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at'] ?? json['created_at']),
      productModel: productJson is Map<String, dynamic>
          ? OrderProductModel.fromJson(productJson)
          : null,
    );
  }

  DataMap toJson() => _$OrderProductVariantModelToJson(this);
}
