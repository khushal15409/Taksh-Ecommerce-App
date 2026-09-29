import 'package:flutter/widgets.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Utility class for input validation
class Validators {
  Validators._();

  /// Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone validation regex (10 digits)
  static final _phoneRegex = RegExp(r'^[0-9]{10}$');

  /// Password validation regex (min 8 chars, 1 uppercase, 1 lowercase, 1 number)
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  /// Validates email address
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates phone number
  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim());
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }

  /// Validates if string is not empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validates minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.trim().length >= minLength;
  }

  /// Validates maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.trim().length <= maxLength;
  }

  /// Validates if two strings match
  static bool matches(String value1, String value2) {
    return value1 == value2;
  }

  /// Validates OTP (6 digits)
  static bool isValidOtp(String otp) {
    final otpRegex = RegExp(r'^[0-9]{4}$');
    return otpRegex.hasMatch(otp.trim());
  }

  /// Validates pincode (6 digits)
  static bool isValidPincode(String pincode) {
    final pincodeRegex = RegExp(r'^[0-9]{6}$');
    return pincodeRegex.hasMatch(pincode.trim());
  }

  /// Get email error message
  static String? getEmailError(BuildContext context, String email) {
    final l10n = AppLocalizations.of(context)!;
    if (email.isEmpty) return l10n.emailRequired;
    if (!isValidEmail(email)) return l10n.invalidEmail;
    return null;
  }

  /// Get phone error message
  static String? getPhoneError(BuildContext context, String phone) {
    final l10n = AppLocalizations.of(context)!;
    if (phone.isEmpty) return l10n.phoneRequired;
    if (!isValidPhone(phone)) return l10n.invalidPhone;
    return null;
  }

  /// Get password error message
  static String? getPasswordError(BuildContext context, String password) {
    final l10n = AppLocalizations.of(context)!;
    if (password.isEmpty) return l10n.passwordRequired;
    if (password.length < 8) return l10n.passwordMinLength;
    if (!_passwordRegex.hasMatch(password)) {
      return l10n.passwordComplexity;
    }
    return null;
  }

  /// Get confirm password error message
  static String? getConfirmPasswordError(
      BuildContext context, String password, String confirmPassword) {
    final l10n = AppLocalizations.of(context)!;
    if (confirmPassword.isEmpty) return l10n.confirmPasswordRequired;
    if (password != confirmPassword) return l10n.passwordsDoNotMatch;
    return null;
  }

  /// Get OTP error message
  static String? getOtpError(BuildContext context, String otp) {
    final l10n = AppLocalizations.of(context)!;
    if (otp.isEmpty) return l10n.otpRequired;
    if (!isValidOtp(otp)) return l10n.invalidOtp;
    return null;
  }

  /// Get name error message
  static String? getNameError(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context)!;
    if (name.isEmpty) return l10n.nameRequired;
    if (name.trim().length < 2) return l10n.nameMinLength;
    return null;
  }
}
