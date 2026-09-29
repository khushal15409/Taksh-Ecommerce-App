import 'package:equatable/equatable.dart';

/// Authentication credentials for login
class AuthCredentials extends Equatable {
  final String phone;

  const AuthCredentials({
    required this.phone,
  });

  @override
  List<Object?> get props => [phone];

  @override
  String toString() {
    return 'AuthCredentials(phone: $phone)';
  }
}

/// OTP verification credentials
class OtpCredentials extends Equatable {
  final String phone;
  final String otp;
  final String guestToken;

  const OtpCredentials({
    required this.phone,
    required this.otp,
    required this.guestToken,
  });

  @override
  List<Object?> get props => [phone, otp, guestToken];

  @override
  String toString() {
    return 'OtpCredentials(phone: $phone, otp: $otp, guestToken: $guestToken)';
  }
}
