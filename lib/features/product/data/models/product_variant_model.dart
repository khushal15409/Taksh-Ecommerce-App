import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_variant.dart';
import 'package:taksh_e_commerce/features/product/data/models/variant_attribute_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_image_model.dart';

part 'product_variant_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductVariantModel extends ProductVariant {
  @JsonKey(name: 'variant_attributes')
  final List<VariantAttributeModel>? variantAttributeModels;

  @JsonKey(name: 'images')
  final List<ProductImageModel>? imageModels;

  @override
  @JsonKey(name: 'in_stock', defaultValue: true)
  final bool inStock;

  @override
  @JsonKey(name: 'available_stock')
  // ignore: overridden_fields
  final int? availableStock;

  @override
  @JsonKey(name: 'out_of_stock_message')
  final String? outOfStockMessage;

  @override
  @JsonKey(name: 'has_stock_info', defaultValue: false)
  final bool hasStockInfo;

  const ProductVariantModel({
    required super.id,
    required super.productId,
    required super.sku,
    required super.price,
    super.salePrice,
    super.weight,
    super.length,
    super.width,
    super.height,
    required super.status,
    super.createdAt,
    super.updatedAt,
    this.variantAttributeModels,
    this.imageModels,
    this.inStock = true,
    this.availableStock,
    this.outOfStockMessage,
    this.hasStockInfo = false,
  }) : super(
         variantAttributes: variantAttributeModels,
         images: imageModels,
         inStock: inStock,
         availableStock: availableStock,
         outOfStockMessage: outOfStockMessage,
         hasStockInfo: hasStockInfo,
       );

  factory ProductVariantModel.fromJson(DataMap json) {
    final processedJson = Map<String, dynamic>.from(json);
    final hasStockInfo =
        processedJson.containsKey('available_stock') ||
        processedJson.containsKey('stock_quantity') ||
        processedJson.containsKey('stock_qty') ||
        processedJson.containsKey('quantity') ||
        processedJson.containsKey('stock_status') ||
        processedJson.containsKey('in_stock');

    // Normalize stock quantity fields into `available_stock` so the
    // generated parser picks it up. Without this, variants that only
    // return `stock_quantity` / `stock_qty` / `quantity` end up with a
    // null `availableStock`, which the cart treats as "in stock" even
    // when the server has no inventory.
    if (processedJson['available_stock'] == null) {
      final stockQuantity =
          processedJson['stock_quantity'] ??
          processedJson['stock_qty'] ??
          processedJson['quantity'];
      if (stockQuantity != null) {
        if (stockQuantity is num) {
          processedJson['available_stock'] = stockQuantity.toInt();
        } else {
          processedJson['available_stock'] = int.tryParse(
            stockQuantity.toString(),
          );
        }
      }
    }

    // Express API may not return product_id or status for variants
    processedJson.putIfAbsent('product_id', () => 0);
    processedJson.putIfAbsent('status', () => 'active');
    processedJson.putIfAbsent('in_stock', () => true);
    processedJson.putIfAbsent('has_stock_info', () => hasStockInfo);
    return _$ProductVariantModelFromJson(processedJson);
  }

  DataMap toJson() => _$ProductVariantModelToJson(this);
}
