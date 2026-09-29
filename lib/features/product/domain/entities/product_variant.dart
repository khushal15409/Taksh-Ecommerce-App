import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_image.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/variant_attribute.dart';

/// Product variant entity
class ProductVariant extends Equatable {
  final int id;
  final int productId;
  final String sku;
  final String price;
  final String? salePrice;
  final String? weight;
  final String? length;
  final String? width;
  final String? height;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<VariantAttribute>? variantAttributes;
  final List<ProductImage>? images;
  final bool inStock;
  final int? availableStock;
  final String? outOfStockMessage;
  final bool hasStockInfo;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    this.salePrice,
    this.weight,
    this.length,
    this.width,
    this.height,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.variantAttributes,
    this.images,
    this.inStock = true,
    this.availableStock,
    this.outOfStockMessage,
    this.hasStockInfo = false,
  });

  bool get isActive => status == 'active';

  bool get isAvailableForSale =>
      isActive && inStock && (availableStock == null || availableStock! > 0);

  @override
  List<Object?> get props => [
    id,
    productId,
    sku,
    price,
    salePrice,
    weight,
    length,
    width,
    height,
    status,
    createdAt,
    updatedAt,
    variantAttributes,
    images,
    inStock,
    availableStock,
    outOfStockMessage,
    hasStockInfo,
  ];
}
