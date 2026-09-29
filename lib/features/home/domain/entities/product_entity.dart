import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_variant_info.dart';

/// Product entity representing a product in dashboard sections
class ProductEntity extends Equatable {
  final int id;
  final int? productVariantId;
  final String name;
  final String? slug;
  final String? shortDescription;
  final double originalPrice;
  final double price;
  final double salePrice;
  final String? discountLabel;
  final int? saleId;
  final String? imageUrl;
  final String? brand;
  final double? averageRating;
  final int? totalReviews;

  /// Whether the product is currently in stock (from API `in_stock` field)
  final bool inStock;

  /// Message shown when product is out of stock (from API `out_of_stock_message`)
  final String? outOfStockMessage;

  /// List of available variants for this product (from API `variants` field).
  /// Used to show "X options" on the ADD button and the variant selection popup.
  final List<ProductVariantInfo>? variants;

  const ProductEntity({
    required this.id,
    this.productVariantId,
    required this.name,
    this.slug,
    this.shortDescription,
    required this.originalPrice,
    required this.price,
    required this.salePrice,
    this.discountLabel,
    this.saleId,
    this.imageUrl,
    this.brand,
    this.averageRating,
    this.totalReviews,
    this.inStock = true,
    this.outOfStockMessage,
    this.variants,
  });

  /// Whether this product has multiple variants to choose from
  bool get hasMultipleVariants =>
      variants != null && variants!.length > 1;

  /// Number of active variants
  int get activeVariantCount =>
      variants?.where((v) => v.isActive).length ?? 0;

  /// Check if product has a discount
  bool get hasDiscount => discountLabel != null && discountLabel!.isNotEmpty;

  /// Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - salePrice) / originalPrice) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        productVariantId,
        name,
        slug,
        shortDescription,
        originalPrice,
        price,
        salePrice,
        discountLabel,
        saleId,
        imageUrl,
        brand,
        averageRating,
        totalReviews,
        inStock,
        outOfStockMessage,
        variants,
      ];
}
