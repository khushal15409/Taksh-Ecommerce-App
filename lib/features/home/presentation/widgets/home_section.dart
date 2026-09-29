import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/core/utils/extensions.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_header.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Home section - main landing view with featured products and categories
class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              title: Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
              ],
            ),

            // Address Header
            SliverToBoxAdapter(
              child: Container(
                color: colorScheme.surface,
                child: const AddressHeader(),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchRestaurantsDishes,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to search page
                  },
                  readOnly: true,
                ),
              ),
            ),

            // Banner Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
                child: Container(
                  // height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withAlpha(0.8.toAlpha()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get 50% Off',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'On your first order',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to offers
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onPrimary,
                            foregroundColor: colorScheme.primary,
                          ),
                          child: const Text('Order Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _CategoryCard(
                            icon: Icons.fastfood,
                            label: 'Fast Food',
                            color: colorScheme.primary,
                          ),
                          _CategoryCard(
                            icon: Icons.local_pizza,
                            label: 'Pizza',
                            color: colorScheme.secondary,
                          ),
                          _CategoryCard(
                            icon: Icons.restaurant,
                            label: 'Fine Dining',
                            color: colorScheme.tertiary,
                          ),
                          _CategoryCard(
                            icon: Icons.cake,
                            label: 'Desserts',
                            color: colorScheme.error,
                          ),
                          _CategoryCard(
                            icon: Icons.local_cafe,
                            label: 'Beverages',
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Restaurants
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
                child: Text(
                  'Featured Restaurants',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Restaurant List
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.paddingMD),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _RestaurantCard(
                      name: 'Restaurant ${index + 1}',
                      cuisine: 'Italian, Chinese, Indian',
                      rating: 4.5,
                      deliveryTime: '30-40 min',
                      colorScheme: colorScheme,
                    );
                  },
                  childCount: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category card widget
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Restaurant card widget
class _RestaurantCard extends StatelessWidget {
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final ColorScheme colorScheme;

  const _RestaurantCard({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to restaurant details
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingMD),
          child: Row(
            children: [
              // Restaurant Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 40,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cuisine,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          deliveryTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
