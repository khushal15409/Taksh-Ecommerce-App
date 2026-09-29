import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

/// A single item in the categories sidebar
class CategorySidebarItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategorySidebarItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryOrange.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryOrange.withOpacity(0.35)
                  : Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCategoryImage(),
              const SizedBox(height: 6),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    final iconUrl = category.iconUrl ?? category.imageUrl;
    final accent = _accentColorForCategory(category.name);
    final iconColor = isSelected ? accent : accent.withOpacity(0.8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(isSelected ? 0.20 : 0.16),
            accent.withOpacity(isSelected ? 0.08 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? accent.withOpacity(0.45)
              : accent.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: iconUrl == null || iconUrl.isEmpty
            ? Icon(
                _iconForCategoryName(category.name),
                size: 18,
                color: iconColor,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: iconUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Icon(
                    _iconForCategoryName(category.name),
                    size: 18,
                    color: iconColor,
                  ),
                ),
              ),
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

  Color _accentColorForCategory(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('food') || lower.contains('restaurant')) {
      return const Color(0xFFF97316); // orange
    }
    if (lower.contains('grocery') || lower.contains('kirana')) {
      return const Color(0xFF22C55E); // green
    }
    if (lower.contains('snack') || lower.contains('chips')) {
      return const Color(0xFFF59E0B); // amber
    }
    if (lower.contains('beverage') || lower.contains('drink')) {
      return const Color(0xFF06B6D4); // cyan
    }
    if (lower.contains('dessert') || lower.contains('cake')) {
      return const Color(0xFFF43F5E); // rose
    }
    if (lower.contains('spice') || lower.contains('condiment')) {
      return const Color(0xFFEF4444); // red
    }
    if (lower.contains('breakfast')) {
      return const Color(0xFF8B5CF6); // violet
    }
    if (lower.contains('organic')) {
      return const Color(0xFF10B981); // emerald
    }
    if (lower.contains('international')) {
      return const Color(0xFF3B82F6); // blue
    }

    return _vibrantPalette[_hashNameToIndex(lower)];
  }

  int _hashNameToIndex(String value) {
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash % _vibrantPalette.length;
  }

  static const List<Color> _vibrantPalette = [
    Color(0xFFF97316), // orange
    Color(0xFF22C55E), // green
    Color(0xFF06B6D4), // cyan
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
    Color(0xFFEC4899), // pink
    Color(0xFFEF4444), // red
    Color(0xFFF59E0B), // amber
  ];
}
