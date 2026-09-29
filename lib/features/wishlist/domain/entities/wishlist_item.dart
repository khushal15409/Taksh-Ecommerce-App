import 'package:equatable/equatable.dart';

/// Wishlist item entity representing a product in the user's wishlist
class WishlistItem extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String? productSlug;
  final String? productImage;
  final int? originalPrice;
  final int? salePrice;
  final bool inStock;
  final DateTime? createdAt;

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productSlug,
    this.productImage,
    this.originalPrice,
    this.salePrice,
    this.inStock = true,
    this.createdAt,
  });

  /// Create an empty wishlist item
  factory WishlistItem.empty() {
    return const WishlistItem(
      id: 0,
      productId: 0,
      productName: '',
    );
  }

  /// Check if wishlist item is empty
  bool get isEmpty => id == 0;

  /// Check if wishlist item is not empty
  bool get isNotEmpty => id != 0;

  /// Check if product has discount
  bool get hasDiscount =>
      originalPrice != null &&
      salePrice != null &&
      salePrice! < originalPrice!;

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productSlug,
        productImage,
        originalPrice,
        salePrice,
        inStock,
        createdAt,
      ];

  @override
  String toString() {
    return 'WishlistItem(id: $id, productId: $productId, productName: $productName)';
  }
}
