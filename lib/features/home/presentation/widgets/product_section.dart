import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_section_model.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/product_card.dart';

/// Section widget for displaying products in a responsive grid
/// Modern design with attractive section headers and smooth layouts
class ProductSection extends StatelessWidget {
  final DashboardSectionModel section;
  final Function(ProductModel)? onProductTap;
  final VoidCallback? onViewAllTap;
  final int gridColumns;
  final bool showDeliveryTime;

  const ProductSection({
    super.key,
    required this.section,
    this.onProductTap,
    this.onViewAllTap,
    this.gridColumns = 3,
    this.showDeliveryTime = false,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show empty sections
    if (!section.hasData) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern section header
          _buildSectionHeader(context),
          const SizedBox(height: 8),
          // Product grid with improved spacing
          _buildProductGrid(context),
        ],
      ),
    );
  }

  /// Builds the modern section header with title and view all button
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section title with decorative accent
        Expanded(
          child: Row(
            children: [
              // Decorative accent bar
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.secondaryGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Section title
              Expanded(
                child: Text(
                  section.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // View All button with modern styling
        if (onViewAllTap != null) _buildViewAllButton(context),
      ],
    );
  }

  /// Builds the modern View All button
  Widget _buildViewAllButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewAllTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs + 2,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryOrange.withOpacity(0.1),
                AppColors.primaryOrangeLight.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the product grid with responsive columns
  Widget _buildProductGrid(BuildContext context) {
    // Determine variant based on grid columns
    final isCompactGrid = gridColumns >= 4;
    final cardVariant = isCompactGrid
        ? ProductCardVariant.compact
        : ProductCardVariant.standard;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // Tighter spacing for compact grids
        final spacing = isCompactGrid ? 8.0 : 10.0;
        final visibleColumns = gridColumns.clamp(2, 6);

        // Peek next column to hint horizontal scroll
        const peekFraction = 0.3;
        final itemWidth = (screenWidth - (spacing * (visibleColumns - 1))) /
            (visibleColumns + peekFraction);

        // Different base heights for redesigned cards
        final itemHeight = isCompactGrid ? 232.0 : 252.0;
        final aspectRatio = itemHeight / itemWidth;
        final gridHeight = (itemHeight * 2) + spacing;

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
              mainAxisExtent: itemWidth,
            ),
            itemCount: section.products.length,
            itemBuilder: (context, index) {
              final product = section.products[index];
              return ProductCard(
                product: product,
                variant: cardVariant,
                showDeliveryTime: showDeliveryTime,
                onTap: () => onProductTap?.call(product),
              );
            },
          ),
        );
      },
    );
  }
}
