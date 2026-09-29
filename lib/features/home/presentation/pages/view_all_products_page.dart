import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/product_card.dart';

class ViewAllProductsArgs {
  final String title;
  final List<ProductModel> products;

  const ViewAllProductsArgs({
    required this.title,
    required this.products,
  });
}

class ViewAllProductsPage extends StatefulWidget {
  final ViewAllProductsArgs args;

  const ViewAllProductsPage({
    super.key,
    required this.args,
  });

  @override
  State<ViewAllProductsPage> createState() => _ViewAllProductsPageState();
}

class _ViewAllProductsPageState extends State<ViewAllProductsPage> {
  late final TextEditingController _searchController;
  late List<ProductModel> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredProducts = widget.args.products;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = widget.args.products;
      } else {
        _filteredProducts = widget.args.products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query) ||
                  (product.brand ?? '').toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.args.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildSearchBar(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _buildProductsGrid(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.black.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchProducts,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.primaryOrangeLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.search, color: AppColors.black, size: 18),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noProductsFound,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        const spacing = 12.0;
        const crossAxisCount = 2;
        final itemWidth =
            (screenWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        const itemHeight = 310.0;
        final aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return ProductCard(
              product: product,
              variant: ProductCardVariant.standard,
              onTap: () => context.push(
                AppRoutes.productDetails(product.id),
                extra: {
                  'inStock': product.inStock,
                  'outOfStockMessage': product.outOfStockMessage,
                },
              ),
            );
          },
        );
      },
    );
  }
}
