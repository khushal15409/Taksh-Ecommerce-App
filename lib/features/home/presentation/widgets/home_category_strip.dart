import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';

/// Horizontal strip of top-level categories shown on the home screen.
///
/// Fetches categories for the given delivery type through [ProductCubit]
/// (same call the home header used to make) and navigates to the category
/// screen on tap.
class HomeCategoryStrip extends StatefulWidget {
  final DeliveryType deliveryType;

  const HomeCategoryStrip({super.key, required this.deliveryType});

  @override
  State<HomeCategoryStrip> createState() => _HomeCategoryStripState();
}

class _HomeCategoryStripState extends State<HomeCategoryStrip> {
  static final _log = loggerWithContext({
    'feature': 'home',
    'widget': 'HomeCategoryStrip',
  });

  List<Category> _categories = const [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void didUpdateWidget(covariant HomeCategoryStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveryType != widget.deliveryType) {
      _fetchCategories();
    }
  }

  void _fetchCategories() {
    context.read<ProductCubit>().fetchCategories(
      deliveryType: _mapApiDeliveryType(widget.deliveryType),
    );
  }

  String _mapApiDeliveryType(DeliveryType type) {
    switch (type) {
      case DeliveryType.quick:
        return 'express_30';
      case DeliveryType.standard:
      case DeliveryType.services:
        return 'standard_delivery';
    }
  }

  String get _routeDeliveryType {
    switch (widget.deliveryType) {
      case DeliveryType.quick:
        return 'quick';
      case DeliveryType.services:
        return 'services';
      case DeliveryType.standard:
        return 'standard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is CategoryLoaded) {
          setState(() {
            _categories = state.categories
                .where((category) => category.parentId == null)
                .toList();
          });
        }
      },
      child: _categories.isEmpty
          ? const SizedBox.shrink()
          : SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    _buildItem(context, _categories[index]),
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context, Category category) {
    return InkWell(
      onTap: () {
        context.go(
          AppRoutes.categoriesToCategory(
            category.id,
            deliveryType: _routeDeliveryType,
          ),
        );
        _log.infoWithContext('Category tapped', {
          'category_id': category.id,
          'name': category.name,
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey200),
              ),
              child: _buildIcon(category),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey900,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Category category) {
    final iconUrl = category.iconUrl ?? category.imageUrl;
    final fallback = Icon(
      _iconForCategoryName(category.name),
      size: 26,
      color: AppColors.primaryOrange,
    );

    if (iconUrl == null || iconUrl.isEmpty) {
      return Center(child: fallback);
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: iconUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: fallback),
        errorWidget: (context, url, error) => Center(child: fallback),
      ),
    );
  }

  IconData _iconForCategoryName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('pizza')) return Icons.local_pizza;
    if (lower.contains('fast')) return Icons.fastfood;
    if (lower.contains('burger')) return Icons.lunch_dining;
    if (lower.contains('restaurant') || lower.contains('dining')) {
      return Icons.restaurant;
    }
    if (lower.contains('dessert') || lower.contains('cake')) {
      return Icons.cake;
    }
    if (lower.contains('beverage') || lower.contains('drink')) {
      return Icons.local_cafe;
    }
    if (lower.contains('coffee') || lower.contains('tea')) {
      return Icons.coffee;
    }
    if (lower.contains('breakfast')) return Icons.breakfast_dining;
    if (lower.contains('snack')) return Icons.cookie;
    if (lower.contains('bakery') || lower.contains('bread')) {
      return Icons.bakery_dining;
    }
    if (lower.contains('seafood') || lower.contains('fish')) {
      return Icons.set_meal;
    }
    if (lower.contains('fruit')) return Icons.local_florist;
    if (lower.contains('vegetable') || lower.contains('vegg')) {
      return Icons.spa;
    }
    if (lower.contains('meat') || lower.contains('chicken')) {
      return Icons.set_meal;
    }
    if (lower.contains('grocery')) return Icons.storefront;

    return Icons.category_outlined;
  }
}
