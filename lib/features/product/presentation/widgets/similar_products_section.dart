import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/similar_products_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/similar_products_state.dart';
import 'package:taksh_e_commerce/features/product/presentation/widgets/similar_product_card.dart';

/// Section widget for displaying similar products in a horizontal scrollable list
///
/// Shows products from the same category as the current product.
/// Excludes the current product from the displayed list.
class SimilarProductsSection extends StatelessWidget {
  final String title;
  final double cardWidth;
  final double cardHeight;

  const SimilarProductsSection({
    super.key,
    this.title = 'Similar Products',
    this.cardWidth = 140,
    this.cardHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimilarProductsCubit, SimilarProductsState>(
      builder: (context, state) {
        if (state is SimilarProductsLoading) {
          return _buildLoadingState();
        }

        if (state is SimilarProductsError) {
          // Don't show error for similar products, just hide the section
          return const SizedBox.shrink();
        }

        if (state is SimilarProductsLoaded) {
          final products = state.filteredProducts;

          if (products.isEmpty) {
            return const SizedBox.shrink();
          }

          return _buildProductsSection(context, products);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4, // Shimmer placeholder count
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < 3 ? 12 : 0,
                ),
                child: _buildShimmerCard(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 14,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(BuildContext context, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (products.length > 4)
                TextButton(
                  onPressed: () {
                    // Navigate to category page with the product's category
                    if (products.isNotEmpty) {
                      context.push(
                        AppRoutes.categoriesToCategory(
                            products.first.categoryId),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < products.length - 1 ? 12 : 0,
                ),
                child: SimilarProductCard(
                  product: product,
                  width: cardWidth,
                  height: cardHeight,
                  onTap: () => _onProductTap(context, product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onProductTap(BuildContext context, Product product) {
    // Navigate to product details page
    context.push(
      AppRoutes.productDetails(product.id),
      extra: ProductDetailsExtra(
        inStock: product.inStock,
        outOfStockMessage: product.outOfStockMessage,
      ),
    );
  }
}
