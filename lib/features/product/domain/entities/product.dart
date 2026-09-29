import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/brand.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_variant.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_image.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/rating_summary.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/review.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/question_answer.dart';

/// Product entity representing a product in the domain layer
class Product extends Equatable {
  final int id;
  final int categoryId;
  final int? brandId;
  final int? fulfillmentCenterId;
  final String name;
  final String slug;
  final String? description;
  final String? shortDescription;
  final String status;
  final bool isTrending;
  final bool isLatest;
  final bool isExpress30;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Brand? brand;
  final Category? category;
  final List<ProductVariant>? variants;
  final List<ProductImage>? images;
  final RatingSummary? ratingSummary;
  final List<Review>? reviews;
  final List<QuestionAnswer>? questionsAnswers;
  final int? originalPrice;
  final int? salePrice;
  final String? discountLabel;
  final int? saleId;

  /// Whether the product is currently in stock (from API `in_stock` field)
  final bool inStock;

  /// Message shown when product is out of stock (from API `out_of_stock_message`)
  final String? outOfStockMessage;

  const Product({
    required this.id,
    required this.categoryId,
    this.brandId,
    this.fulfillmentCenterId,
    required this.name,
    required this.slug,
    this.description,
    this.shortDescription,
    required this.status,
    required this.isTrending,
    required this.isLatest,
    required this.isExpress30,
    this.createdAt,
    this.updatedAt,
    this.brand,
    this.category,
    this.variants,
    this.images,
    this.ratingSummary,
    this.reviews,
    this.questionsAnswers,
    this.originalPrice,
    this.salePrice,
    this.discountLabel,
    this.saleId,
    this.inStock = true,
    this.outOfStockMessage,
  });

  /// Create an empty product
  factory Product.empty() {
    return const Product(
      id: 0,
      categoryId: 0,
      brandId: null,
      name: '',
      slug: '',
      status: '',
      isTrending: false,
      isLatest: false,
      isExpress30: false,
    );
  }

  /// Check if product is empty
  bool get isEmpty => id == 0;

  /// Check if product is not empty
  bool get isNotEmpty => id != 0;

  /// Check if product has discount
  bool get hasDiscount =>
      originalPrice != null && salePrice != null && salePrice! < originalPrice!;

  /// Returns a copy of this product with overridden stock status.
  /// Used when the product details API does not return `in_stock` (defaults to
  /// true) but the listing API gave a reliable false value.
  Product copyWithStockStatus({
    required bool inStock,
    String? outOfStockMessage,
  }) {
    return Product(
      id: id,
      categoryId: categoryId,
      brandId: brandId,
      fulfillmentCenterId: fulfillmentCenterId,
      name: name,
      slug: slug,
      description: description,
      shortDescription: shortDescription,
      status: status,
      isTrending: isTrending,
      isLatest: isLatest,
      isExpress30: isExpress30,
      createdAt: createdAt,
      updatedAt: updatedAt,
      brand: brand,
      category: category,
      variants: variants,
      images: images,
      ratingSummary: ratingSummary,
      reviews: reviews,
      questionsAnswers: questionsAnswers,
      originalPrice: originalPrice,
      salePrice: salePrice,
      discountLabel: discountLabel,
      saleId: saleId,
      inStock: inStock,
      outOfStockMessage: outOfStockMessage,
    );
  }

  String? _resolvePrimaryFromImages(List<ProductImage>? productImages) {
    if (productImages == null || productImages.isEmpty) return null;

    for (final image in productImages) {
      final imageUrl = image.imageUrl?.trim();
      if (image.isPrimary && imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }

    for (final image in productImages) {
      final imageUrl = image.imageUrl?.trim();
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }

    return null;
  }

  /// Get primary image URL
  String? get primaryImageUrl {
    final productImageUrl = _resolvePrimaryFromImages(images);
    if (productImageUrl != null) {
      return productImageUrl;
    }

    if (variants != null) {
      for (final variant in variants!) {
        final variantImageUrl = _resolvePrimaryFromImages(variant.images);
        if (variantImageUrl != null) {
          return variantImageUrl;
        }
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    brandId,
    fulfillmentCenterId,
    name,
    slug,
    description,
    shortDescription,
    status,
    isTrending,
    isLatest,
    isExpress30,
    createdAt,
    updatedAt,
    brand,
    category,
    variants,
    images,
    ratingSummary,
    reviews,
    questionsAnswers,
    originalPrice,
    salePrice,
    discountLabel,
    saleId,
    inStock,
    outOfStockMessage,
  ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, slug: $slug, status: $status)';
  }
}
