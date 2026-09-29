/// Local storage keys for SharedPreferences and Hive
class StorageConstants {
  StorageConstants._();

  /// Authentication keys
  static const String authToken = 'auth_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String userProfileImage = 'user_profile_image';
  static const String userIsVerified = 'user_is_verified';

  /// Onboarding keys
  static const String isFirstLaunch = 'is_first_launch';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  /// App settings keys
  static const String isDarkMode = 'is_dark_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';

  /// Location keys
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';
  static const String defaultAddressId = 'default_address_id';

  /// Cart keys (Hive box name)
  static const String cartBox = 'cart_box';
  static const String cartItems = 'cart_items';

  /// Guest cart token (anonymous cart sync)
  static const String guestCartToken = 'guest_cart_token';

  /// Favorites keys (Hive box name)
  static const String favoritesBox = 'favorites_box';
  static const String favoriteRestaurants = 'favorite_restaurants';

  /// Cache keys
  static const String cachedRestaurants = 'cached_restaurants';
  static const String cachedCategories = 'cached_categories';
  static const String lastCacheUpdate = 'last_cache_update';

  /// Search history keys
  static const String searchHistory = 'search_history';
  static const String recentSearches = 'recent_searches';

  /// Order history keys (Hive box name)
  static const String orderHistoryBox = 'order_history_box';

  /// Address keys (Hive box name)
  static const String addressBox = 'address_box';

  /// User preferences
  static const String preferredPaymentMethod = 'preferred_payment_method';
  static const String defaultDeliveryAddress = 'default_delivery_address';
}
