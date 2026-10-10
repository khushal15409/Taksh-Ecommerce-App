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

/// Artwork + accent color chosen for a screen's top area.
class TakshArtStyle {
  final String art;
  final Color accent;

  const TakshArtStyle(this.art, this.accent);
}

/// Local top-of-screen artwork (sliced from the Taksh design mockup).
class TakshArt {
  TakshArt._();

  static const String home = 'assets/illustrations/bg_home.jpg';
  static const String grocery = 'assets/illustrations/bg_grocery.jpg';
  static const String services = 'assets/illustrations/bg_services.jpg';
  static const String electronics = 'assets/illustrations/bg_electronics.jpg';

  static const Color peach = Color(0xFFFFDFC0);
  static const Color mint = Color(0xFFCDEFD8);
  static const Color sky = Color(0xFFCFE8FF);
  static const Color lilac = Color(0xFFE2D8FF);
  static const Color rose = Color(0xFFFFD6E2);
  static const Color lemon = Color(0xFFFFEFB8);
  static const Color aqua = Color(0xFFC8EEF0);
  static const Color apricot = Color(0xFFFFD2B0);

  static const List<Color> _palette = [
    peach,
    mint,
    sky,
    lilac,
    rose,
    lemon,
    aqua,
    apricot,
  ];

  static bool _has(String n, List<String> words) => words.any(n.contains);

  /// Picks the artwork and accent for a category. Known kinds of category get
  /// matching artwork; every other category keeps a neutral illustration but
  /// gets its own accent color (from [seed], normally the category id), so
  /// switching categories always changes the top of the page.
  static TakshArtStyle forCategory(String? name, {int? seed}) {
    final n = (name ?? '').toLowerCase();
    final fallbackAccent = _palette[((seed ?? n.hashCode) & 0x7fffffff) % _palette.length];

    if (_has(n, ['electronic', 'mobile', 'laptop', 'gadget', 'appliance', 'phone', 'audio', 'camera', 'computer'])) {
      return const TakshArtStyle(electronics, apricot);
    }
    if (_has(n, ['grocer', 'fruit', 'veg', 'dairy', 'snack', 'food', 'beverage', 'bakery', 'kitchen', 'staple', 'masala'])) {
      return const TakshArtStyle(grocery, mint);
    }
    if (_has(n, ['home', 'furniture', 'decor', 'garden', 'house', 'living'])) {
      return const TakshArtStyle(services, sky);
    }
    if (_has(n, ['fashion', 'cloth', 'wear', 'shoe', 'footwear', 'apparel'])) {
      return const TakshArtStyle(home, rose);
    }
    if (_has(n, ['beauty', 'cosmetic', 'personal', 'care', 'health'])) {
      return const TakshArtStyle(home, lilac);
    }
    return TakshArtStyle(home, fallbackAccent);
  }

  /// Focus of each artwork so its subject stays visible when the image is
  /// cropped to the phone width.
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

  /// Top color of the page gradient (defaults to the peach of the home page).
  final Color accent;

  const TakshSoftBackground({
    super.key,
    required this.child,
    this.art,
    this.artHeight = 300,
    this.artTop = 0,
    this.accent = TakshArt.peach,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    // The accent color and the artwork cross-fade when they change (for
    // example when another category is selected).
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: accent),
      duration: const Duration(milliseconds: 450),
      builder: (context, color, content) {
        final top = color ?? accent;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                top,
                Color.lerp(top, Colors.white, 0.55)!,
                Color.lerp(top, Colors.white, 0.85)!,
                Colors.white,
              ],
              stops: const [0.0, 0.18, 0.38, 0.65],
            ),
          ),
          child: content,
        );
      },
      child: Stack(
        children: [
          if (art != null)
            Positioned(
              top: artTop > 0 ? artTop + topInset : 0,
              left: 0,
              right: 0,
              height: artTop > 0 ? artHeight : artHeight + topInset,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: ShaderMask(
                    key: ValueKey<String>(art!),
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
                    child: SizedBox.expand(
                      child: Image.asset(
                        art!,
                        fit: BoxFit.cover,
                        alignment: TakshArt.alignmentFor(art!),
                        errorBuilder: (context, error, stack) =>
                            const SizedBox.shrink(),
                      ),
                    ),
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
