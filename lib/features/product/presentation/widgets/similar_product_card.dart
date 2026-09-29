import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';

/// Compact product card widget for displaying similar products
///
/// Used in horizontal scrollable lists on the product details page.
/// Shows product image, name, price, and discount badge.
class SimilarProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const SimilarProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width = 140,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with discount badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: _buildProductImage(),
                  ),
                  // Discount badge
                  if (product.hasDiscount && product.discountLabel != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.discountLabel!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Brand
                    if (product.brand != null) ...[
                      Text(
                        product.brand!.name,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    // Price row
                    const Spacer(),
                    _buildPriceRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = product.primaryImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 32),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.broken_image, size: 32),
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final hasDiscount = product.hasDiscount;
    final salePrice = product.salePrice;
    final originalPrice = product.originalPrice;

    return Row(
      children: [
        // Sale price (or original if no sale)
        Text(
          '₹${salePrice ?? originalPrice ?? 0}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        // Original price (crossed out)
        if (hasDiscount && originalPrice != null) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '₹$originalPrice',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
