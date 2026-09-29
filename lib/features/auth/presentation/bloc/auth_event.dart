import 'package:equatable/equatable.dart';

/// Base auth event
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status on app start
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to send OTP to phone number
class AuthSendOtpRequested extends AuthEvent {
  final String phone;

  const AuthSendOtpRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// Event to verify OTP and complete login
class AuthVerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;
  final String guestToken;

  const AuthVerifyOtpRequested({
    required this.phone,
    required this.otp,
    required this.guestToken,
  });

  @override
  List<Object?> get props => [phone, otp, guestToken];
}

/// Event to logout user
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to get current user
class AuthGetCurrentUserRequested extends AuthEvent {
  const AuthGetCurrentUserRequested();
}

/// Event to update profile details
class AuthUpdateProfileRequested extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? birthday;

  const AuthUpdateProfileRequested({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.birthday,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, mobile, birthday];
}

/// Event to fetch profile from server
class AuthFetchProfileRequested extends AuthEvent {
  const AuthFetchProfileRequested();
}
