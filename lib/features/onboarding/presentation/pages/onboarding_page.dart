import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Onboarding screen shown only on first app launch.
///
/// Each step has its own background color so the page itself tints to match
/// the step's theme. The tint is interpolated as the user swipes so the
/// transition between pages feels continuous.
///
/// The illustration is rendered in a responsive, rounded-corner card whose
/// size is derived from the available screen width so the layout looks
/// consistent on small phones, large phones, and tablets.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const List<_OnboardingStep> _steps = [
    _OnboardingStep(
      image: 'assets/images/01.png',
      titleKey: _TitleKey.title1,
      subtitleKey: _TitleKey.subtitle1,
      backgroundColor: Color(0xFFFFE9D6), // Light peach
    ),
    _OnboardingStep(
      image: 'assets/images/02.png',
      titleKey: _TitleKey.title2,
      subtitleKey: _TitleKey.subtitle2,
      backgroundColor: AppColors.backgroundLight, // White
    ),
    _OnboardingStep(
      image: 'assets/images/03.png',
      titleKey: _TitleKey.title3,
      subtitleKey: _TitleKey.subtitle3,
      backgroundColor: Color(0xFFE0F2E1), // Light mint
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (!_pageController.hasClients) return;
    final newOffset = _pageController.page ?? 0.0;
    if (newOffset != _pageOffset) {
      setState(() {
        _pageOffset = newOffset;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// Linearly interpolate the page background color as the user swipes
  /// between steps so the color crossfades smoothly.
  Color _interpolatedBackgroundColor() {
    final clampedOffset = _pageOffset.clamp(
      0.0,
      (_steps.length - 1).toDouble(),
    );
    final lowerIndex = clampedOffset.floor();
    final upperIndex = (lowerIndex + 1).clamp(0, _steps.length - 1);
    final t = (clampedOffset - lowerIndex).clamp(0.0, 1.0);

    return Color.lerp(
      _steps[lowerIndex].backgroundColor,
      _steps[upperIndex].backgroundColor,
      t,
    )!;
  }

  String _titleFor(_TitleKey key) {
    final l10n = AppLocalizations.of(context)!;
    return switch (key) {
      _TitleKey.title1 => l10n.onboardingTitle1,
      _TitleKey.title2 => l10n.onboardingTitle2,
      _TitleKey.title3 => l10n.onboardingTitle3,
      _ => '',
    };
  }

  String _subtitleFor(_TitleKey key) {
    final l10n = AppLocalizations.of(context)!;
    return switch (key) {
      _TitleKey.subtitle1 => l10n.onboardingSubtitle1,
      _TitleKey.subtitle2 => l10n.onboardingSubtitle2,
      _TitleKey.subtitle3 => l10n.onboardingSubtitle3,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLastPage = _currentPage == _steps.length - 1;
    final backgroundColor = _interpolatedBackgroundColor();

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // Top bar — Skip button anchored to the right so it does
              // not compete with the centered illustration.
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      color: AppColors.grey600,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Swipeable content — illustration on top, title/subtitle
              // below. Each page is a Column with two Expanded children
              // (image flex 6, text flex 4) so the image dominates the
              // page without forcing a hardcoded height.
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        // Illustration — wrapped directly in a ClipRRect
                        // (not a Container) so the rounding is applied
                        // to the image itself.
                        //
                        // The image shares the page column with the
                        // text via Expanded flex values (6 for the
                        // image, 4 for the text) so it owns ~60% of the
                        // available height — the dominant visual
                        // element on the screen. BoxFit.contain scales
                        // the portrait source to fit the available
                        // space without cropping or distortion, and
                        // width:double.infinity lets the image scale
                        // smoothly across phone and tablet sizes.
                        Expanded(
                          flex: 7,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 480,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(40),
                                  child: Image.asset(
                                    step.image,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              24,
                              28,
                              24,
                              8,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _titleFor(step.titleKey),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.grey900,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _subtitleFor(step.subtitleKey),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.grey600,
                                        height: 1.45,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Page indicator dots.
              _PageIndicator(
                count: _steps.length,
                currentIndex: _currentPage,
                activeColor: AppColors.primaryOrange,
                inactiveColor: AppColors.grey300,
              ),

              const SizedBox(height: 24),

              // Bottom action button — Next or Get Started.
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastPage ? l10n.getStarted : l10n.next,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final String image;
  final _TitleKey titleKey;
  final _TitleKey subtitleKey;
  final Color backgroundColor;

  const _OnboardingStep({
    required this.image,
    required this.titleKey,
    required this.subtitleKey,
    required this.backgroundColor,
  });
}

/// Discriminates which title/subtitle string to read from [AppLocalizations].
/// Keeping the key inside the step avoids two parallel lists.
enum _TitleKey { title1, subtitle1, title2, subtitle2, title3, subtitle3 }

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const _PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
