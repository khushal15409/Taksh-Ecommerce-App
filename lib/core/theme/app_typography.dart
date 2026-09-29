import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Typography system for the app
/// Defines all text styles used throughout the application
/// Using Nunito font for a more rounded, friendly look
class AppTypography {
  AppTypography._();

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ============ Display Text Styles ============
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 57,
        fontWeight: regular,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 45,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.22,
      );

  // ============ Headline Text Styles ============
  static TextStyle get headlineLarge => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.33,
      );

  // ============ Title Text Styles ============
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: medium,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ============ Body Text Styles ============
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: 0.5,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ============ Label Text Styles ============
  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // ============ E-Commerce Specific Styles ============
  static TextStyle get productTitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: semiBold,
        letterSpacing: 0.15,
        height: 1.4,
      );

  static TextStyle get productPrice => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: bold,
        letterSpacing: 0,
        height: 1.2,
      );

  static TextStyle get productDiscount => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.2,
      );

  static TextStyle get buttonText => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: semiBold,
        letterSpacing: 0.5,
        height: 1.25,
      );

  // ============ Text Theme Builder ============
  static TextTheme textTheme({bool isDark = false}) {
    final Color color =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return GoogleFonts.nunitoTextTheme(
      TextTheme(
        displayLarge: displayLarge.copyWith(color: color),
        displayMedium: displayMedium.copyWith(color: color),
        displaySmall: displaySmall.copyWith(color: color),
        headlineLarge: headlineLarge.copyWith(color: color),
        headlineMedium: headlineMedium.copyWith(color: color),
        headlineSmall: headlineSmall.copyWith(color: color),
        titleLarge: titleLarge.copyWith(color: color),
        titleMedium: titleMedium.copyWith(color: color),
        titleSmall: titleSmall.copyWith(color: color),
        bodyLarge: bodyLarge.copyWith(color: color),
        bodyMedium: bodyMedium.copyWith(color: color),
        bodySmall: bodySmall.copyWith(color: color),
        labelLarge: labelLarge.copyWith(color: color),
        labelMedium: labelMedium.copyWith(color: color),
        labelSmall: labelSmall.copyWith(color: color),
      ),
    );
  }
}
