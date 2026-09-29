import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';

/// Categories catalog section displaying parent categories with subcategory grid.
class CategoryCatalogSection extends StatefulWidget {
  final List<Category>? categories;
  final int maxSubcategories;
  final String? deliveryType;

  const CategoryCatalogSection({
    super.key,
    this.categories,
    this.maxSubcategories = 8,
    this.deliveryType,
  });

  @override
  State<CategoryCatalogSection> createState() => _CategoryCatalogSectionState();
}

class _CategoryCatalogSectionState extends State<CategoryCatalogSection> {
  List<Category> _cachedCategories = const [];

  @override
  void didUpdateWidget(covariant CategoryCatalogSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasRenderableCategories(widget.categories)) {
      _cachedCategories = widget.categories!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasRenderableCategories(widget.categories)) {
      _cachedCategories = widget.categories!;
      return _buildCatalog(context, widget.categories!);
    }

    if (_hasRenderableCategories(_cachedCategories)) {
      return _buildCatalog(context, _cachedCategories);
    }

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is CategoryLoaded &&
            _hasRenderableCategories(state.categories)) {
          _cachedCategories = state.categories;
          return _buildCatalog(context, state.categories);
        }

        return const SizedBox.shrink();
      },
    );
  }

  bool _hasRenderableCategories(List<Category>? categories) {
    if (categories == null || categories.isEmpty) return false;

    return categories
        .where((category) => category.parentId == null)
        .any((category) => category.children?.isNotEmpty ?? false);
  }

  Widget _buildCatalog(BuildContext context, List<Category> categories) {
    final parentCategories =
        categories.where((category) => category.parentId == null).toList();

    if (parentCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: parentCategories
            .where((category) => category.children?.isNotEmpty ?? false)
            .map((category) => _CategoryBlock(
                  category: category,
                  maxSubcategories: widget.maxSubcategories,
                  deliveryType: widget.deliveryType,
                ))
            .toList(),
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  final Category category;
  final int maxSubcategories;
  final String? deliveryType;

  const _CategoryBlock({
    required this.category,
    required this.maxSubcategories,
    this.deliveryType,
  });

  @override
  Widget build(BuildContext context) {
    final subcategories =
        (category.children ?? []).take(maxSubcategories).toList();

    if (subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bar with accent line
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.06),
                    Theme.of(context).cardColor,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(
                        AppRoutes.categoriesToCategory(
                          category.id,
                          deliveryType: deliveryType,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.primaryOrange.withOpacity(0.85),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Grid of subcategories
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 14),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: subcategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  return _SubcategoryTile(
                    subcategory: subcategory,
                    parentCategoryId: category.id,
                    deliveryType: deliveryType,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  final Category subcategory;
  final int parentCategoryId;
  final String? deliveryType;

  const _SubcategoryTile({
    required this.subcategory,
    required this.parentCategoryId,
    this.deliveryType,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = subcategory.imageUrl ?? subcategory.iconUrl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        context.go(
          AppRoutes.categoriesToCategory(
            parentCategoryId,
            subcategoryId: subcategory.id,
            deliveryType: deliveryType,
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.withOpacity(0.1) : const Color(0xFFF7F7F8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: ClipOval(
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.grey300,
                              size: 22,
                            ),
                          )
                        : const Icon(
                            Icons.category_outlined,
                            color: AppColors.grey300,
                            size: 26,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subcategory.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.15,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
