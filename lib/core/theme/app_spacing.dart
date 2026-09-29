/// Spacing system for the app
/// Provides consistent spacing values throughout the application
/// Based on 8pt grid system
class AppSpacing {
  AppSpacing._();

  // ============ Base Spacing Values ============
  static const double xxxs = 2.0; // 2px
  static const double xxs = 4.0; // 4px
  static const double xs = 8.0; // 8px (base unit)
  static const double sm = 12.0; // 12px
  static const double md = 16.0; // 16px
  static const double lg = 24.0; // 24px
  static const double xl = 32.0; // 32px
  static const double xxl = 40.0; // 40px
  static const double xxxl = 48.0; // 48px
  static const double huge = 64.0; // 64px

  // ============ Semantic Spacing ============
  // Padding
  static const double paddingXS = xs;
  static const double paddingSM = sm;
  static const double paddingMD = md;
  static const double paddingLG = lg;
  static const double paddingXL = xl;

  // Margin
  static const double marginXS = xs;
  static const double marginSM = sm;
  static const double marginMD = md;
  static const double marginLG = lg;
  static const double marginXL = xl;

  // Gap (for Flex widgets)
  static const double gapXS = xs;
  static const double gapSM = sm;
  static const double gapMD = md;
  static const double gapLG = lg;
  static const double gapXL = xl;

  // ============ Screen Padding ============
  static const double screenPaddingHorizontal = md;
  static const double screenPaddingVertical = md;
  static const double screenPaddingTop = lg;
  static const double screenPaddingBottom = lg;

  // ============ Card & Container Spacing ============
  static const double cardPadding = md;
  static const double cardMargin = md;
  static const double containerPadding = md;

  // ============ List Item Spacing ============
  static const double listItemPadding = md;
  static const double listItemGap = sm;
  static const double listTilePadding = md;

  // ============ Form Spacing ============
  static const double formFieldGap = md;
  static const double formSectionGap = lg;
  static const double inputPadding = md;

  // ============ Button Spacing ============
  static const double buttonPaddingHorizontal = lg;
  static const double buttonPaddingVertical = sm;
  static const double buttonGap = md;
  static const double iconButtonPadding = xs;

  // ============ App Bar Spacing ============
  static const double appBarPadding = md;
  static const double appBarHeight = 56.0;

  // ============ Bottom Navigation Spacing ============
  static const double bottomNavHeight = 56.0;
  static const double bottomNavPadding = xs;

  // ============ Product Card Spacing ============
  static const double productCardPadding = sm;
  static const double productCardImageSpacing = xs;
  static const double productCardContentGap = xs;

  // ============ Divider Spacing ============
  static const double dividerSpacing = md;
  static const double dividerThickness = 1.0;
}
