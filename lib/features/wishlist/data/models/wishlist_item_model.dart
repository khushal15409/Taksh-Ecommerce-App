import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';

/// Model for wishlist item – extends the domain entity with JSON serialization.
///
/// Handles nested product data from the API response, falling back to
/// flat keys when the nested `product` object is not present.
class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    super.productSlug,
    super.productImage,
    super.originalPrice,
    super.salePrice,
    super.inStock,
    super.createdAt,
  });

  /// Parse from JSON – handles both nested and flat product data.
  ///
  /// Nested format (common):
  /// ```json
  /// {
  ///   "id": 1,
  ///   "product_id": 5,
  ///   "product": { "id": 5, "name": "...", "images": [...], ... }
  /// }
  /// ```
  ///
  /// Flat format (fallback):
  /// ```json
  /// {
  ///   "id": 1,
  ///   "product_id": 5,
  ///   "product_name": "...",
  ///   "product_image": "..."
  /// }
  /// ```
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;

    // ── Extract product ID ─────────────────────────────────────────────
    // Check multiple possible key names (snake_case, camelCase, nested)
    final int parsedProductId = _parseInt(json['product_id']) ??
        _parseInt(json['productId']) ??
        _parseInt(product?['id']) ??
        _parseInt(json['id']) ??
        0;

    // ── Extract product name ───────────────────────────────────────────
    final String parsedName = (product?['name'] as String?) ??
        (json['product_name'] as String?) ??
        (json['productName'] as String?) ??
        (json['name'] as String?) ??
        '';

    // ── Extract primary image URL ──────────────────────────────────────
    // Follows the same proven pattern as home ProductModel.fromJson:
    //   1. Direct image_url on the product object
    //   2. Walk the images array, prefer is_primary == true
    //   3. Fall back to first image in the array
    //   4. Flat fallback keys
    String? imageUrl;
    if (product != null) {
      // 1️⃣ Direct image_url on product (common in list responses)
      imageUrl = product['image_url'] as String?;

      // 2️⃣ Walk images array – prefer is_primary, else first image
      if (imageUrl == null || imageUrl.isEmpty) {
        final imagesData = product['images'];
        if (imagesData is List && imagesData.isNotEmpty) {
          for (final img in imagesData) {
            if (img is Map && img['is_primary'] == true) {
              imageUrl = img['image_url'] as String?;
              break;
            }
          }
          // 3️⃣ Fall back to first image
          if ((imageUrl == null || imageUrl.isEmpty) &&
              imagesData.first is Map) {
            imageUrl = (imagesData.first as Map)['image_url'] as String?;
          }
        }
      }

      imageUrl ??= product['primary_image_url'] as String?;
      imageUrl ??= product['image'] as String?;
      imageUrl ??= product['thumbnail'] as String?;
      imageUrl ??= product['thumbnail_url'] as String?;
    }

    // Flat fallback keys on the wishlist item itself
    imageUrl ??= json['thumbnail'] as String?;
    imageUrl ??= json['thumbnail_url'] as String?;
    imageUrl ??= json['product_image'] as String?;
    imageUrl ??= json['image'] as String?;
    imageUrl ??= json['image_url'] as String?;

    // ── Extract slug ───────────────────────────────────────────────────
    final String? parsedSlug = (product?['slug'] as String?) ??
        (json['product_slug'] as String?) ??
        (json['slug'] as String?);

    // ── Extract prices ─────────────────────────────────────────────────
    final int? parsedOriginalPrice = _parseInt(product?['original_price']) ??
        _parseInt(json['original_price']) ??
        _parseInt(product?['price']) ??
        _parseInt(json['price']);

    final int? parsedSalePrice = _parseInt(product?['sale_price']) ??
        _parseInt(json['sale_price']);

    // ── Extract stock status ───────────────────────────────────────────
    final bool parsedInStock = (product?['in_stock'] as bool?) ??
        (json['in_stock'] as bool?) ??
        true;

    return WishlistItemModel(
      id: _parseInt(json['wishlist_id']) ?? _parseInt(json['id']) ?? 0,
      productId: parsedProductId,
      productName: parsedName,
      productSlug: parsedSlug,
      productImage: imageUrl,
      originalPrice: parsedOriginalPrice,
      salePrice: parsedSalePrice,
      inStock: parsedInStock,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null),
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_slug': productSlug,
      'product_image': productImage,
      'original_price': originalPrice,
      'sale_price': salePrice,
      'in_stock': inStock,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Safely parse an int from dynamic (handles String, int, double, null)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
