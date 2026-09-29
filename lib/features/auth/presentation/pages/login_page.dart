import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

/// Login page with phone number input
/// Uses global AuthBloc - no local BlocProvider needed
class LoginPage extends StatefulWidget {
  /// Optional destination to navigate to after successful login.
  /// Supplied via the `redirectAfter` query parameter by the router guard.
  final String? redirectAfter;

  const LoginPage({super.key, this.redirectAfter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _log = loggerWithContext({'feature': 'auth', 'page': 'LoginPage'});
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _log.infoWithContext('Login page displayed', {'action': 'init'});
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp(BuildContext context) {
    _log.debugWithContext('Send OTP button pressed', {'action': 'user_action'});

    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      _log.infoWithContext('Form validated, dispatching send OTP event', {
        'phone_length': phone.length,
      });
      context.read<AuthBloc>().add(AuthSendOtpRequested(phone));
    } else {
      _log.warnWithContext('Form validation failed', {
        'action': 'validation_error',
      });
    }
  }

  void _handleBrowseAsGuest(BuildContext context) {
    _log.infoWithContext('User chose to browse as guest', {'action': 'guest'});
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          _log.debugWithContext('Auth state changed', {
            'state': state.runtimeType.toString(),
          });

          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is AuthOtpSent) {
            _log.infoWithContext(
              'OTP sent successfully, navigating to verify OTP',
              {'phone_length': state.phone.length},
            );
            // Forward the redirectAfter so the verify page can return the
            // user to their original destination after login.
            final redirectParam = widget.redirectAfter != null
                ? '&redirect_after=${Uri.encodeComponent(widget.redirectAfter!)}'
                : '';
            context.go(
              '${AppRoutes.verifyOtp}?phone=${state.phone}&guest_token=${state.guestToken}$redirectParam',
            );
          }

          if (state is AuthError) {
            AppErrorToast.show(context);
          }
        },
        builder: (context, state) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: IndiaGradients.subtleTricolor,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: size.height * 0.08),

                      // App Logo — same as splash screen
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? Colors.white.withOpacity(0.75)
                                : Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: theme.brightness == Brightness.light
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.2),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primaryOrange.withOpacity(0.18),
                                blurRadius: 28,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color:
                                    AppColors.secondaryGreen.withOpacity(0.12),
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
                      ),
                      const SizedBox(height: 16),

                      // "Made in India" tagline — same as splash screen
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? Colors.white.withOpacity(0.9)
                                : theme.cardColor.withOpacity(0.8),
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
                                  color: theme.textTheme.bodyMedium?.color,
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
                      ),

                      const SizedBox(height: AppConstants.largePadding * 2),

                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title with tricolor underline
                            Text(
                              AppLocalizations.of(context)!.login,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: IndiaGradients.cardAccentGradient,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: AppConstants.smallPadding),

                            Text(
                              AppLocalizations.of(
                                context,
                              )!.enterPhoneDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),

                            const SizedBox(
                              height: AppConstants.defaultPadding * 1.5,
                            ),

                            // Phone number input with tricolor focus
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: AppConstants.phoneLength,
                              enabled: !_isLoading,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  AppConstants.phoneLength,
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(
                                  context,
                                )!.phoneNumber,
                                hintText: AppLocalizations.of(
                                  context,
                                )!.enterPhoneNumberHint,
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: IndiaGradients.saffronGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.dividerColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryOrange,
                                    width: 2,
                                  ),
                                ),
                                counterText: '',
                              ),
                              validator: (value) => Validators.getPhoneError(
                                context,
                                value ?? '',
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleSendOtp(context),
                            ),

                            const SizedBox(
                              height: AppConstants.defaultPadding * 1.5,
                            ),

                            // Send OTP button with gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: _isLoading
                                    ? null
                                    : IndiaGradients.saffronGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isLoading
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: AppColors.primaryOrange
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: FilledButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => _handleSendOtp(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: theme.disabledColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.defaultPadding,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.sendOtp,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.defaultPadding),

                      // ── Browse as Guest ──────────────────────────────────
                      // Only show when login is not mandatory (i.e. user
                      // navigated here voluntarily, not via a route guard).
                      if (widget.redirectAfter == null) ...[
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'or',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey500,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        OutlinedButton.icon(
                          onPressed: () => _handleBrowseAsGuest(context),
                          icon: const Icon(Icons.explore_outlined),
                          label: const Text('Browse as Guest'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.grey700,
                            side: const BorderSide(color: AppColors.grey300),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.defaultPadding,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                      ],

                      // Terms and conditions
                      Text(
                        AppLocalizations.of(context)!.termsAndPrivacy,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppConstants.defaultPadding * 2),

                      // Bottom tricolor stripe
                      Center(
                        child: Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: IndiaGradients.tricolorHorizontal,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                  // ── Cancel button (top-left, on top of scroll content) ──
                  // Shown when the user was redirected here from a
                  // GuestAuthWall or inline auth guard (redirectAfter != null).
                  // Uses Navigator.pop to dismiss this pushed page and return
                  // to whatever screen was underneath.
                  if (widget.redirectAfter != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () {
                          // Pop this login page off the stack. Works reliably
                          // regardless of whether redirectAfter points to an
                          // auth-required route (which context.go would
                          // redirect back to login).
                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .cardColor
                              .withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: AppLocalizations.of(context)!.loginCancelButton,
                      ),
                    ),
            ],
          ),
            ),
          );
        },
      ),
    );
  }
}
