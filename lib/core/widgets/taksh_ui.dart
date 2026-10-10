import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Shared visual building blocks for the Taksh storefront design
/// (orange accents, white surfaces, soft shadows, rounded cards).

/// Soft card shadow used by cards, search bars and tiles.
const List<BoxShadow> takshSoftShadow = [
  BoxShadow(
    color: Color(0x14000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
];

/// Formats a rupee amount, dropping the decimals for whole numbers.
String formatRupees(double value) {
  final isWhole = value == value.truncateToDouble();
  return '₹${isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(2)}';
}

/// Local top-of-screen artwork (sliced from the Taksh design mockup).
class TakshArt {
  TakshArt._();

  static const String home = 'assets/illustrations/bg_home.jpg';
  static const String grocery = 'assets/illustrations/bg_grocery.jpg';
  static const String services = 'assets/illustrations/bg_services.jpg';
  static const String electronics = 'assets/illustrations/bg_electronics.jpg';

  /// Picks artwork for a product category from its name, falling back to the
  /// generic home artwork.
  static String forCategory(String? name) {
    final n = (name ?? '').toLowerCase();
    const electronicsWords = ['electronic', 'mobile', 'laptop', 'gadget', 'appliance', 'phone', 'audio', 'camera'];
    const groceryWords = ['grocer', 'fruit', 'veg', 'dairy', 'snack', 'food', 'beverage', 'bakery', 'kitchen'];
    if (electronicsWords.any(n.contains)) return electronics;
    if (groceryWords.any(n.contains)) return grocery;
    return home;
  }

  /// Horizontal focus of each artwork so the subject stays visible when the
  /// image is cropped to the phone width.
  static Alignment alignmentFor(String art) {
    if (art == services) return const Alignment(0.9, -0.2);
    if (art == grocery) return const Alignment(0.85, 0.2);
    if (art == electronics) return const Alignment(0.85, 0.3);
    return Alignment.topCenter;
  }
}

/// Page backdrop: peach-to-white gradient with, when [art] is given, a local
/// illustration across the top that fades into the page. Without [art] it
/// shows soft orange and green glows in the top corners.
class TakshSoftBackground extends StatelessWidget {
  final Widget child;
  final String? art;

  /// Visible art height below the status bar.
  final double artHeight;

  /// Distance of the art from the top of the content area (below the status
  /// bar). Use a positive value to place the art lower on the page; its top
  /// edge then fades in as well.
  final double artTop;

  const TakshSoftBackground({
    super.key,
    required this.child,
    this.art,
    this.artHeight = 300,
    this.artTop = 0,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFDFC0),
            Color(0xFFFFEEDC),
            Color(0xFFFFFAF5),
            Colors.white,
          ],
          stops: [0.0, 0.18, 0.38, 0.65],
        ),
      ),
      child: Stack(
        children: [
          if (art != null)
            Positioned(
              top: artTop > 0 ? artTop + topInset : 0,
              left: 0,
              right: 0,
              height: artTop > 0 ? artHeight : artHeight + topInset,
              child: IgnorePointer(
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: artTop > 0
                        ? const [
                            Colors.transparent,
                            Colors.white,
                            Colors.white,
                            Colors.transparent,
                          ]
                        : const [
                            Colors.white,
                            Colors.white,
                            Colors.transparent,
                          ],
                    stops: artTop > 0
                        ? const [0.0, 0.22, 0.62, 1.0]
                        : const [0.0, 0.62, 1.0],
                  ).createShader(rect),
                  child: Image.asset(
                    art!,
                    fit: BoxFit.cover,
                    alignment: TakshArt.alignmentFor(art!),
                    errorBuilder: (context, error, stack) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            )
          else ...const [
            Positioned(
              top: -110,
              right: -110,
              child: _Glow(size: 300, color: Color(0xFF7ED9A0), alpha: 0.5),
            ),
            Positioned(
              top: -110,
              left: -90,
              child: _Glow(size: 280, color: Color(0xFFFF7A1A), alpha: 0.2),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  final double alpha;

  const _Glow({required this.size, required this.color, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(alpha), color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}

/// Section title with an optional "View All" action.
class TakshSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String viewAllLabel;

  const TakshSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.viewAllLabel = 'View All',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.grey900,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (onViewAll != null)
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewAllLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.grey800,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Tappable, read-only search bar that opens the search screen.
class TakshSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const TakshSearchBar({super.key, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: takshSoftShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.grey700,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small rounded "NN% OFF" badge shown on product images.
class TakshDiscountBadge extends StatelessWidget {
  final int percent;

  const TakshDiscountBadge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$percent% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
