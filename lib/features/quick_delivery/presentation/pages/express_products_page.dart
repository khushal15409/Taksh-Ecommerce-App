import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/categories/presentation/widgets/category_product_card.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/express_products_cubit.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/express_products_state.dart';

/// Arguments passed when navigating to the express products page
class ExpressProductsArgs {
  final int categoryId;
  final String categoryName;
  final double latitude;
  final double longitude;
  final List<Category>? subcategories;

  const ExpressProductsArgs({
    required this.categoryId,
    required this.categoryName,
    required this.latitude,
    required this.longitude,
    this.subcategories,
  });
}

/// Page that displays express delivery products by category
class ExpressProductsPage extends StatelessWidget {
  final ExpressProductsArgs args;

  const ExpressProductsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpressProductsCubit>()
        ..fetchProducts(
          categoryId: args.categoryId,
          latitude: args.latitude,
          longitude: args.longitude,
        ),
      child: _ExpressProductsContent(args: args),
    );
  }
}

class _ExpressProductsContent extends StatefulWidget {
  final ExpressProductsArgs args;

  const _ExpressProductsContent({required this.args});

  @override
  State<_ExpressProductsContent> createState() =>
      _ExpressProductsContentState();
}

class _ExpressProductsContentState extends State<_ExpressProductsContent> {
  final ScrollController _scrollController = ScrollController();
  late int _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.args.categoryId;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExpressProductsCubit>().loadNextPage(
            categoryId: _selectedCategoryId,
            latitude: widget.args.latitude,
            longitude: widget.args.longitude,
          );
    }
  }

  void _onCategoryTap(int categoryId) {
    if (categoryId == _selectedCategoryId) return;
    setState(() => _selectedCategoryId = categoryId);
    context.read<ExpressProductsCubit>().fetchProducts(
          categoryId: categoryId,
          latitude: widget.args.latitude,
          longitude: widget.args.longitude,
        );
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.args.categoryName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          if (widget.args.subcategories != null &&
              widget.args.subcategories!.isNotEmpty)
            _buildSubcategoryBar(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildSubcategoryBar() {
    final subcategories = widget.args.subcategories!;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subcategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sub = subcategories[index];
          final isSelected = sub.id == _selectedCategoryId;
          return GestureDetector(
            onTap: () => _onCategoryTap(sub.id),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryOrange.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  sub.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryOrange
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ExpressProductsCubit, ExpressProductsState>(
      builder: (context, state) {
        if (state.status == ExpressProductsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOrange,
            ),
          );
        }

        if (state.status == ExpressProductsStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpressProductsCubit>().fetchProducts(
                            categoryId: _selectedCategoryId,
                            latitude: widget.args.latitude,
                            longitude: widget.args.longitude,
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final products = state.response?.products ?? [];

        if (state.status == ExpressProductsStatus.loaded && products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No products available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try selecting a different category',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.52,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length +
              (state.status == ExpressProductsStatus.loadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final product = products[index];
            return CategoryProductCard(
              product: product,
              showDeliveryTime: true,
            );
          },
        );
      },
    );
  }
}
