import 'package:flutter/material.dart';

/// Design tokens for the app
/// Includes border radius, shadows, animations, and other design properties
class AppTokens {
  AppTokens._();

  // ============ Border Radius ============
  static const double radiusNone = 0.0;
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 9999.0;

  // Border Radius Objects
  static const BorderRadius borderRadiusXS =
      BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM =
      BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD =
      BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG =
      BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL =
      BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL =
      BorderRadius.all(Radius.circular(radiusXXL));
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(radiusFull));

  // Semantic Border Radius
  static const BorderRadius buttonRadius = borderRadiusSM;
  static const BorderRadius cardRadius = borderRadiusMD;
  static const BorderRadius inputRadius = borderRadiusSM;
  static const BorderRadius dialogRadius = borderRadiusLG;
  static const BorderRadius chipRadius = borderRadiusFull;
  static const BorderRadius imageRadius = borderRadiusMD;

  // ============ Border Width ============
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // ============ Shadows / Elevation ============
  // Light elevation shadows
  static const List<BoxShadow> shadowXS = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowSM = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMD = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLG = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  // Semantic shadows
  static const List<BoxShadow> cardShadow = shadowSM;
  static const List<BoxShadow> buttonShadow = shadowXS;
  static const List<BoxShadow> dialogShadow = shadowXL;
  static const List<BoxShadow> appBarShadow = shadowSM;

  // ============ Icon Sizes ============
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;

  // ============ Animation Durations ============
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ============ Animation Curves ============
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.bounceOut;

  // ============ Opacity ============
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  // ============ Divider ============
  static const double dividerHeight = 1.0;
  static const double dividerIndent = 0.0;

  // ============ Image Sizes ============
  static const double imageThumbSize = 80.0;
  static const double imageSmallSize = 120.0;
  static const double imageMediumSize = 200.0;
  static const double imageLargeSize = 300.0;

  // ============ Avatar Sizes ============
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 56.0;
  static const double avatarXL = 72.0;

  // ============ Button Heights ============
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightMD = 40.0;
  static const double buttonHeightLG = 48.0;
  static const double buttonHeightXL = 56.0;

  // ============ Input Heights ============
  static const double inputHeightSM = 36.0;
  static const double inputHeightMD = 48.0;
  static const double inputHeightLG = 56.0;

  // ============ Product Card Dimensions ============
  static const double productCardWidth = 180.0;
  static const double productCardHeight = 280.0;
  static const double productImageHeight = 180.0;

  // ============ Z-Index / Layers ============
  static const double zIndexBase = 0;
  static const double zIndexDropdown = 1000;
  static const double zIndexSticky = 1100;
  static const double zIndexFixed = 1200;
  static const double zIndexModal = 1300;
  static const double zIndexPopover = 1400;
  static const double zIndexTooltip = 1500;
}
