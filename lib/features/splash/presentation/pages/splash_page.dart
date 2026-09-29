import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';

/// Splash screen that displays app branding while checking authentication
/// No business logic here - purely reactive to AuthBloc state changes
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _splashCompleted = false;
  bool _authResolved = false;
  AuthState? _authState;

  @override
  void initState() {
    super.initState();
    // Initialize splash cubit (permissions, location, minimum duration)
    context.read<SplashCubit>().initialize();
  }

  void _checkNavigationReady() async {
    // Only navigate when both splash and auth are complete
    if (!_splashCompleted || !_authResolved || _authState == null) return;

    // Check if onboarding has been completed
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      // First launch - show onboarding
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
      return;
    }

    if (_authState is Authenticated) {
      // User is authenticated, prefetch home data then navigate
      context.read<SplashCubit>().prefetchHomeData().then((_) {
        if (mounted) {
          context.go(AppRoutes.home);
        }
      });
    } else if (_authState is Unauthenticated) {
      // Guest users go directly to home; they can browse freely
      context.go(AppRoutes.home);
    }
    // If still loading, BlocListener will handle navigation
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to SplashCubit state
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashCompleted) {
              setState(() => _splashCompleted = true);
              _checkNavigationReady();
            } else if (state is SplashError) {
              // Handle splash error - could show a retry dialog
              setState(() => _splashCompleted = true);
              _checkNavigationReady();
            }
          },
        ),
        // Listen to AuthBloc state
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated || state is Unauthenticated) {
              setState(() {
                _authResolved = true;
                _authState = state;
              });
              _checkNavigationReady();
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: IndiaGradients.splashGradient,
          ),
          child: Stack(
            children: [
              // Decorative circles for visual interest
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrangeLight.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                right: -100,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryGreenLight.withOpacity(0.2),
                  ),
                ),
              ),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo with stylish container
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light ? Colors.white.withOpacity(0.75) : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white.withOpacity(0.6) : Colors.white.withOpacity(0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withOpacity(0.18),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: AppColors.secondaryGreen.withOpacity(0.12),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'docs/splash_logo.jpeg',
                          width: 160,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light ? Colors.white.withOpacity(0.9) : Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.madeInIndia,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Loading Indicator with tricolor
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange,
                        ),
                        backgroundColor:
                            AppColors.secondaryGreen.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Loading message
                    BlocBuilder<SplashCubit, SplashState>(
                      builder: (context, state) {
                        final l10n = AppLocalizations.of(context)!;
                        String message = l10n.initializing;
                        if (state is SplashLoading && state.message != null) {
                          message = state.message!;
                        } else if (state is SplashCompleted) {
                          if (!_authResolved) {
                            message = l10n.checkingAuthentication;
                          } else if (_authState is Authenticated) {
                            message = l10n.loadingData;
                          }
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light ? Colors.white.withOpacity(0.8) : Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Bottom tricolor stripe
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 6,
                  decoration: const BoxDecoration(
                    gradient: IndiaGradients.tricolorHorizontal,
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
