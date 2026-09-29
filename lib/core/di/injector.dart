import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/core/routing/app_router.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';

// Auth feature imports
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/logout_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/fetch_profile_usecase.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/home/data/datasources/dashboard_remote_datasource.dart';
import 'package:taksh_e_commerce/features/home/data/datasources/express_dashboard_remote_datasource.dart';
import 'package:taksh_e_commerce/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:taksh_e_commerce/features/home/data/repositories/express_dashboard_repository_impl.dart';
import 'package:taksh_e_commerce/features/home/data/repositories/mock_express_dashboard_repository.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/dashboard_repository.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/express_dashboard_repository.dart';
import 'package:taksh_e_commerce/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:taksh_e_commerce/features/home/domain/usecases/get_express_dashboard_usecase.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/recent_views_cubit.dart';

// Splash feature imports
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';

// Address feature imports
import 'package:taksh_e_commerce/features/address/di/address_di.dart';

// Product feature imports (includes categories)
import 'package:taksh_e_commerce/features/product/data/datasources/product_remote_datasource.dart';
import 'package:taksh_e_commerce/features/product/data/repositories/product_repository_impl.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/check_delivery_availability.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_categories.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_products.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_product_details.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_recent_searches.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_recent_views.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/search_products.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/delivery_check_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/similar_products_cubit.dart';
import 'package:taksh_e_commerce/features/search/presentation/cubit/search_cubit.dart';

// Cart feature imports
import 'package:taksh_e_commerce/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:taksh_e_commerce/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/get_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/update_cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/clear_cart.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

// Wishlist feature imports
import 'package:taksh_e_commerce/features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import 'package:taksh_e_commerce/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/get_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/add_to_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';

import 'package:taksh_e_commerce/core/di/secure_store_di.dart';

// Orders feature imports
import 'package:taksh_e_commerce/features/orders/di/order_di.dart';

// Checkout feature imports
import 'package:taksh_e_commerce/features/checkout/di/checkout_injection.dart';

// Payment feature imports
import 'package:taksh_e_commerce/features/payment/di/payment_injection.dart';
import 'package:taksh_e_commerce/features/quick_delivery/di/quick_delivery_di.dart';

// WebSocket imports
import 'package:taksh_e_commerce/core/websocket/di/websocket_di.dart';
import 'package:taksh_e_commerce/features/wallet/di/wallet_di.dart';

// Home Service feature imports
import 'package:taksh_e_commerce/features/home_service/di/home_service_di.dart';

// Profile feature imports
import 'package:taksh_e_commerce/features/profile/data/datasources/delivery_boy_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/repositories/delivery_boy_repository_impl.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/delivery_boy_repository.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_bloc.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/vendor_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/repositories/vendor_repository_impl.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/vendor_repository.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_bloc.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/development_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/repositories/development_repository_impl.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/development_repository.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_development_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_bloc.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/callback_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/repositories/callback_repository_impl.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/callback_repository.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/request_callback.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_bloc.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/bank_detail_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/repositories/bank_detail_repository_impl.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/bank_detail_repository.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/save_bank_detail.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_bloc.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies({
  required String baseUrl,
  bool useMockData = false,
}) async {
  final log = loggerWithContext({
    'feature': 'di',
    'action': 'initialization',
  });
  final startTime = DateTime.now();

  log.infoWithContext(
    'Starting dependency injection setup',
    {
      'base_url': baseUrl,
      'use_mock_data': useMockData,
    },
  );

  // External dependencies
  log.debugWithContext(
      'Registering external dependencies', {'action': 'external'});
  await _registerExternalDependencies();

  // Core dependencies
  log.debugWithContext('Registering core dependencies', {'action': 'core'});
  _registerCoreDependencies(baseUrl);

  // Feature dependencies
  log.debugWithContext(
      'Registering feature dependencies', {'action': 'features'});
  _registerSplashDependencies();
  _registerAuthDependencies(useMockData: useMockData);
  _registerDashboardDependencies(useMockData: useMockData);
  registerAddressDependencies(getIt, useMock: useMockData);
  _registerProductDependencies();
  _registerCartDependencies();
  _registerWishlistDependencies();
  registerOrderDependencies(getIt);
  registerCheckoutDependencies(getIt, useMockData: useMockData);
  registerPaymentDependencies(getIt, useMockData: useMockData);
  registerQuickDeliveryDependencies(getIt);
  _registerProfileDependencies();
  registerWalletDependencies(getIt);
  registerWebSocketDependencies(getIt);
  registerHomeServiceDependencies(getIt);
  // _registerRestaurantDependencies();
  // _registerProfileDependencies();

  // Secure storage
  log.debugWithContext(
      'Registering secure storage', {'action': 'secure_storage'});
  registerSecureStore(getIt);

  log.infoWithContext(
    'Dependency injection setup completed',
    {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
  );
}

/// Register external dependencies (SharedPreferences, Connectivity, etc.)
Future<void> _registerExternalDependencies() async {
  final log = loggerWithContext({'feature': 'di', 'layer': 'external'});
  final startTime = DateTime.now();

  // SharedPreferences - singleton
  log.debugWithContext('Initializing SharedPreferences', {'action': 'init'});
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity - singleton
  log.debugWithContext('Registering Connectivity', {'action': 'register'});
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Dio - singleton (for network checks)
  log.debugWithContext('Registering Dio', {'action': 'register'});
  getIt.registerLazySingleton<Dio>(() => Dio());

  log.debugWithContext(
    'External dependencies registered',
    {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
  );
}

/// Register core dependencies (API Client, Network Info, Router)
void _registerCoreDependencies(String baseUrl) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'core'});

  log.debugWithContext(
    'Registering core dependencies',
    {'base_url': baseUrl},
  );

  // Network Info - lazy singleton
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  // API Client - lazy singleton
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: baseUrl,
      secureStore: getIt(),
    ),
  );

  // App Router - lazy singleton (no longer needs SharedPreferences)
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(),
  );

  log.debugWithContext(
    'Core dependencies registered',
    {'count': 3},
  );
}

/// Register splash feature dependencies
void _registerSplashDependencies() {
  // SplashCubit - singleton (stays active for entire app lifecycle)
  getIt.registerLazySingleton<SplashCubit>(() => SplashCubit());
}

/// Register authentication feature dependencies
void _registerAuthDependencies({bool useMockData = false}) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'auth'});

  log.debugWithContext(
    'Registering auth dependencies',
    {
      'action': 'start',
      'use_mock_data': useMockData,
    },
  );

  // Data sources - use mock or real based on configuration
  if (useMockData) {
    log.infoWithContext(
      'Using MOCK auth data source',
      {'hint': 'No API calls will be made'},
    );
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthMockDataSource(),
    );
  } else {
    log.debugWithContext('Using REAL auth data source', {});
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: getIt()),
    );
  }

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: getIt(),
      secureStore: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => IsLoggedInUseCase(getIt()));

  // BLoC - factory (new instance each time)
  getIt.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      logoutUseCase: getIt(),
      updateProfileUseCase: getIt(),
      fetchProfileUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      isLoggedInUseCase: getIt(),
    ),
  );

  log.debugWithContext(
    'Auth dependencies registered',
    {'datasources': 2, 'usecases': 6, 'blocs': 1},
  );
}

/// Register dashboard/home feature dependencies
void _registerDashboardDependencies({bool useMockData = false}) {
  final log = loggerWithContext({'feature': 'di', 'layer': 'dashboard'});

  log.debugWithContext(
    'Registering dashboard dependencies',
    {'action': 'start', 'use_mock_data': useMockData},
  );

  // Data sources
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<ExpressDashboardRemoteDataSource>(
    () => ExpressDashboardRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  if (useMockData) {
    log.infoWithContext(
      'Using MOCK express dashboard repository',
      {'hint': 'No API calls will be made for express dashboard'},
    );
    getIt.registerLazySingleton<ExpressDashboardRepository>(
      () => MockExpressDashboardRepository(),
    );
  } else {
    getIt.registerLazySingleton<ExpressDashboardRepository>(
      () => ExpressDashboardRepositoryImpl(
        remoteDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );
  }

  // Use cases
  getIt.registerLazySingleton(() => GetDashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => GetExpressDashboardUseCase(getIt()));

  // BLoC - factory (new instance each time)
  getIt.registerFactory(
    () => DashboardBloc(getDashboardUseCase: getIt()),
  );
  getIt.registerFactory(
    () => ExpressDashboardBloc(getExpressDashboardUseCase: getIt()),
  );
  getIt.registerFactory(
    () => RecentViewsCubit(getRecentViews: getIt()),
  );

  log.debugWithContext(
    'Dashboard dependencies registered',
    {'datasources': 2, 'usecases': 2, 'blocs': 3},
  );
}

/// Register restaurant feature dependencies
/// Uncomment when restaurant feature is implemented
/*
void _registerRestaurantDependencies() {
  // Data sources
  getIt.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<RestaurantLocalDataSource>(
    () => RestaurantLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetRestaurantsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRestaurantDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchRestaurantsUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => RestaurantBloc(
      getRestaurantsUseCase: getIt(),
      getRestaurantDetailsUseCase: getIt(),
      searchRestaurantsUseCase: getIt(),
    ),
  );
}
*/

/// Register product feature dependencies (includes categories)
void _registerProductDependencies() {
  final log = loggerWithContext({'feature': 'di', 'layer': 'product'});

  log.debugWithContext('Registering product dependencies', {'action': 'start'});

  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetCategories(getIt()));
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetProductDetails(getIt()));
  getIt.registerLazySingleton(() => GetEcommerceProductDetails(getIt()));
  getIt.registerLazySingleton(() => SearchProducts(getIt()));
  getIt.registerLazySingleton(() => GetRecentSearches(getIt()));
  getIt.registerLazySingleton(() => GetRecentViews(getIt()));
  getIt.registerLazySingleton(() => CheckDeliveryAvailability(getIt()));

  // Cubit
  getIt.registerFactory(
    () => ProductCubit(
      getCategories: getIt(),
      getProducts: getIt(),
      getProductDetails: getIt(),
      getEcommerceProductDetails: getIt(),
      getExpressProducts: getIt(),
    ),
  );

  // Delivery Check Cubit - factory (one per product details page)
  getIt.registerFactory(
    () => DeliveryCheckCubit(checkDeliveryAvailability: getIt()),
  );

  // Search Cubit
  getIt.registerFactory(
    () => SearchCubit(
      searchProducts: getIt(),
      getRecentSearches: getIt(),
    ),
  );

  // Similar Products Cubit - factory (new instance for each product details page)
  getIt.registerFactory(
    () => SimilarProductsCubit(
      getProducts: getIt(),
    ),
  );

  log.debugWithContext(
    'Product dependencies registered',
    {'datasources': 1, 'usecases': 7, 'cubits': 3},
  );
}

/// Register cart feature dependencies
void _registerCartDependencies() {
  final log = loggerWithContext({'feature': 'di', 'layer': 'cart'});

  log.debugWithContext('Registering cart dependencies', {'action': 'start'});

  // Data sources
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetCart(getIt()));
  getIt.registerLazySingleton(() => AddToCart(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItem(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt()));
  getIt.registerLazySingleton(() => ClearCart(getIt()));

  // Cubit - lazy singleton (shared across the app for consistent cart state)
  getIt.registerLazySingleton(
    () => CartCubit(
      getCart: getIt(),
      addToCart: getIt(),
      updateCartItem: getIt(),
      removeFromCart: getIt(),
      clearCart: getIt(),
      secureStore: getIt(),
      sharedPreferences: getIt(),
    ),
  );

  log.debugWithContext(
    'Cart dependencies registered',
    {'datasources': 1, 'usecases': 5, 'cubits': 1},
  );
}

/// Register wishlist feature dependencies
void _registerWishlistDependencies() {
  final log = loggerWithContext({'feature': 'di', 'layer': 'wishlist'});

  log.debugWithContext('Registering wishlist dependencies', {'action': 'start'});

  // Data sources
  getIt.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetWishlist(getIt()));
  getIt.registerLazySingleton(() => AddToWishlist(getIt()));
  getIt.registerLazySingleton(() => RemoveFromWishlist(getIt()));

  // Cubit - lazy singleton (shared across the app for consistent wishlist state)
  getIt.registerLazySingleton(
    () => WishlistCubit(
      getWishlist: getIt(),
      addToWishlist: getIt(),
      removeFromWishlist: getIt(),
    ),
  );

  log.debugWithContext(
    'Wishlist dependencies registered',
    {'datasources': 1, 'usecases': 3, 'cubits': 1},
  );
}

/// Register profile feature dependencies
void _registerProfileDependencies() {
  final log = loggerWithContext({'feature': 'di', 'layer': 'profile'});

  log.debugWithContext('Registering profile dependencies', {'action': 'start'});

  // Delivery Boy Data sources
  getIt.registerLazySingleton<DeliveryBoyRemoteDataSource>(
    () => DeliveryBoyRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Delivery Boy Repository
  getIt.registerLazySingleton<DeliveryBoyRepository>(
    () => DeliveryBoyRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Delivery Boy Use cases
  getIt.registerLazySingleton(() => SubmitDeliveryBoyJoinRequest(getIt()));

  // Delivery Boy BLoC - factory (new instance for each usage)
  getIt.registerFactory(
    () => DeliveryBoyBloc(
      submitJoinRequest: getIt(),
    ),
  );

  // Vendor Data sources
  getIt.registerLazySingleton<VendorRemoteDataSource>(
    () => VendorRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Vendor Repository
  getIt.registerLazySingleton<VendorRepository>(
    () => VendorRepositoryImpl(remoteDataSource: getIt()),
  );

  // Vendor Use cases
  getIt.registerLazySingleton(() => SubmitVendorJoinRequest(getIt()));

  // Vendor BLoC - factory (new instance for each usage)
  getIt.registerFactory(
    () => VendorBloc(submitJoinRequest: getIt()),
  );

  // Development Data sources
  getIt.registerLazySingleton<DevelopmentRemoteDataSource>(
    () => DevelopmentRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Development Repository
  getIt.registerLazySingleton<DevelopmentRepository>(
    () => DevelopmentRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Development Use cases
  getIt.registerLazySingleton(() => SubmitDevelopmentRequest(getIt()));

  // Development BLoC - factory (new instance for each usage)
  getIt.registerFactory(
    () => DevelopmentBloc(
      submitDevelopmentRequest: getIt(),
    ),
  );

  // Callback Data sources
  getIt.registerLazySingleton<CallbackRemoteDataSource>(
    () => CallbackRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Callback Repository
  getIt.registerLazySingleton<CallbackRepository>(
    () => CallbackRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Callback Use cases
  getIt.registerLazySingleton(() => RequestCallback(getIt()));

  // Callback BLoC - factory (new instance for each usage)
  getIt.registerFactory(
    () => CallbackBloc(
      requestCallback: getIt(),
    ),
  );

  // Bank Detail Data sources
  getIt.registerLazySingleton<BankDetailRemoteDataSource>(
    () => BankDetailRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Bank Detail Repository
  getIt.registerLazySingleton<BankDetailRepository>(
    () => BankDetailRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Bank Detail Use cases
  getIt.registerLazySingleton(() => SaveBankDetail(getIt()));

  // Bank Detail BLoC - factory (new instance for each usage)
  getIt.registerFactory(
    () => BankDetailBloc(
      saveBankDetail: getIt(),
    ),
  );

  log.debugWithContext(
    'Profile dependencies registered',
    {'datasources': 4, 'usecases': 4, 'blocs': 4},
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
