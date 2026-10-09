import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_section_model.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/product_card.dart';

/// Section widget showing a titled, horizontally scrolling row of product
/// cards. Sections without data render nothing.
class ProductSection extends StatelessWidget {
  final DashboardSectionModel section;
  final Function(ProductModel)? onProductTap;
  final VoidCallback? onViewAllTap;

  /// Approximate number of cards visible at once (the next card peeks in).
  /// Values of 4 or more switch to the compact card variant.
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

  /// Height of the card's text area below the (square) image.
  static const double _infoHeight = 112;

  @override
  Widget build(BuildContext context) {
    // Don't show empty sections
    if (!section.hasData) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakshSectionHeader(title: section.key, onViewAll: onViewAllTap),
          const SizedBox(height: 10),
          _buildProductRow(context),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context) {
    final isCompactGrid = gridColumns >= 4;
    final cardVariant = isCompactGrid
        ? ProductCardVariant.compact
        : ProductCardVariant.standard;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4);

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final visibleColumns = isCompactGrid ? 3 : 2;
        const peekFraction = 0.35;
        final itemWidth =
            (constraints.maxWidth - (spacing * (visibleColumns - 1))) /
            (visibleColumns + peekFraction);
        final rowHeight = itemWidth + (_infoHeight * textScale);

        return SizedBox(
          height: rowHeight + 6,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(bottom: 6),
            physics: const BouncingScrollPhysics(),
            itemCount: section.products.length,
            separatorBuilder: (context, index) => const SizedBox(width: spacing),
            itemBuilder: (context, index) {
              final product = section.products[index];
              return SizedBox(
                width: itemWidth,
                child: ProductCard(
                  product: product,
                  variant: cardVariant,
                  showDeliveryTime: showDeliveryTime,
                  onTap: () => onProductTap?.call(product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
