import 'package:flutter/material.dart';

/// General application constants
class AppConstants {
  AppConstants._();

  /// App information
  static const String appName = 'Taksh E-Commerce';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheValidityDuration = Duration(hours: 1);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration otpResendDuration = Duration(seconds: 30);

  /// Validation limits
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneLength = 10;
  static const int otpLength = 4;
  static const int pincodeLength = 6;

  /// Search
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
  static const int maxSearchHistoryItems = 10;
  static const int minSearchLength = 2;

  /// Cart
  static const int maxCartItems = 50;
  static const int minOrderAmount = 100;
  static const int maxOrderAmount = 10000;

  /// UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  /// Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  /// Image dimensions
  static const double thumbnailSize = 80.0;
  static const double mediumImageSize = 120.0;
  static const double largeImageSize = 200.0;

  /// Default placeholder image
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String noImagePlaceholder = 'assets/images/no_image.png';

  /// Error messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String noInternetMessage =
      'No internet connection. Please check your connection.';
  static const String sessionExpiredMessage =
      'Your session has expired. Please login again.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';

  /// Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String logoutSuccessMessage = 'Logout successful!';
  static const String orderPlacedMessage = 'Order placed successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';

  /// Regex patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10}$';
  static const String otpPattern = r'^[0-9]{6}$';

  /// Date formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  /// Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  /// Default colors (as hex strings for API/storage)
  static const String primaryColorHex = '#FF5722';
  static const String accentColorHex = '#FFC107';

  /// Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
  ];

  /// Default language
  static const Locale defaultLocale = Locale('en', 'US');
}
