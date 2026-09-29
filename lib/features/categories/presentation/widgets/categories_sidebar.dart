import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/categories/presentation/widgets/category_sidebar_item.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

/// Sidebar displaying the list of categories
class CategoriesSidebar extends StatelessWidget {
  final List<Category> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoriesSidebar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 82,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.light
                  ? [
                      const Color(0xFFFFF5E6),
                      const Color(0xFFFFFBF5),
                      const Color(0xFFF2FFF7),
                    ]
                  : [
                      Theme.of(context).cardColor,
                      Theme.of(context).cardColor.withOpacity(0.8),
                    ],
            ),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.7),
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Shop by',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Categories list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedIndex == index;

                    return CategorySidebarItem(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => onCategorySelected(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
