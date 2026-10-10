import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/media_url.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

/// Horizontal strip of parent categories; the selected one is highlighted.
class CategoryChipStrip extends StatelessWidget {
  final List<Category> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoryChipStrip({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = index == selectedIndex;
          final imageUrl = resolveMediaUrl(category.iconUrl ?? category.imageUrl);
          final fallback = Icon(
            Icons.category_outlined,
            size: 22,
            color: isSelected ? Colors.white : AppColors.primaryOrange,
          );

          return InkWell(
            onTap: () => onCategorySelected(index),
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 66,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryOrange
                            : AppColors.grey200,
                      ),
                    ),
                    child: imageUrl == null || imageUrl.isEmpty
                        ? Center(child: fallback)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Center(child: fallback),
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.grey800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
