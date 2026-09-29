import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_product_variant_model.dart';

part 'order_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderItemModel extends OrderItem {
  @JsonKey(name: 'product_name')
  final String? productNameModel;

  @JsonKey(name: 'brand_name')
  final String? brandNameModel;

  @JsonKey(name: 'image')
  final String? imageModel;

  @JsonKey(name: 'product_variant')
  final OrderProductVariantModel? productVariantModel;

  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productVariantId,
    required super.qty,
    required super.price,
    this.productNameModel,
    this.brandNameModel,
    this.imageModel,
    required super.createdAt,
    required super.updatedAt,
    this.productVariantModel,
  }) : super(
         productName: productNameModel,
         brandName: brandNameModel,
         image: imageModel,
         productVariant: productVariantModel,
       );

  factory OrderItemModel.fromJson(DataMap json) {
    int parseRequiredInt(dynamic value, {int fallback = 0}) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    String? parseOptionalString(dynamic value) {
      if (value == null) return null;
      final normalized = value.toString().trim();
      if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
        return null;
      }
      return normalized;
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

    Map<String, dynamic>? parseDataMap(dynamic value) {
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      return null;
    }

    String? firstNonEmptyString(Iterable<dynamic> values) {
      for (final value in values) {
        final parsed = parseOptionalString(value);
        if (parsed != null) {
          return parsed;
        }
      }
      return null;
    }

    String? resolveImage(dynamic value) {
      if (value is List) {
        for (final item in value) {
          final imageUrl = resolveImage(item);
          if (imageUrl != null) {
            return imageUrl;
          }
        }
        return null;
      }

      if (value is Map) {
        final imageMap = Map<String, dynamic>.from(value);
        for (final key in const [
          'image_url',
          'url',
          'image',
          'src',
          'path',
          'thumbnail',
          'thumbnail_url',
          'primary_image_url',
          'product_image',
          'featured_image',
          'main_image',
        ]) {
          final imageUrl = parseOptionalString(imageMap[key]);
          if (imageUrl != null) {
            return imageUrl;
          }
        }

        return resolveImage(imageMap['images']);
      }

      return parseOptionalString(value);
    }

    final variantJson =
        parseDataMap(json['product_variant']) ?? parseDataMap(json['variant']);
    final productJson =
        parseDataMap(variantJson?['product']) ?? parseDataMap(json['product']);
    final brandJson = parseDataMap(productJson?['brand']);

    final resolvedImage = firstNonEmptyString([
      resolveImage(json['image']),
      resolveImage(json['image_url']),
      resolveImage(json['thumbnail']),
      resolveImage(json['thumbnail_url']),
      resolveImage(json['product_image']),
      resolveImage(variantJson?['image']),
      resolveImage(variantJson?['image_url']),
      resolveImage(variantJson?['thumbnail']),
      resolveImage(variantJson?['images']),
      resolveImage(productJson?['image']),
      resolveImage(productJson?['image_url']),
      resolveImage(productJson?['thumbnail']),
      resolveImage(productJson?['thumbnail_url']),
      resolveImage(productJson?['primary_image_url']),
      resolveImage(productJson?['product_image']),
      resolveImage(productJson?['featured_image']),
      resolveImage(productJson?['main_image']),
      resolveImage(productJson?['images']),
    ]);

    return OrderItemModel(
      id: parseRequiredInt(json['id']),
      orderId: parseRequiredInt(json['order_id']),
      productVariantId: parseRequiredInt(json['product_variant_id']),
      qty: parseRequiredInt(json['qty']),
      price: parseString(json['price'], fallback: '0'),
      productNameModel: firstNonEmptyString([
        json['product_name'],
        json['name'],
        variantJson?['product_name'],
        productJson?['name'],
      ]),
      brandNameModel: firstNonEmptyString([
        json['brand_name'],
        productJson?['brand_name'],
        brandJson?['name'],
      ]),
      imageModel: resolvedImage,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at'] ?? json['created_at']),
      productVariantModel: variantJson is Map<String, dynamic>
          ? OrderProductVariantModel.fromJson(variantJson)
          : null,
    );
  }

  DataMap toJson() => _$OrderItemModelToJson(this);
}
