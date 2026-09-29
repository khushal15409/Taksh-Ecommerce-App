import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:taksh_e_commerce/features/auth/data/models/update_profile_data.dart';
import 'package:taksh_e_commerce/features/auth/data/models/user_model.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/auth_credentials.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  ResultFuture<String> sendOtp(AuthCredentials credentials) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'sendOtp'});
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      log.debugWithContext(
          'Checking network connectivity', {'action': 'network_check'});
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      log.debugWithContext(
        'Network available, proceeding with OTP request',
        {'phone_length': credentials.phone.length},
      );

      // Send OTP via remote data source
      final guestToken = await _remoteDataSource.sendOtp(credentials.phone);

      log.infoWithContext(
        'OTP sent successfully',
        {
          'has_guest_token': guestToken.isNotEmpty,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(guestToken);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error during send OTP',
        {
          'error_type': 'NetworkException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error during send OTP',
        {
          'error_type': 'ServerException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e, stackTrace) {
      log.errorWithContext(
        'Validation error during send OTP',
        {
          'error_type': 'ValidationException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ValidationFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error during send OTP',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<User> verifyOtp(OtpCredentials credentials) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'verifyOtp'});
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      log.debugWithContext(
          'Checking network connectivity', {'action': 'network_check'});
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      log.infoWithContext(
        'Verifying OTP with remote server',
        {
          'phone_length': credentials.phone.length,
          'otp_length': credentials.otp.length,
        },
      );

      // Verify OTP via remote data source
      final authResponse = await _remoteDataSource.verifyOtp(
        credentials.phone,
        credentials.otp,
        credentials.guestToken,
      );

      // User model is already in the response
      final userModel = authResponse.user;

      log.debugWithContext(
        'Saving user data locally',
        {
          'action': 'cache_save',
        },
      );
      // Save user data and token locally
      await _localDataSource.saveUser(userModel);
      await _localDataSource.saveToken(authResponse.token);
      await _localDataSource.setLoggedIn(true);

      log.infoWithContext(
        'OTP verified and user data saved',
        {
          'user_id': userModel.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(userModel);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error during verify OTP',
        {
          'error_type': 'NetworkException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e, stackTrace) {
      log.errorWithContext(
        'Auth error during verify OTP',
        {
          'error_type': 'AuthException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(AuthFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error during verify OTP',
        {
          'error_type': 'ServerException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e, stackTrace) {
      log.errorWithContext(
        'Validation error during verify OTP',
        {
          'error_type': 'ValidationException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error during verify OTP',
        {
          'error_type': 'CacheException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error during verify OTP',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultVoid logout() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'logout'});
    final startTime = DateTime.now();

    try {
      log.debugWithContext(
          'Clearing local user data', {'action': 'cache_clear'});
      // Clear local user data
      await _localDataSource.clearUserData();

      log.infoWithContext(
        'User logged out successfully',
        {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
      );
      return const Right(null);
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error during logout',
        {
          'error_type': 'CacheException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error during logout',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<User> fetchProfile() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'fetchProfile'});
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      log.debugWithContext(
          'Checking network connectivity', {'action': 'network_check'});
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      log.infoWithContext(
        'Fetching profile from remote data source',
        {},
      );

      final profileData = await _remoteDataSource.fetchProfile();

      log.debugWithContext(
        'Fetching current user for merge',
        {'action': 'cache_read'},
      );
      final currentUser = await _localDataSource.getUser();

      // Merge profile data with current user
      final updatedUser = _mergeProfileData(currentUser, profileData);

      log.debugWithContext(
        'Saving updated user locally',
        {'action': 'cache_save'},
      );
      await _localDataSource.saveUser(updatedUser);

      log.infoWithContext(
        'Profile fetched and saved successfully',
        {
          'user_id': updatedUser.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(updatedUser);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error during fetch profile',
        {
          'error_type': 'NetworkException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error during fetch profile',
        {
          'error_type': 'ServerException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error during fetch profile',
        {
          'error_type': 'CacheException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error during fetch profile',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<User> updateProfile(UpdateProfileParams params) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'updateProfile'});
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      log.debugWithContext(
          'Checking network connectivity', {'action': 'network_check'});
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      if (!params.hasUpdates) {
        log.warnWithContext(
          'No profile updates provided',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        return const Left(ValidationFailure('No profile updates provided'));
      }

      log.infoWithContext(
        'Updating profile via remote data source',
        {},
      );

      final updateData = await _remoteDataSource.updateProfile(params);

      log.debugWithContext(
        'Fetching current user for merge',
        {'action': 'cache_read'},
      );
      final currentUser = await _localDataSource.getUser();

      final updatedUser = _mergeUpdatedUser(currentUser, updateData, params);

      log.debugWithContext(
        'Saving updated user locally',
        {'action': 'cache_save'},
      );
      await _localDataSource.saveUser(updatedUser);

      log.infoWithContext(
        'Profile updated successfully',
        {
          'user_id': updatedUser.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(updatedUser);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error during update profile',
        {
          'error_type': 'NetworkException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error during update profile',
        {
          'error_type': 'ServerException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e, stackTrace) {
      log.errorWithContext(
        'Validation error during update profile',
        {
          'error_type': 'ValidationException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error during update profile',
        {
          'error_type': 'CacheException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error during update profile',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<User> getCurrentUser() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'getCurrentUser'});
    final startTime = DateTime.now();

    try {
      log.debugWithContext(
          'Fetching user from local storage', {'action': 'cache_read'});
      // Get user from local storage
      final user = await _localDataSource.getUser();

      log.infoWithContext(
        'Current user retrieved',
        {
          'user_id': user.id,
          'user_name': user.name,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(user);
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error getting current user',
        {
          'error_type': 'CacheException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error getting current user',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> isLoggedIn() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'repository', 'action': 'isLoggedIn'});
    final startTime = DateTime.now();

    try {
      // Check logged in status from local storage
      final isLoggedIn = await _localDataSource.isLoggedIn();

      log.debugWithContext(
        'Logged in status checked',
        {
          'is_logged_in': isLoggedIn,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return Right(isLoggedIn);
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error checking logged in status',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return const Right(false);
    }
  }

  UserModel _mergeUpdatedUser(
    UserModel currentUser,
    UpdateProfileData updateData,
    UpdateProfileParams params,
  ) {
    final resolvedName = updateData.fullName ??
        _combineName(
          params.firstName,
          params.lastName,
          fallback: currentUser.name,
        );

    // Use helper to properly merge values, treating empty strings as null
    final resolvedEmail = _resolveValue(
      updateData.email,
      params.email,
      currentUser.email,
    );

    final resolvedMobile = _resolveValue(
      updateData.mobile,
      params.mobile,
      currentUser.mobile,
    );

    final resolvedBirthday = _resolveValue(
      updateData.birthday,
      params.birthday,
      currentUser.birthday,
    );

    return currentUser.copyWith(
      name: resolvedName,
      email: resolvedEmail,
      mobile: resolvedMobile,
      birthday: resolvedBirthday,
      updatedAt: DateTime.now(),
    );
  }

  /// Merge profile data fetched from server with current user
  UserModel _mergeProfileData(
    UserModel currentUser,
    UpdateProfileData profileData,
  ) {
    final resolvedName = profileData.fullName ?? currentUser.name;

    // Use non-empty values from profile data, fallback to current user
    final resolvedEmail =
        (profileData.email != null && profileData.email!.trim().isNotEmpty)
            ? profileData.email!.trim()
            : currentUser.email;

    final resolvedMobile =
        (profileData.mobile != null && profileData.mobile!.trim().isNotEmpty)
            ? profileData.mobile!.trim()
            : currentUser.mobile;

    final resolvedBirthday = (profileData.birthday != null &&
            profileData.birthday!.trim().isNotEmpty)
        ? profileData.birthday!.trim()
        : currentUser.birthday;

    return currentUser.copyWith(
      name: resolvedName,
      email: resolvedEmail,
      mobile: resolvedMobile,
      birthday: resolvedBirthday,
      updatedAt: DateTime.now(),
    );
  }

  /// Helper to resolve a value from multiple sources.
  /// Treats empty strings as null to prevent overwriting valid values
  /// with empty API responses.
  String? _resolveValue(
    String? apiValue,
    String? paramValue,
    String? currentValue,
  ) {
    // First priority: non-empty API response value
    if (apiValue != null && apiValue.trim().isNotEmpty) {
      return apiValue.trim();
    }
    // Second priority: non-empty param value (user input)
    if (paramValue != null && paramValue.trim().isNotEmpty) {
      return paramValue.trim();
    }
    // Fallback: current value
    return currentValue;
  }

  String? _combineName(
    String? firstName,
    String? lastName, {
    String? fallback,
  }) {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final combined = '$first $last'.trim();
    return combined.isNotEmpty ? combined : fallback;
  }
}
