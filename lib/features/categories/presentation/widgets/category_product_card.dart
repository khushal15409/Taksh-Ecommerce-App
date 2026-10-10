import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/media_url.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/cart/presentation/widgets/product_add_to_cart_button.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_variant_info.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/widgets/wishlist_heart_button.dart';

/// Product card widget used in the categories page grid
class CategoryProductCard extends StatelessWidget {
  final Product product;
  final bool showDeliveryTime;

  const CategoryProductCard({
    super.key,
    required this.product,
    this.showDeliveryTime = true,
  });

  /// Get the first variant ID for cart functionality
  int? get _firstVariantId {
    if (product.variants == null || product.variants!.isEmpty) return null;
    return product.variants!.first.id;
  }

  int? get _discountPercentage {
    if (!product.hasDiscount) return null;
    final discount =
        ((product.originalPrice! - product.salePrice!) /
                product.originalPrice! *
                100)
            .round();
    return discount > 0 ? discount : null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = resolveMediaUrl(product.primaryImageUrl);
    final displayPrice = product.salePrice ?? product.originalPrice;
    final discount = _discountPercentage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.productDetails(product.id),
          extra: ProductDetailsExtra(
            inStock: product.inStock,
            outOfStockMessage: product.outOfStockMessage,
          ),
        ),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.grey200),
            boxShadow: takshSoftShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: _buildVisualCard(context, imageUrl, discount),
              ),
              const SizedBox(height: 8),
              if (showDeliveryTime) ...[
                _buildDeliveryChip(context),
                const SizedBox(height: 6),
              ],
              _buildName(context),
              _buildRating(),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompactWidth = constraints.maxWidth < 130;

                  if (isCompactWidth) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPriceSection(context, displayPrice, discount),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildAddButton(),
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _buildPriceSection(
                          context,
                          displayPrice,
                          discount,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildAddButton(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ProductAddToCartButton(
      productId: product.id,
      productVariantId: _firstVariantId,
      style: ProductAddToCartButtonStyle.outlinedGreen,
      inStock: product.inStock,
      isQuickDelivery: showDeliveryTime,
      variants: ProductVariantInfo.fromProductVariants(product.variants),
      productName: product.name,
      productImageUrl: resolveMediaUrl(product.primaryImageUrl),
    );
  }

  Widget _buildVisualCard(
    BuildContext context,
    String? imageUrl,
    int? discount,
  ) {
    const outerRadius = 18.0;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(outerRadius),
              color: Colors.white,
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => _buildShimmerPlaceholder(context),
                      errorWidget: (_, __, ___) =>
                          _buildPlaceholderImage(context),
                    )
                  : _buildPlaceholderImage(context),
            ),
          ),
        ),
        if (_buildVisualBadge(discount) case final badge?)
          Positioned(top: 10, left: 10, child: badge),
        Positioned(
          top: 8,
          right: 8,
          child: WishlistHeartButton(productId: product.id),
        ),
        if (!product.inStock)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(outerRadius),
              child: Container(
                color: Colors.black.withOpacity(0.18),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Out of Stock',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final label = (product.category?.name ?? product.name).trim();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.92),
            AppColors.primaryOrange.withOpacity(0.08),
            AppColors.secondaryGreen.withOpacity(0.08),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _iconForLabel(label),
            size: 34,
            color: AppColors.primaryOrange.withOpacity(0.9),
          ),
          const SizedBox(height: 6),
          Text(
            'No image',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildVisualBadge(int? discount) {
    if (discount != null) {
      return TakshDiscountBadge(percent: discount);
    }

    return null;
  }

  Widget _buildDeliveryChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flash_on_rounded,
            size: 13,
            color: AppColors.primaryOrange,
          ),
          SizedBox(width: 4),
          Text(
            '30 min',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the rating only when the backend provided one.
  Widget _buildRating() {
    final summary = product.ratingSummary;
    if (summary == null || summary.averageRating <= 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.rating),
          const SizedBox(width: 2),
          Text(
            summary.totalReviews > 0
                ? '${summary.averageRating.toStringAsFixed(1)} (${summary.totalReviews})'
                : summary.averageRating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        height: 1.12,
      ),
    );
  }

  Widget _buildPriceSection(
    BuildContext context,
    int? displayPrice,
    int? discount,
  ) {
    if (displayPrice == null) {
      return Text(
        'View details',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6,
      children: [
        Text(
          '₹${_formatPrice(displayPrice)}',
          maxLines: 1,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            height: 1.2,
          ),
        ),
        if (discount != null && product.originalPrice != null)
          Text(
            '₹${_formatPrice(product.originalPrice!)}',
            style: TextStyle(
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).textTheme.bodySmall?.color,
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  IconData _iconForLabel(String value) {
    final normalizedValue = value.toLowerCase();

    if (normalizedValue.contains('electronic') ||
        normalizedValue.contains('mobile') ||
        normalizedValue.contains('phone')) {
      return Icons.smartphone_rounded;
    }
    if (normalizedValue.contains('fashion') ||
        normalizedValue.contains('cloth') ||
        normalizedValue.contains('wear')) {
      return Icons.checkroom_rounded;
    }
    if (normalizedValue.contains('grocery') ||
        normalizedValue.contains('food')) {
      return Icons.local_grocery_store_rounded;
    }
    if (normalizedValue.contains('beauty') ||
        normalizedValue.contains('cosmetic')) {
      return Icons.spa_rounded;
    }
    if (normalizedValue.contains('furniture')) {
      return Icons.chair_alt_rounded;
    }
    if (normalizedValue.contains('auto')) {
      return Icons.directions_car_filled_rounded;
    }
    if (normalizedValue.contains('accessor')) {
      return Icons.watch_outlined;
    }
    if (normalizedValue.contains('footwear') ||
        normalizedValue.contains('shoe')) {
      return Icons.hiking_rounded;
    }

    return Icons.inventory_2_rounded;
  }

  String _formatPrice(num value) {
    final roundedValue = value.truncateToDouble();
    if (value.toDouble() == roundedValue) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}
