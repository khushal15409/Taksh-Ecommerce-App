/// Route path constants
class AppRoutes {
  AppRoutes._();

  // Root
  static const String root = '/';

  // Authentication routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes (bottom navigation)
  static const String home = '/home';
  static const String categories = '/categories';
  static const String deliveryTypeQueryKey = 'delivery';

  /// Navigate to home with optional delivery type (standard, quick, services)
  static String homeWithDelivery(String deliveryType) {
    return '$home?$deliveryTypeQueryKey=$deliveryType';
  }

  /// Navigate to categories with optional category and subcategory IDs
  static String categoriesToCategory(
    int? categoryId, {
    int? subcategoryId,
    String? deliveryType,
  }) {
    final params = <String, String>{};

    if (categoryId != null) {
      params['categoryId'] = categoryId.toString();
    }

    if (subcategoryId != null) {
      params['subcategoryId'] = subcategoryId.toString();
    }

    if (deliveryType != null && deliveryType.isNotEmpty) {
      params[deliveryTypeQueryKey] = deliveryType;
    }

    if (params.isEmpty) return categories;

    final query =
        params.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
    return '$categories?$query';
  }

  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';

  // Search
  static const String search = '/search';

  // Restaurant routes
  static const String restaurants = '/restaurants';
  static String restaurantDetails(String id) => '/restaurants/$id';
  static const String restaurantDetailsPath = '/restaurants/:id';

  // Menu routes
  static String menuItem(String id) => '/menu/$id';
  static const String menuItemPath = '/menu/:id';

  // Order routes
  static String orderDetails(String id) => '/orders/$id';
  static const String orderDetailsPath = '/orders/:id';
  static String trackOrder(String id) => '/orders/$id/track';
  static const String trackOrderPath = '/orders/:id/track';
  static String quickDeliveryTracking(
    String id, {
    double? customerLat,
    double? customerLng,
    String? orderNumber,
  }) {
    final query = <String, String>{};
    if (customerLat != null) {
      query['customerLat'] = customerLat.toString();
    }
    if (customerLng != null) {
      query['customerLng'] = customerLng.toString();
    }
    if (orderNumber != null && orderNumber.isNotEmpty) {
      query['orderNumber'] = orderNumber;
    }
    if (query.isEmpty) {
      return '/quick-delivery/$id';
    }
    final qp = query.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '/quick-delivery/$id?$qp';
  }

  static const String quickDeliveryTrackingPath = '/quick-delivery/:id';

  // Checkout routes
  static const String checkoutSelectItems = '/checkout/select-items';
  static const String checkout = '/checkout';
  static const String orderReview = '/checkout/review';
  static const String orderPlaced = '/order/placed';

  /// Build query string for the order-placed page
  static String orderPlacedPath({
    required int orderId,
    String? orderNumber,
    String? paymentMethod,
  }) {
    final params = <String, String>{
      'orderId': orderId.toString(),
      if (orderNumber != null && orderNumber.isNotEmpty)
        'orderNumber': orderNumber,
      if (paymentMethod != null && paymentMethod.isNotEmpty)
        'paymentMethod': paymentMethod,
    };
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$orderPlaced?$query';
  }

  // Product routes
  static String productDetails(int id) => '/product/$id';
  static const String productDetailsPath = '/product/:id';
  static const String viewAllProducts = '/products/view-all';
  static const String expressProducts = '/express-products';

  // Address routes
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static String editAddress(String id) => '/addresses/$id/edit';
  static const String editAddressPath = '/addresses/:id/edit';

  // Payment routes
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String paymentFailed = '/payment/failed';

  // Profile routes
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String settings = '/profile/settings';
  static const String favorites = '/profile/favorites';
  static const String wishlist = '/profile/wishlist';
  static const String notifications = '/profile/notifications';

  // Other routes
  static const String about = '/about';
  static const String support = '/support';
  static const String termsAndConditions = '/terms';
  static const String privacyPolicy = '/privacy';

  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';
  static const String noInternet = '/no-internet';
}

/// Extra data passed when navigating to the product details page.
/// Carries stock status from the product listing so the details page can
/// display the correct state even if the product-details API does not return
/// the `in_stock` field.
class ProductDetailsExtra {
  final bool inStock;
  final String? outOfStockMessage;

  const ProductDetailsExtra({
    required this.inStock,
    this.outOfStockMessage,
  });
}
