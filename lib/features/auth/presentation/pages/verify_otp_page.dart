import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/routing/app_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/utils/validators.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

/// OTP verification page
class VerifyOtpPage extends StatefulWidget {
  final String phone;
  final String guestToken;

  /// Optional destination to navigate to after successful login.
  final String? redirectAfter;

  const VerifyOtpPage({
    super.key,
    required this.phone,
    required this.guestToken,
    this.redirectAfter,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      context.read<AuthBloc>().add(
        AuthVerifyOtpRequested(
          phone: widget.phone,
          otp: otp,
          guestToken: widget.guestToken,
        ),
      );
    }
  }

  void _handleResendOtp() {
    // Resend OTP logic
    context.read<AuthBloc>().add(AuthSendOtpRequested(widget.phone));
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryOrange),
            onPressed: () => context.go(AppRoutes.login),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is Authenticated) {
            // Navigate to home page or the original destination
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.loginSuccess),
                backgroundColor: AppColors.secondaryGreen,
              ),
            );
            // go(home) + push(destination) so back/swipe returns to home
            // instead of exiting the app (plain go replaces the whole stack).
            AppRouter.navigateAfterAuth(
              GoRouter.of(context),
              redirectAfter: widget.redirectAfter,
            );
          }

          if (state is AuthOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.otpResentSuccess),
                backgroundColor: AppColors.secondaryGreen,
              ),
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
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.light
                  ? IndiaGradients.subtleTricolor
                  : null,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : null,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: size.height * 0.03),

                      // Icon with tricolor circle
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryGreen.withOpacity(
                                  0.2,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.phonelink_ring_outlined,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Title
                      Text(
                        AppLocalizations.of(context)!.verifyOtp,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.smallPadding),

                      // Description with tricolor dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.enterOtpDescription(widget.phone),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.defaultPadding * 2),

                      // OTP Card
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
                          children: [
                            // OTP input
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: AppConstants.otpLength,
                              enabled: !_isLoading,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                letterSpacing: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  AppConstants.otpLength,
                                ),
                              ],
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.otpHint,
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
                                    color: AppColors.secondaryGreen,
                                    width: 2,
                                  ),
                                ),
                                counterText: '',
                              ),
                              validator: (value) =>
                                  Validators.getOtpError(context, value ?? ''),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleVerifyOtp(),
                            ),

                            const SizedBox(
                              height: AppConstants.defaultPadding * 1.5,
                            ),

                            // Verify button with green gradient
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: _isLoading
                                    ? null
                                    : IndiaGradients.greenGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isLoading
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: AppColors.secondaryGreen
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: FilledButton(
                                onPressed: _isLoading ? null : _handleVerifyOtp,
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
                                        AppLocalizations.of(
                                          context,
                                        )!.verifyOtpButton,
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

                      // Resend OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.didNotReceiveCode,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          if (_resendTimer > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.resendIn(_resendTimer),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            TextButton(
                              onPressed: _isLoading ? null : _handleResendOtp,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryOrange,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.resendOtp,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
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
            ),
          );
        },
      ),
    );
  }
}
