/// API version
class ApiConstants {
  ApiConstants._();

  /// API version
  static const String apiVersion = 'v1';

  /// Base URLs for different environments
  static const String devBaseUrl = 'https://taksh-admin.takshallinone.in/api';
  static const String stagingBaseUrl =
      'https://taksh-admin.takshallinone.in/api';
  static const String prodBaseUrl = 'https://taksh-admin.takshallinone.in/api';

  /// Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Authentication endpoints
  static const String login = '/auth/login';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  /// Dashboard endpoint
  static const String dashboard = '/dashboard';
  static const String expressDashboard = '/express-30/dashboard';

  /// User endpoints
  static const String currentUser = '/user/me';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/update-profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete';

  /// Restaurant endpoints
  static const String restaurants = '/restaurants';
  static const String restaurantCategories = '/restaurants/categories';
  static const String popularRestaurants = '/restaurants/popular';
  static const String nearbyRestaurants = '/restaurants/nearby';

  /// Menu endpoints
  static String restaurantMenu(String restaurantId) =>
      '/restaurants/$restaurantId/menu';

  static String menuItem(String itemId) => '/menu/$itemId';
  static const String searchMenu = '/menu/search';

  /// Cart endpoints
  static const String cart = '/cart/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update';

  static String removeCartItem(String itemId) => '/cart/item/$itemId';
  static const String clearCart = '/cart/clear';

  /// Order endpoints
  static const String orders = '/order/orders';
  static const String placeOrder = '/order/place';

  static String orderDetails(int orderId) => '/order/orders/$orderId';
  static String quickDeliveryLocation(int orderId) =>
      '/order/orders/$orderId/delivery-location';
    static String cancelOrder(int orderId) => '/order/orders/$orderId/cancel';
  static const String returnRequest = '/return/customer/create';
  static const String returnUploadMedia = '/return/customer/upload-media';
  static const String orderHistory = '/orders/history';

  static String trackOrder(String orderId) => '/orders/$orderId/track';

  /// Server origin without the `/api` suffix.
  /// Invoice endpoints live outside the API prefix.
  static String serverOriginFromBaseUrl(String baseUrl) {
    final trimmed = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    if (trimmed.endsWith('/api')) {
      return trimmed.substring(0, trimmed.length - 4);
    }
    return trimmed;
  }

  /// Absolute URL for the invoice PDF file stream.
  /// GET requires Bearer auth. Path is outside `/api`.
  static String orderInvoiceFile(String orderNumber, {required String baseUrl}) =>
      '${serverOriginFromBaseUrl(baseUrl)}/orders/$orderNumber/invoice/file';

  /// Address endpoints
  static const String addresses = '/address/addresses';
  static const String addAddress = '/address/add';

  static String updateAddress(String addressId) => '/address/$addressId';

  static String deleteAddress(String addressId) =>
      '/address/user/addresses/delete';

  static String setDefaultAddress(String addressId) =>
      '/address/$addressId/default';

  /// Payment endpoints
  static const String paymentMethods = '/payments/methods';
  static const String createPayment =
      '/payments/create'; // Creates Razorpay order
  static const String verifyPayment =
      '/payments/verify'; // Verifies payment signature
  static const String paymentHistory = '/payments/history';

  static String paymentStatus(String orderId) => '/payments/status/$orderId';

  /// Favorites endpoints
  static const String favorites = '/favorites';
  static const String addToFavorites = '/favorites/add';

  static String removeFromFavorites(String restaurantId) =>
      '/favorites/remove/$restaurantId';

  /// Notifications endpoints
  static const String notifications = '/notifications';

  static String markAsRead(String notificationId) =>
      '/notifications/$notificationId/read';
  static const String markAllAsRead = '/notifications/read-all';

  /// Location endpoints
  static const String searchLocation = '/location/search';
  static const String geocode = '/location/geocode';
  static const String reverseGeocode = '/location/reverse-geocode';

  /// Category endpoints
  static const String categories = '/ecommerce/categories';

  /// Product endpoints
  static const String products = '/products';
  static const String productSearch = '/products/search';

  static const String recentSearches = '/product/recent-searches';
  static const String recentViews = '/product/recent-views';

  static String productDetails(int productId) => '/products/$productId';
  static const String expressProducts = '/express-30/products';
  static const String ecommerceProducts = '/ecommerce/products';

  static String ecommerceProductDetails(int productId) =>
      '/ecommerce/products/$productId';

  static String ecommerceCheckDelivery(int productId) =>
      '/ecommerce/products/$productId/check-delivery';

  /// Delivery boy endpoints
  static const String deliveryBoyJoinRequest = '/delivery-boy/join-request';

  /// Vendor endpoints
  static const String vendorRegister = '/vendor/register';

  /// Development endpoints
  static const String developmentRequest = '/development-request';

  /// Callback endpoints
  static const String requestCallback = '/request-callback';

  /// Bank detail endpoints
  static const String saveBankDetail = '/bank-detail';
  static const String bankDetails = '/bank-detail';

  /// Wallet endpoints
  static const String wallet = '/wallet';

  /// Home Service endpoints
  static const String services = '/service/services';
  static const String serviceInquiry = '/service/service-inquiry';
  static const String serviceOrders = '/service/service-orders';
  static const String courierDeliveryPartners =
      '/service/courier/delivery-partners';
  static const String courierQuote = '/service/courier/quote';
  static const String courierBookings = '/service/courier/bookings';
  static const String electricianBookings = '/service/electrician/bookings';
  static const String plumberBookings = '/service/plumber/bookings';
  static const String salonBookings = '/service/salon/bookings';
}
