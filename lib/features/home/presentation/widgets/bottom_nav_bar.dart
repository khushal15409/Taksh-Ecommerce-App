import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Custom bottom navigation bar with icons and labels
/// Provides navigation between five main sections
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMD,
            vertical: AppSpacing.paddingSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                label: l10n.homeTab,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: currentIndex == 1 ? Icons.grid_view_rounded : Icons.grid_view_outlined,
                label: l10n.categoriesTab,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: currentIndex == 2 ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                label: l10n.cartTab,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
                colorScheme: colorScheme,
                badgeCount: cartItemCount,
              ),
              _NavBarItem(
                icon: currentIndex == 3 ? Icons.receipt_long : Icons.receipt_long_outlined,
                label: l10n.ordersTab,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
                colorScheme: colorScheme,
              ),
              _NavBarItem(
                icon: currentIndex == 4 ? Icons.person_rounded : Icons.person_outline,
                label: l10n.profileTab,
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation bar item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final int badgeCount;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final color = isSelected 
        ? colorScheme.primary 
        : (isDark ? Colors.grey[400] : Colors.black);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingSM,
          vertical: AppSpacing.paddingXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: colorScheme.error,
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
