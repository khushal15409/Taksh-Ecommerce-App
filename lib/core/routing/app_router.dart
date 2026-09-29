import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/add_address_page.dart';
import 'package:taksh_e_commerce/features/address/presentation/pages/address_list_page.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/pages/order_details_page.dart';
import 'package:taksh_e_commerce/features/splash/presentation/pages/splash_page.dart';
import 'package:taksh_e_commerce/features/home/presentation/pages/home_page.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/features/home/presentation/pages/main_shell.dart';
import 'package:taksh_e_commerce/features/categories/presentation/pages/categories_page.dart';
import 'package:taksh_e_commerce/features/cart/presentation/pages/cart_page.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart'
    as taksh_e_commerce;
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/orders/presentation/pages/orders_page.dart';
import 'package:taksh_e_commerce/features/profile/presentation/pages/profile_page.dart';
import 'package:taksh_e_commerce/features/product/presentation/pages/product_details_page.dart';
import 'package:taksh_e_commerce/features/home/presentation/pages/view_all_products_page.dart';
import 'package:taksh_e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:taksh_e_commerce/features/search/presentation/pages/search_page.dart';
import 'package:taksh_e_commerce/features/auth/presentation/pages/login_page.dart';
import 'package:taksh_e_commerce/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/pages/select_items_page.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/pages/checkout_page.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/pages/order_placed_page.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:taksh_e_commerce/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/selected_checkout_items.dart';
import 'package:taksh_e_commerce/features/payment/presentation/pages/payment_success_page.dart';
import 'package:taksh_e_commerce/features/payment/presentation/pages/payment_failed_page.dart';
import 'package:taksh_e_commerce/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/quick_delivery_tracking_cubit.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/pages/express_products_page.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/pages/quick_delivery_tracking_page.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:taksh_e_commerce/features/onboarding/presentation/pages/onboarding_page.dart';

import '../di/injector.dart';

/// Application router configuration using go_router
/// Handles all navigation logic with type safety and deep linking support
///
/// Why go_router:
/// - Type-safe navigation
/// - Deep linking support
/// - URL-based routing
/// - Nested navigation
/// - Guard/redirect support
/// - Better than default Navigator
///
/// Features:
/// - Centralized routing logic
/// - Global BLoC-based authentication
/// - Route guards for authentication
/// - Error handling (404 pages)
/// - Smooth transitions
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: _errorBuilder,
    redirect: _redirect,
  );

  /// Shell tab locations (bottom nav). These are established via [GoRouter.go]
  /// so [MainShell] stays in the tree.
  static const _shellPaths = {
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.cart,
    AppRoutes.orders,
    AppRoutes.profile,
  };

  /// Navigate after a successful login.
  ///
  /// A plain [GoRouter.go] to a top-level route (e.g. product details) replaces
  /// the entire stack, so the system/back-swipe gesture exits the app. For
  /// non-shell destinations we first establish home (shell), then [push] the
  /// destination so back returns to home.
  static void navigateAfterAuth(GoRouter router, {String? redirectAfter}) {
    final destination = redirectAfter?.trim();
    if (destination == null || destination.isEmpty) {
      router.go(AppRoutes.home);
      return;
    }

    final path = Uri.tryParse(destination)?.path ?? destination;
    if (_shellPaths.contains(path)) {
      router.go(destination);
      return;
    }

    router.go(AppRoutes.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.push(destination);
    });
  }

  /// Route definitions
  static final List<RouteBase> _routes = [
    // ==================== Splash Screen ====================
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // ==================== Auth Routes ====================
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) {
        final redirectAfter = state.uri.queryParameters['redirectAfter'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: LoginPage(redirectAfter: redirectAfter),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.verifyOtp,
      name: 'verify-otp',
      pageBuilder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        final guestToken = state.uri.queryParameters['guest_token'] ?? '';
        final redirectAfter = state.uri.queryParameters['redirect_after'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: VerifyOtpPage(
            phone: phone,
            guestToken: guestToken,
            redirectAfter: redirectAfter,
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    // ==================== Main Routes with Bottom Navigation ====================
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) {
            final delivery =
                state.uri.queryParameters[AppRoutes.deliveryTypeQueryKey];
            final initialDeliveryType = switch (delivery) {
              'quick' => DeliveryType.quick,
              'services' => DeliveryType.services,
              _ => DeliveryType.standard,
            };

            return CustomTransitionPage(
              key: state.pageKey,
              child: HomePage(initialDeliveryType: initialDeliveryType),
              transitionsBuilder: _fadeTransition,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.categories,
          name: 'categories',
          pageBuilder: (context, state) {
            final categoryId = state.uri.queryParameters['categoryId'];
            final subcategoryId = state.uri.queryParameters['subcategoryId'];
            final delivery =
                state.uri.queryParameters[AppRoutes.deliveryTypeQueryKey];
            final initialDeliveryType = switch (delivery) {
              'quick' => DeliveryType.quick,
              'services' => DeliveryType.services,
              _ => DeliveryType.standard,
            };
            return CustomTransitionPage(
              key: state.pageKey,
              child: CategoriesPage(
                initialCategoryId: categoryId != null
                    ? int.tryParse(categoryId)
                    : null,
                initialSubcategoryId: subcategoryId != null
                    ? int.tryParse(subcategoryId)
                    : null,
                initialDeliveryType: initialDeliveryType,
              ),
              transitionsBuilder: _fadeTransition,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.cart,
          name: 'cart',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CartPage(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: AppRoutes.orders,
          name: 'orders',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider<OrdersCubit>(
              // Don't eagerly fetch – the page guards itself with GuestAuthWall
              // and triggers the fetch only when the user is authenticated.
              create: (context) => getIt<OrdersCubit>(),
              child: const OrdersPage(),
            ),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfilePage(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.search,
      name: 'search',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider<SearchCubit>(
          create: (context) => getIt<SearchCubit>(),
          child: const SearchPage(),
        ),
        transitionsBuilder: _slideTransition,
      ),
    ),

    // ==================== Placeholder Routes ====================
    // These will be implemented in their respective features
    // ==================== Placeholder Routes ====================
    // These will be implemented in their respective features
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // ==================== Profile Sub-routes ====================
    GoRoute(
      path: '${AppRoutes.profile}/edit',
      name: 'edit-profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const EditProfilePage(),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.profile}/change-password',
      name: 'change-password',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ChangePasswordPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.profile}/settings',
      name: 'settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.profile}/favorites',
      name: 'favorites',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const FavoritesPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: AppRoutes.wishlist,
      name: 'wishlist',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider<WishlistCubit>.value(
          value: getIt<WishlistCubit>(),
          child: const WishlistPage(),
        ),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.profile}/notifications',
      name: 'notifications',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationsPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.productDetailsPath,
      name: 'product-details',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        bool? initialInStock;
        String? initialOutOfStockMessage;
        final extra = state.extra;

        if (extra is Map<String, dynamic>) {
          initialInStock = extra['inStock'] as bool?;
          initialOutOfStockMessage = extra['outOfStockMessage'] as String?;
        } else if (extra is ProductDetailsExtra) {
          initialInStock = extra.inStock;
          initialOutOfStockMessage = extra.outOfStockMessage;
        }

        return CustomTransitionPage(
          key: state.pageKey,
           child: MultiBlocProvider(
             providers: [
               BlocProvider<ProductCubit>(
                 create: (context) =>
                     getIt<ProductCubit>()..fetchEcommerceProductDetails(
                       id,
                       initialInStock: initialInStock,
                       initialOutOfStockMessage: initialOutOfStockMessage,
                     ),
               ),
               BlocProvider<WishlistCubit>.value(value: getIt<WishlistCubit>()),
               // CartCubit is an app-wide lazy singleton normally provided by
               // MainShell. This top-level route must also provide it because
               // post-login `context.go(redirectAfter)` replaces the whole
               // navigation stack, removing MainShell (and its providers)
               // from the widget tree. Use `.value` so the shared instance
               // is not auto-closed.
               BlocProvider<CartCubit>.value(value: getIt<CartCubit>()),
             ],
             child: const ProductDetailsPage(),
           ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.viewAllProducts,
      name: 'view-all-products',
      pageBuilder: (context, state) {
        final args = state.extra as ViewAllProductsArgs?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ViewAllProductsPage(
            args:
                args ??
                const ViewAllProductsArgs(title: 'All Products', products: []),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.expressProducts,
      name: 'express-products',
      pageBuilder: (context, state) {
        final args = state.extra as ExpressProductsArgs?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ExpressProductsPage(
            args:
                args ??
                const ExpressProductsArgs(
                  categoryId: 0,
                  categoryName: 'Express Products',
                  latitude: 23.0225,
                  longitude: 72.5714,
                ),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.restaurantDetailsPath,
      name: 'restaurant-details',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: RestaurantDetailsPage(restaurantId: id),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.orderDetailsPath,
      name: 'order-details',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<OrdersCubit>(
            create: (context) => getIt<OrdersCubit>(),
            child: OrderDetailsPage(orderId: id),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.quickDeliveryTrackingPath,
      name: 'quick-delivery-tracking',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final orderNumber = state.uri.queryParameters['orderNumber'];
        final rawCustomerLat = double.tryParse(
          state.uri.queryParameters['customerLat'] ?? '',
        );
        final rawCustomerLng = double.tryParse(
          state.uri.queryParameters['customerLng'] ?? '',
        );

        final customerLat =
            rawCustomerLat != null &&
                rawCustomerLat != 0 &&
                rawCustomerLat >= -90 &&
                rawCustomerLat <= 90
            ? rawCustomerLat
            : null;
        final customerLng =
            rawCustomerLng != null &&
                rawCustomerLng != 0 &&
                rawCustomerLng >= -180 &&
                rawCustomerLng <= 180
            ? rawCustomerLng
            : null;

        if (kDebugMode) {
          debugPrint(
            '[quick-delivery-route] orderId=$id '
            'rawLat=${state.uri.queryParameters['customerLat']} '
            'rawLng=${state.uri.queryParameters['customerLng']} '
            'parsedLat=$rawCustomerLat parsedLng=$rawCustomerLng '
            'sanitizedLat=$customerLat sanitizedLng=$customerLng',
          );
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<QuickDeliveryTrackingCubit>(
            create: (context) => getIt<QuickDeliveryTrackingCubit>(),
            child: QuickDeliveryTrackingPage(
              orderId: id,
              orderNumber: orderNumber,
              customerLatitude: customerLat,
              customerLongitude: customerLng,
            ),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.checkoutSelectItems,
      name: 'checkout-select-items',
      pageBuilder: (context, state) {
        final extra = state.extra;
        List<taksh_e_commerce.CartItem> cartItems = const [];
        List<ExtraCharge> extraCharges = const [];

        if (extra is Map<String, dynamic>) {
          cartItems = (extra['items'] as List<dynamic>? ?? const [])
              .whereType<taksh_e_commerce.CartItem>()
              .toList();
          extraCharges = (extra['extraCharges'] as List<dynamic>? ?? const [])
              .whereType<ExtraCharge>()
              .toList();
        } else if (extra is List<dynamic>) {
          cartItems = extra.whereType<taksh_e_commerce.CartItem>().toList();
        } else if (extra is List<taksh_e_commerce.CartItem>) {
          cartItems = extra;
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<CheckoutBloc>(
            create: (context) => getIt<CheckoutBloc>(),
            child: SelectItemsPage(
              cartItems: cartItems,
              extraCharges: extraCharges,
            ),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      pageBuilder: (context, state) {
        final selectedItems = state.extra;
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<CheckoutBloc>(
            create: (context) {
              final bloc = getIt<CheckoutBloc>();
              // If selected items passed, initialize the bloc
              if (selectedItems != null) {
                bloc.add(
                  SelectCheckoutItemsEvent(
                    cartItems: (selectedItems as SelectedCheckoutItems).items,
                    selectedItemIds: selectedItems.itemIds,
                    extraCharges: selectedItems.extraCharges,
                    deliveryType: selectedItems.deliveryType,
                  ),
                );
              }
              return bloc;
            },
            child: const CheckoutPage(),
          ),
          transitionsBuilder: _slideTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.paymentSuccess,
      name: 'payment-success',
      pageBuilder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? '';
        final orderNumber = state.uri.queryParameters['orderNumber'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<PaymentBloc>(
            create: (context) => getIt<PaymentBloc>(),
            child: PaymentSuccessPage(
              orderId: orderId,
              orderNumber: orderNumber,
            ),
          ),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.paymentFailed,
      name: 'payment-failed',
      pageBuilder: (context, state) {
        final errorCode = state.uri.queryParameters['errorCode'];
        final errorMessage = state.uri.queryParameters['errorMessage'];
        final orderId = state.uri.queryParameters['orderId'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider<PaymentBloc>(
            create: (context) => getIt<PaymentBloc>(),
            child: PaymentFailedPage(
              errorCode: errorCode,
              errorMessage: errorMessage,
              orderId: orderId,
            ),
          ),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.orderPlaced,
      name: 'order-placed',
      pageBuilder: (context, state) {
        final orderId =
            int.tryParse(state.uri.queryParameters['orderId'] ?? '') ?? 0;
        final orderNumber = state.uri.queryParameters['orderNumber'];
        final paymentMethod = state.uri.queryParameters['paymentMethod'];
        return CustomTransitionPage(
          key: state.pageKey,
          child: OrderPlacedPage(
            orderId: orderId,
            orderNumber: orderNumber,
            paymentMethod: paymentMethod,
          ),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.addresses,
      name: 'addresses',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddressListPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.addAddress,
      name: 'add-address',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddAddressPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.notFound,
      name: '404',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotFoundPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.noInternet,
      name: 'no-internet',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NoInternetPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),
  ];

  /// Routes that require authentication.
  /// Unauthenticated users are redirected to login with a `redirectAfter`
  /// query parameter so they return to the original destination after login.
  /// Routes that require authentication.
  /// Shell tab routes (orders, profile, cart) are NOT listed here because
  /// their pages handle guest mode in-page via [GuestAuthWall], allowing
  /// the bottom nav bar to remain visible.
  static const _authRequiredRoutes = [
    AppRoutes.addresses,
    AppRoutes.addAddress,
    AppRoutes.checkout,
    AppRoutes.checkoutSelectItems,
    '/quick-delivery',
  ];

  /// Global redirect logic (route guards)
  /// Handles authentication checks and redirects based on AuthBloc state
  static String? _redirect(BuildContext context, GoRouterState state) {
    // Get the current auth state from the global BLoC
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    // Check if currently on splash screen
    final isOnSplash = state.matchedLocation == AppRoutes.splash;

    // Don't redirect if on splash screen - let splash screen handle navigation
    if (isOnSplash) {
      return null;
    }

    // Don't redirect during initial loading or during auth operations
    if (authState is AuthInitial || authState is AuthLoading) {
      return null;
    }

    // Check if user is authenticated
    final isAuthenticated = authState is Authenticated;

    // Check if currently on an auth page (login or verify OTP)
    final isOnAuthPage =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation.startsWith(AppRoutes.verifyOtp) ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.onboarding;

    // If authenticated and still on an auth page, send them to home.
    // Non-shell destinations (product details, checkout, …) are handled by
    // [navigateAfterAuth] in the auth pages so the stack keeps home underneath
    // and the system back gesture does not exit the app.
    if (isAuthenticated && isOnAuthPage) {
      return AppRoutes.home;
    }

    // If not authenticated and trying to access an auth-required route,
    // redirect to login and encode the original destination so we can return
    // there after login.
    if (!isAuthenticated) {
      final location = state.matchedLocation;
      final needsAuth = _authRequiredRoutes.any(
        (r) => location == r || location.startsWith('$r/'),
      );
      if (needsAuth) {
        final encoded = Uri.encodeComponent(location);
        return '${AppRoutes.login}?redirectAfter=$encoded';
      }
    }

    // No redirect needed
    return null;
  }

  /// Error page builder (404 handling)
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Transition Builders ====================

  /// Fade transition
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );
  }

  /// Slide transition (from right)
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }
}

// ==================== Placeholder Pages ====================
// These will be moved to their respective feature folders when implemented

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Register Page - To be implemented')),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Forgot Password Page - To be implemented')),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Edit Profile Page - To be implemented')),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Change Password Page - To be implemented')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Page - To be implemented')),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Favorites Page - To be implemented')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Notifications Page - To be implemented')),
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;

  const RestaurantDetailsPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Restaurant Details Page - ID: $restaurantId - To be implemented',
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('404 - Page Not Found')));
  }
}

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('No Internet Connection')));
  }
}
