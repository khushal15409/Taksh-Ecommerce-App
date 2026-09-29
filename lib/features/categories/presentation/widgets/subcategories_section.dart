import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

/// Section displaying subcategory selection dropdown
class SubcategoriesSection extends StatelessWidget {
  final Category category;
  final Category? selectedSubcategory;
  final ValueChanged<Category?> onSubcategoryChanged;

  const SubcategoriesSection({
    super.key,
    required this.category,
    required this.selectedSubcategory,
    required this.onSubcategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category name as header
          Text(
            category.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          // Dropdown for subcategories
          DropdownButtonFormField<Category>(
            initialValue: selectedSubcategory,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryOrange),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              isDense: true,
            ),
            hint: Text(
              'Select subcategory',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            items: category.children!.map((sub) {
              return DropdownMenuItem(
                value: sub,
                child: Text(
                  sub.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: onSubcategoryChanged,
          ),
        ],
      ),
    );
  }
}
