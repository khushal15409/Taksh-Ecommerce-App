import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Shows a creative "Login to access" placeholder for guest users.
///
/// Uses [context.push] so that the login page is pushed on top of the current
/// shell tab, and the user can navigate back with the cancel button on the
/// login page.
///
/// After login the user is returned to [redirectToRoute] (defaults to home).
///
/// Usage: wrap protected tab content with a BlocBuilder on AuthBloc and show
/// this widget when the user is unauthenticated.
class GuestAuthWall extends StatelessWidget {
  /// The route the user should land on after logging in.
  final String redirectToRoute;

  /// Descriptive label shown in text, e.g. "your orders".
  final String contentLabel;

  /// Primary icon to display — should reflect the restricted section.
  final IconData icon;

  const GuestAuthWall({
    super.key,
    required this.redirectToRoute,
    this.contentLabel = 'this page',
    this.icon = Icons.lock_outline_rounded,
  });

  void _goToLogin(BuildContext context) {
    final encoded = Uri.encodeComponent(redirectToRoute);
    // Use push so the login page sits on top of the shell and the user can
    // press the cancel button to pop back to the current tab.
    context.push('${AppRoutes.login}?redirectAfter=$encoded');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : IndiaGradients.subtleTricolor,
          color: isDark ? theme.scaffoldBackgroundColor : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),

                // ── Animated-style illustration area ──
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer decorative ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryOrange.withOpacity(0.10),
                            AppColors.secondaryGreen.withOpacity(0.10),
                          ],
                        ),
                      ),
                    ),
                    // Inner decorative ring
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.primaryOrange.withOpacity(0.18),
                            AppColors.secondaryGreen.withOpacity(0.18),
                          ],
                        ),
                      ),
                    ),
                    // Icon circle
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withOpacity(0.15),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 48,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // ── Title ──
                Text(
                  l10n.guestWallTitle(contentLabel),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // ── Subtitle ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.guestWallSubtitle(contentLabel),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // ── Login Button ──
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: IndiaGradients.saffronGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FilledButton.icon(
                      onPressed: () => _goToLogin(context),
                      icon: const Icon(Icons.login_rounded),
                      label: Text(
                        l10n.guestWallLoginButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Continue browsing hint ──
                TextButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: Icon(
                    Icons.explore_outlined,
                    size: 18,
                    color: isDark ? AppColors.grey400 : AppColors.grey600,
                  ),
                  label: Text(
                    l10n.guestWallContinueBrowsing,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Bottom tricolor accent ──
                Center(
                  child: Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: IndiaGradients.cardAccentGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
