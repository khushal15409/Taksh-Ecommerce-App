import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';

import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/bottom_nav_bar.dart';

/// Main shell widget with bottom navigation bar
/// Provides a consistent navigation structure across the main app screens
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final CartCubit _cartCubit;
  late final WishlistCubit _wishlistCubit;

  /// Navigation items configuration
  static final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      labelKey: (context) => AppLocalizations.of(context)!.homeTab,
      route: AppRoutes.home,
    ),
    _NavItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      labelKey: (context) => AppLocalizations.of(context)!.categoriesTab,
      route: AppRoutes.categories,
    ),
    _NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      labelKey: (context) => AppLocalizations.of(context)!.cartTab,
      route: AppRoutes.cart,
    ),
    _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      labelKey: (context) => AppLocalizations.of(context)!.ordersTab,
      route: AppRoutes.orders,
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      labelKey: (context) => AppLocalizations.of(context)!.profileTab,
      route: AppRoutes.profile,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cartCubit = getIt<CartCubit>();
    _wishlistCubit = getIt<WishlistCubit>();
    _cartCubit.fetchAllCarts();
    _wishlistCubit.fetchWishlist();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  /// Update the current index based on the current route
  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _navItems.indexWhere(
      (item) => location.startsWith(item.route),
    );
    if (index != -1 && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Extracts the total item count from the current [CartState].
  ///
  /// Multiple states carry a [Cart] object (loaded, adding, updating, etc.).
  /// This helper centralises the extraction so the badge stays accurate
  /// across all transient operation states.
  int _extractCartItemCount(CartState state) {
    return switch (state) {
      CartLoaded(:final cart) => cart.totalItems,
      CartOperationSuccess(:final cart) => cart.totalItems,
      AddingToCart(:final currentCart) => currentCart?.totalItems ?? 0,
      UpdatingCartItem(:final currentCart) => currentCart?.totalItems ?? 0,
      RemovingFromCart(:final currentCart) => currentCart?.totalItems ?? 0,
      CartLoading(:final previousCart) => previousCart?.totalItems ?? 0,
      _ => 0,
    };
  }

  /// Handle navigation item tap
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      context.go(_navItems[index].route);
    }
  }

  Future<bool> _handleBack() async {
    final router = GoRouter.of(context);

    if (router.canPop()) {
      return true;
    }

    if (_currentIndex != 0) {
      _onItemTapped(0);
      return false;
    }

    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitAppTitle),
        content: Text(l10n.exitAppContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.exit),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Note: No BlocListener redirect to login on Unauthenticated.
    // Guest users browse freely; individual pages use GuestAuthWall
    // to guard authenticated-only content.
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) => getIt<DashboardBloc>(),
        ),
        BlocProvider<ExpressDashboardBloc>(
          create: (context) => getIt<ExpressDashboardBloc>(),
        ),
        BlocProvider<ProductCubit>(create: (context) => getIt<ProductCubit>()),
        // Cart/Wishlist are app-wide lazy singletons from GetIt.
        // Use `.value` so BlocProvider does not auto-close shared instances.
        BlocProvider<CartCubit>.value(value: _cartCubit),
        BlocProvider<WishlistCubit>.value(value: _wishlistCubit),
      ],
      child: WillPopScope(
        onWillPop: _handleBack,
        child: Scaffold(
          body: widget.child,
          bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) =>
                _extractCartItemCount(previous) !=
                _extractCartItemCount(current),
            builder: (context, state) {
              return CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                cartItemCount: _extractCartItemCount(state),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Navigation item configuration class
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String Function(BuildContext) labelKey;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.labelKey,
    required this.route,
  });
}
