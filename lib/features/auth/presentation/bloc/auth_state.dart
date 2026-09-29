import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';

/// Base auth state
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial auth state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// OTP sent successfully state
class AuthOtpSent extends AuthState {
  final String guestToken;
  final String phone;

  const AuthOtpSent({
    required this.guestToken,
    required this.phone,
  });

  @override
  List<Object?> get props => [guestToken, phone];
}

/// Authenticated state (user logged in)
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Profile update success state (keeps authenticated user)
class AuthProfileUpdateSuccess extends Authenticated {
  final String message;

  const AuthProfileUpdateSuccess({
    required User user,
    required this.message,
  }) : super(user);

  @override
  List<Object?> get props => [user, message];
}

/// Profile update failure state (keeps authenticated user)
class AuthProfileUpdateFailure extends Authenticated {
  final String message;

  const AuthProfileUpdateFailure({
    required User user,
    required this.message,
  }) : super(user);

  @override
  List<Object?> get props => [user, message];
}

/// Unauthenticated state (user not logged in)
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Auth error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Logout success state
class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}
