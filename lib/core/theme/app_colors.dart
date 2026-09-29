import 'package:flutter/material.dart';

/// App color palette - centralized color definitions
/// All colors used throughout the app should be defined here
/// Theme inspired by the Indian flag - Saffron, White, and Green
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============ Primary Colors (Saffron/Orange - Top of Indian Flag) ============
  static const Color primaryOrange = Color(0xFFFFA340);
  static const Color primaryOrangeDark = Color(0xFFE38A2E);
  static const Color primaryOrangeLight = Color(0xFFFFC07A);
  static const Color saffron = Color(0xFFFF9933); // Traditional saffron
  static const Color saffronLight = Color(0xFFFFB366);
  static const Color saffronDark = Color(0xFFE68A00);

  // ============ Secondary Colors (Green - Bottom of Indian Flag) ============
  static const Color secondaryGreen = Color(0xFF3CAE5C);
  static const Color secondaryGreenDark = Color(0xFF2E8B47);
  static const Color secondaryGreenLight = Color(0xFF5FC77F);
  static const Color indiaGreen = Color(0xFF138808); // Traditional India green
  static const Color indiaGreenLight = Color(0xFF4CAF50);
  static const Color indiaGreenDark = Color(0xFF0D5F06);

  // ============ Indian Flag White (Middle - Purity) ============
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFFFFF8);
  static const Color creamWhite = Color(0xFFFFFCF0);

  // ============ Neutral Colors ============
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============ Semantic Colors ============
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successLight = Color(0xFF81C784);

  static const Color error = Color(0xFFF44336);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFE57373);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);

  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFF64B5F6);

  // ============ Background Colors ============
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ============ Text Colors ============
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFF666666);

  // ============ Border Colors ============
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // ============ Overlay Colors ============
  static const Color overlayLight = Color(0x0A000000); // 4% opacity
  static const Color overlayDark = Color(0x14FFFFFF); // 8% opacity

  // ============ E-Commerce Specific Colors ============
  static const Color discount = Color(0xFFE91E63);
  static const Color price = Color(0xFF4CAF50);
  static const Color outOfStock = Color(0xFF9E9E9E);
  static const Color inStock = Color(0xFF4CAF50);
  static const Color rating = Color(0xFFFFC107);
}

/// Indian Flag Tricolor Gradients
/// Use these gradients throughout the app for a cohesive patriotic theme
class IndiaGradients {
  IndiaGradients._();

  /// Full tricolor gradient (vertical) - Saffron to White to Green
  static const LinearGradient tricolorVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryOrange,
      AppColors.primaryOrangeLight,
      AppColors.pureWhite,
      AppColors.secondaryGreenLight,
      AppColors.secondaryGreen,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  /// Full tricolor gradient (horizontal) - Saffron to White to Green
  static const LinearGradient tricolorHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primaryOrange,
      AppColors.primaryOrangeLight,
      AppColors.pureWhite,
      AppColors.secondaryGreenLight,
      AppColors.secondaryGreen,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  /// Saffron gradient (for top sections/headers)
  static const LinearGradient saffronGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD699), // Lighter orange at top left
      AppColors.primaryOrangeLight,
      AppColors.primaryOrange, // Darker orange at bottom right
    ],
  );

  /// Green gradient (for bottom sections/footers)
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.secondaryGreen,
      AppColors.secondaryGreenLight,
      Color(0xFF6BD78F),
    ],
  );

  /// Subtle tricolor for backgrounds
  /// Little orange at top (header already has orange), half white, half green
  static const LinearGradient subtleTricolor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE8CC), // Noticeable light orange/peach
      Color(0xFFFFEFDB), // Softer orange tint
      Color(0xFFFFFCF8), // Very light warm white
      AppColors.pureWhite, // Pure white (middle)
      Color(0xFFF1F8E9), // Light green tint starting
      Color(0xFFC8E6C9), // Medium light green
      Color(0xFFA5D6A7), // Noticeable green at bottom
    ],
    stops: [0.0, 0.1, 0.2, 0.45, 0.6, 0.8, 1.0],
  );

  /// Splash screen gradient - beautiful tricolor blend
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primaryOrange,
      AppColors.primaryOrangeLight,
      Color(0xFFFFE4B8), // Light saffron tint
      AppColors.pureWhite,
      Color(0xFFE8F5E9), // Light green tint
      AppColors.secondaryGreenLight,
      AppColors.secondaryGreen,
    ],
    stops: [0.0, 0.15, 0.35, 0.5, 0.65, 0.85, 1.0],
  );

  /// Header gradient - saffron dominant
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryOrange,
      AppColors.primaryOrangeLight,
      Color(0xFFFFB366),
    ],
  );

  /// Card accent gradient
  static const LinearGradient cardAccentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.primaryOrange,
      AppColors.secondaryGreen,
    ],
  );

  /// Profile header gradient - Light green to white (from user design)
  static const LinearGradient profileHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF81C784), // Soft medium green
      Color(0xFFA5D6A7), // Lighter green
      Color(0xFFE8F5E9), // Very light green tint
      Colors.white, // Fades to white
    ],
    stops: [0.0, 0.4, 0.8, 1.0],
  );
}

/// Light theme color scheme
class LightColors {
  LightColors._();

  static const Color primary = AppColors.primaryOrange;
  static const Color primaryVariant = AppColors.primaryOrangeDark;
  static const Color secondary = AppColors.secondaryGreen;
  static const Color secondaryVariant = AppColors.secondaryGreenDark;

  static const Color background = AppColors.white;
  static const Color surface = AppColors.surfaceLight;
  static const Color error = AppColors.error;

  static const Color onPrimary = AppColors.white;
  static const Color onSecondary = AppColors.white;
  static const Color onBackground = AppColors.textPrimaryLight;
  static const Color onSurface = AppColors.textPrimaryLight;
  static const Color onError = AppColors.white;
}

/// Dark theme color scheme
class DarkColors {
  DarkColors._();

  static const Color primary = AppColors.primaryOrangeLight;
  static const Color primaryVariant = AppColors.primaryOrange;
  static const Color secondary = AppColors.secondaryGreenLight;
  static const Color secondaryVariant = AppColors.secondaryGreen;

  static const Color background = AppColors.backgroundDark;
  static const Color surface = AppColors.surfaceDark;
  static const Color error = AppColors.errorLight;

  static const Color onPrimary = AppColors.black;
  static const Color onSecondary = AppColors.black;
  static const Color onBackground = AppColors.textPrimaryDark;
  static const Color onSurface = AppColors.textPrimaryDark;
  static const Color onError = AppColors.black;
}
