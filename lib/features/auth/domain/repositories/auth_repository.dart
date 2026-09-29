import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/auth_credentials.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';

/// Authentication repository contract
abstract class AuthRepository {
  /// Send OTP to phone number for login
  /// Returns guest token for OTP verification
  ResultFuture<String> sendOtp(AuthCredentials credentials);

  /// Verify OTP and complete login
  /// Returns authenticated user
  ResultFuture<User> verifyOtp(OtpCredentials credentials);

  /// Fetch user profile from server
  ResultFuture<User> fetchProfile();

  /// Update profile details
  ResultFuture<User> updateProfile(UpdateProfileParams params);

  /// Logout current user
  ResultVoid logout();

  /// Get current authenticated user from local storage
  ResultFuture<User> getCurrentUser();

  /// Check if user is logged in
  ResultFuture<bool> isLoggedIn();
}
