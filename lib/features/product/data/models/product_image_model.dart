import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_image.dart';

part 'product_image_model.g.dart';

/// Product image model with JSON serialization
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductImageModel extends ProductImage {
  @override
  @JsonKey(name: 'is_primary', defaultValue: false)
  final bool isPrimary;

  @override
  @JsonKey(name: 'sort_order', defaultValue: 0)
  final int sortOrder;

  const ProductImageModel({
    required super.id,
    required super.productId,
    super.productVariantId,
    super.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
    super.createdAt,
    super.updatedAt,
  }) : super(isPrimary: isPrimary, sortOrder: sortOrder);

  factory ProductImageModel.fromJson(DataMap json) {
    final processedJson = Map<String, dynamic>.from(json);
    // Express API may not return product_id for images
    processedJson.putIfAbsent('product_id', () => 0);
    return _$ProductImageModelFromJson(processedJson);
  }

  factory ProductImageModel.fromEntity(ProductImage image) {
    return ProductImageModel(
      id: image.id,
      productId: image.productId,
      productVariantId: image.productVariantId,
      imageUrl: image.imageUrl,
      isPrimary: image.isPrimary,
      sortOrder: image.sortOrder,
      createdAt: image.createdAt,
      updatedAt: image.updatedAt,
    );
  }

  DataMap toJson() => _$ProductImageModelToJson(this);
}
