import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Categories section - browse all food categories
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categories = [
      _CategoryData(
        icon: Icons.fastfood,
        name: 'Fast Food',
        itemCount: 120,
        color: colorScheme.primary,
      ),
      _CategoryData(
        icon: Icons.local_pizza,
        name: 'Pizza',
        itemCount: 85,
        color: colorScheme.secondary,
      ),
      _CategoryData(
        icon: Icons.restaurant,
        name: 'Fine Dining',
        itemCount: 45,
        color: colorScheme.tertiary,
      ),
      _CategoryData(
        icon: Icons.cake,
        name: 'Desserts',
        itemCount: 95,
        color: colorScheme.error,
      ),
      _CategoryData(
        icon: Icons.local_cafe,
        name: 'Beverages',
        itemCount: 110,
        color: Colors.brown,
      ),
      _CategoryData(
        icon: Icons.breakfast_dining,
        name: 'Breakfast',
        itemCount: 75,
        color: Colors.orange,
      ),
      _CategoryData(
        icon: Icons.lunch_dining,
        name: 'Lunch',
        itemCount: 130,
        color: Colors.green,
      ),
      _CategoryData(
        icon: Icons.dinner_dining,
        name: 'Dinner',
        itemCount: 140,
        color: Colors.deepPurple,
      ),
      _CategoryData(
        icon: Icons.icecream,
        name: 'Ice Cream',
        itemCount: 60,
        color: Colors.pink,
      ),
      _CategoryData(
        icon: Icons.ramen_dining,
        name: 'Asian',
        itemCount: 90,
        color: Colors.red,
      ),
      _CategoryData(
        icon: Icons.local_bar,
        name: 'Bar & Grill',
        itemCount: 55,
        color: Colors.amber,
      ),
      _CategoryData(
        icon: Icons.bakery_dining,
        name: 'Bakery',
        itemCount: 70,
        color: Colors.deepOrange,
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              title: Text(
                'Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Implement search
                  },
                ),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchCategories,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to search
                  },
                  readOnly: true,
                ),
              ),
            ),

            // Categories Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return _CategoryGridItem(
                      category: category,
                      colorScheme: colorScheme,
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.paddingMD),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category data model
class _CategoryData {
  final IconData icon;
  final String name;
  final int itemCount;
  final Color color;

  _CategoryData({
    required this.icon,
    required this.name,
    required this.itemCount,
    required this.color,
  });
}

/// Category grid item widget
class _CategoryGridItem extends StatelessWidget {
  final _CategoryData category;
  final ColorScheme colorScheme;

  const _CategoryGridItem({
    required this.category,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        side: BorderSide(
          color: category.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category items
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                category.color.withOpacity(0.1),
                category.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingMD),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    size: 40,
                    color: category.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: category.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.itemCount} items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
