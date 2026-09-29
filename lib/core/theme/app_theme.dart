import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_typography.dart';
import 'package:taksh_e_commerce/core/theme/app_tokens.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';

/// Main theme configuration for the app
/// Combines all design system tokens into cohesive themes
class AppTheme {
  AppTheme._();

  // ============ Light Theme ============
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: LightColors.primary,
        onPrimary: LightColors.onPrimary,
        primaryContainer: AppColors.primaryOrangeLight,
        onPrimaryContainer: AppColors.primaryOrangeDark,
        secondary: LightColors.secondary,
        onSecondary: LightColors.onSecondary,
        secondaryContainer: AppColors.secondaryGreenLight,
        onSecondaryContainer: AppColors.secondaryGreenDark,
        tertiary: AppColors.warning,
        onTertiary: AppColors.white,
        error: LightColors.error,
        onError: LightColors.onError,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.errorDark,
        surface: LightColors.surface,
        onSurface: LightColors.onSurface,
        surfaceContainerHighest: AppColors.grey100,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.grey300,
        shadow: AppColors.black.withOpacity(0.1),
        scrim: AppColors.black.withOpacity(0.5),
        inverseSurface: AppColors.grey800,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.primaryOrangeLight,
      ),

      // Typography
      textTheme: AppTypography.textTheme(isDark: false),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: LightColors.surface,
        foregroundColor: LightColors.onSurface,
        iconTheme: const IconThemeData(
          color: LightColors.onSurface,
          size: AppTokens.iconMD,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: LightColors.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: LightColors.surface,
        shadowColor: AppColors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.cardRadius,
          side: BorderSide(
            color: AppColors.borderLight,
            width: AppTokens.borderWidthThin,
          ),
        ),
        margin: const EdgeInsets.all(AppSpacing.cardMargin),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: LightColors.primary,
          foregroundColor: LightColors.onPrimary,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.buttonRadius,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LightColors.primary,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          side: const BorderSide(
            color: LightColors.primary,
            width: AppTokens.borderWidthMedium,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.buttonRadius,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LightColors.primary,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.all(AppSpacing.inputPadding),
        border: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.borderLight,
            width: AppTokens.borderWidthThin,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.borderLight,
            width: AppTokens.borderWidthThin,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: LightColors.primary,
            width: AppTokens.borderWidthMedium,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: LightColors.error,
            width: AppTokens.borderWidthThin,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: LightColors.error,
            width: AppTokens.borderWidthMedium,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: AppTokens.borderWidthThin,
          ),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondaryLight,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabledLight,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: LightColors.error,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: LightColors.onSurface,
        size: AppTokens.iconMD,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: AppTokens.dividerHeight,
        space: AppSpacing.dividerSpacing,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        deleteIconColor: AppColors.grey700,
        disabledColor: AppColors.grey200,
        selectedColor: LightColors.primary.withOpacity(0.12),
        secondarySelectedColor: LightColors.secondary.withOpacity(0.12),
        labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
        padding: const EdgeInsets.all(AppSpacing.paddingXS),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.chipRadius,
        ),
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium,
        brightness: Brightness.light,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: LightColors.surface,
        selectedItemColor: LightColors.primary,
        unselectedItemColor: AppColors.black,
        selectedIconTheme: const IconThemeData(
          size: AppTokens.iconMD,
          color: LightColors.primary,
        ),
        unselectedIconTheme: const IconThemeData(
          size: AppTokens.iconMD,
          color: AppColors.black,
        ),
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: AppTypography.bold,
          color: LightColors.primary,
        ),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: AppTypography.regular,
          color: AppColors.black,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: LightColors.surface,
        elevation: 24,
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.dialogRadius,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: LightColors.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: LightColors.onSurface,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusSM,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: LightColors.primary,
      ),
    );
  }

  // ============ Dark Theme ============
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: DarkColors.primary,
        onPrimary: DarkColors.onPrimary,
        primaryContainer: AppColors.primaryOrange,
        onPrimaryContainer: AppColors.primaryOrangeLight,
        secondary: DarkColors.secondary,
        onSecondary: DarkColors.onSecondary,
        secondaryContainer: AppColors.secondaryGreen,
        onSecondaryContainer: AppColors.secondaryGreenLight,
        tertiary: AppColors.warningLight,
        onTertiary: AppColors.black,
        error: DarkColors.error,
        onError: DarkColors.onError,
        errorContainer: AppColors.errorDark,
        onErrorContainer: AppColors.errorLight,
        surface: DarkColors.surface,
        onSurface: DarkColors.onSurface,
        surfaceContainerHighest: AppColors.grey800,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.grey700,
        shadow: AppColors.black.withOpacity(0.5),
        scrim: AppColors.black.withOpacity(0.7),
        inverseSurface: AppColors.grey100,
        onInverseSurface: AppColors.grey900,
        inversePrimary: AppColors.primaryOrange,
      ),

      // Typography
      textTheme: AppTypography.textTheme(isDark: true),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: DarkColors.surface,
        foregroundColor: DarkColors.onSurface,
        iconTheme: const IconThemeData(
          color: DarkColors.onSurface,
          size: AppTokens.iconMD,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: DarkColors.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        color: DarkColors.surface,
        shadowColor: AppColors.black.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.cardRadius,
          side: BorderSide(
            color: AppColors.borderDark,
            width: AppTokens.borderWidthThin,
          ),
        ),
        margin: const EdgeInsets.all(AppSpacing.cardMargin),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: DarkColors.primary,
          foregroundColor: DarkColors.onPrimary,
          disabledBackgroundColor: AppColors.grey700,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.buttonRadius,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DarkColors.primary,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          side: const BorderSide(
            color: DarkColors.primary,
            width: AppTokens.borderWidthMedium,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTokens.buttonRadius,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DarkColors.primary,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppTokens.buttonHeightMD),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.all(AppSpacing.inputPadding),
        border: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.borderDark,
            width: AppTokens.borderWidthThin,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.borderDark,
            width: AppTokens.borderWidthThin,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: DarkColors.primary,
            width: AppTokens.borderWidthMedium,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: DarkColors.error,
            width: AppTokens.borderWidthThin,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: DarkColors.error,
            width: AppTokens.borderWidthMedium,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: AppTokens.inputRadius,
          borderSide: BorderSide(
            color: AppColors.grey700,
            width: AppTokens.borderWidthThin,
          ),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabledDark,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: DarkColors.error,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DarkColors.onSurface,
        size: AppTokens.iconMD,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: AppTokens.dividerHeight,
        space: AppSpacing.dividerSpacing,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey800,
        deleteIconColor: AppColors.grey300,
        disabledColor: AppColors.grey700,
        selectedColor: DarkColors.primary.withOpacity(0.24),
        secondarySelectedColor: DarkColors.secondary.withOpacity(0.24),
        labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingSM),
        padding: const EdgeInsets.all(AppSpacing.paddingXS),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.chipRadius,
        ),
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium,
        brightness: Brightness.dark,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.surface,
        selectedItemColor: DarkColors.primary,
        unselectedItemColor: AppColors.grey400,
        selectedIconTheme: const IconThemeData(
          size: AppTokens.iconMD,
          color: DarkColors.primary,
        ),
        unselectedIconTheme: const IconThemeData(
          size: AppTokens.iconMD,
          color: AppColors.grey400,
        ),
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: AppTypography.bold,
          color: DarkColors.primary,
        ),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: AppTypography.regular,
          color: AppColors.grey400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: DarkColors.surface,
        elevation: 24,
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.dialogRadius,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: DarkColors.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: DarkColors.onSurface,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey200,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.grey900,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTokens.borderRadiusSM,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: DarkColors.primary,
      ),
    );
  }
}
