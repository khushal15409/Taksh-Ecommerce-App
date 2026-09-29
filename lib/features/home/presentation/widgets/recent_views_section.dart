import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_view.dart';

/// Widget for displaying recently viewed products section
class RecentViewsSection extends StatelessWidget {
  final List<RecentView> recentViews;
  final Function(int productId) onProductTap;

  const RecentViewsSection({
    super.key,
    required this.recentViews,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentViews.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryOrange.withOpacity(0.15),
                        AppColors.primaryOrangeLight.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.history,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Recently Viewed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 170,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: recentViews.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final product = recentViews[index];
                return _RecentViewCard(
                  product: product,
                  onTap: () => onProductTap(product.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget for a recently viewed product
class _RecentViewCard extends StatelessWidget {
  final RecentView product;
  final VoidCallback onTap;

  const _RecentViewCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : AppColors.grey200.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (product.price > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryOrange.withOpacity(0.1),
                              AppColors.primaryOrangeLight.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${AppConstants.currencySymbol}${product.price}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.withOpacity(0.2)
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: CachedNetworkImage(
        imageUrl: product.thumbnail,
        width: double.infinity,
        height: 85,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 85,
          color: isDark ? Colors.grey.withOpacity(0.2) : AppColors.grey100,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 85,
          color: isDark ? Colors.grey.withOpacity(0.2) : AppColors.grey100,
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 32,
            color: AppColors.grey400,
          ),
        ),
      ),
    );
  }
}
