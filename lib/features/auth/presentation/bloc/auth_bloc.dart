import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/auth_credentials.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/fetch_profile_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/logout_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:taksh_e_commerce/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());
}

/// BLoC for authentication management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final FetchProfileUseCase _fetchProfileUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;

  AuthBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required FetchProfileUseCase fetchProfileUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _logoutUseCase = logoutUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _fetchProfileUseCase = fetchProfileUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _isLoggedInUseCase = isLoggedInUseCase,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSendOtpRequested>(_onSendOtpRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGetCurrentUserRequested>(_onGetCurrentUserRequested);
    on<AuthUpdateProfileRequested>(_onAuthUpdateProfileRequested);
    on<AuthFetchProfileRequested>(_onFetchProfileRequested);
  }

  /// Handle auth check on app start
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'bloc': 'AuthBloc', 'event': 'AuthCheckRequested'});
    final startTime = DateTime.now();
    log.infoWithContext('Starting authentication check', {'action': 'start'});

    emit(const AuthLoading());

    final result = await _isLoggedInUseCase();

    await result.fold(
      (failure) async {
        log.errorWithContext(
          'Auth check failed',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(const Unauthenticated());
      },
      (isLoggedIn) async {
        log.infoWithContext(
          'Auth check result',
          {
            'is_logged_in': isLoggedIn,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );

        if (isLoggedIn) {
          // Get current user if logged in
          final userResult = await _getCurrentUserUseCase();
          userResult.fold(
            (failure) {
              log.errorWithContext(
                'Failed to get current user after auth check',
                {
                  'failure_type': failure.runtimeType.toString(),
                  'failure_message': failure.message,
                },
              );
              if (!emit.isDone) emit(const Unauthenticated());
            },
            (user) {
              log.infoWithContext(
                'User authenticated successfully',
                {
                  'user_id': user.id,
                  'user_name': user.name,
                  'phone_masked': _maskPhone(user.mobile),
                },
              );
              if (!emit.isDone) emit(Authenticated(user));
            },
          );
        } else {
          if (!emit.isDone) emit(const Unauthenticated());
        }
      },
    );
  }

  /// Handle send OTP request
  Future<void> _onSendOtpRequested(
    AuthSendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final startTime = DateTime.now();
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthSendOtpRequested'
    });
    log.infoWithContext(
        'Sending OTP', {'phone_masked': _maskPhone(event.phone)});

    final credentials = AuthCredentials(phone: event.phone);
    final result = await _sendOtpUseCase(credentials);

    result.fold(
      (failure) {
        log.errorWithContext(
          'Send OTP failed',
          {
            'phone_masked': _maskPhone(event.phone),
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(AuthError(failure.message));
      },
      (guestToken) {
        log.infoWithContext(
          'OTP sent successfully',
          {
            'phone_masked': _maskPhone(event.phone),
            'has_guest_token': guestToken.isNotEmpty,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(AuthOtpSent(guestToken: guestToken, phone: event.phone));
        }
      },
    );
  }

  /// Handle verify OTP request
  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthVerifyOtpRequested'
    });
    final startTime = DateTime.now();

    log.infoWithContext(
      'Initiating OTP verification',
      {
        'phone_masked': _maskPhone(event.phone),
        'otp_length': event.otp.length,
        'has_guest_token': event.guestToken.isNotEmpty,
      },
    );

    emit(const AuthLoading());

    final credentials = OtpCredentials(
      phone: event.phone,
      otp: event.otp,
      guestToken: event.guestToken,
    );

    final result = await _verifyOtpUseCase(credentials);

    result.fold(
      (failure) {
        log.errorWithContext(
          'Verify OTP failed',
          {
            'phone_masked': _maskPhone(event.phone),
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(AuthError(failure.message));
      },
      (user) {
        log.infoWithContext(
          'OTP verified and user authenticated',
          {
            'user_id': user.id,
            'user_name': user.name,
            'phone_masked': _maskPhone(user.mobile),
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(Authenticated(user));
      },
    );
  }

  /// Handle logout request
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthLogoutRequested'
    });
    final startTime = DateTime.now();

    log.infoWithContext('Initiating user logout', {'action': 'start'});

    emit(const AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        log.errorWithContext(
          'Logout failed',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(AuthError(failure.message));
      },
      (_) {
        log.infoWithContext(
          'User logged out successfully',
          {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
        );
        if (!emit.isDone) emit(const Unauthenticated());
      },
    );
  }

  /// Handle get current user request
  Future<void> _onGetCurrentUserRequested(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthGetCurrentUserRequested'
    });
    final startTime = DateTime.now();

    log.info('Fetching current user');

    emit(const AuthLoading());

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) {
        log.errorWithContext(
          'Failed to get current user',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(AuthError(failure.message));
      },
      (user) {
        log.infoWithContext(
          'Current user retrieved successfully',
          {
            'user_id': user.id,
            'user_name': user.name,
            'phone_masked': _maskPhone(user.mobile),
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) emit(Authenticated(user));
      },
    );
  }

  /// Handle update profile request
  Future<void> _onAuthUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthUpdateProfileRequested'
    });
    final startTime = DateTime.now();

    if (state is! Authenticated) {
      log.warnWithContext(
        'Update profile attempted without authentication',
        {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
      );
      if (!emit.isDone) emit(const AuthError('User not authenticated'));
      return;
    }

    final currentUser = (state as Authenticated).user;

    final params = UpdateProfileParams(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      mobile: event.mobile,
      birthday: event.birthday,
    );

    log.infoWithContext(
      'Updating user profile',
      {
        'user_id': currentUser.id,
      },
    );

    final result = await _updateProfileUseCase(params);

    result.fold(
      (failure) {
        log.errorWithContext(
          'Update profile failed',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(AuthProfileUpdateFailure(
            user: currentUser,
            message: failure.message,
          ));
        }
      },
      (user) {
        log.infoWithContext(
          'Profile updated successfully',
          {
            'user_id': user.id,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(AuthProfileUpdateSuccess(
            user: user,
            message: AppConstants.profileUpdatedMessage,
          ));
        }
      },
    );
  }

  /// Handle fetch profile request
  Future<void> _onFetchProfileRequested(
    AuthFetchProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'auth',
      'bloc': 'AuthBloc',
      'event': 'AuthFetchProfileRequested'
    });
    final startTime = DateTime.now();

    if (state is! Authenticated) {
      log.warnWithContext(
        'Fetch profile attempted without authentication',
        {'duration_ms': DateTime.now().difference(startTime).inMilliseconds},
      );
      return;
    }

    final currentUser = (state as Authenticated).user;

    log.infoWithContext(
      'Fetching user profile from server',
      {'user_id': currentUser.id},
    );

    final result = await _fetchProfileUseCase();

    result.fold(
      (failure) {
        log.errorWithContext(
          'Fetch profile failed',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        // Don't emit error state, keep the current authenticated state
        // The UI will still show cached data
      },
      (user) {
        log.infoWithContext(
          'Profile fetched successfully',
          {
            'user_id': user.id,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(Authenticated(user));
        }
      },
    );
  }

  /// Helper to mask phone number for logging (shows only last 4 digits)
  String _maskPhone(String phone) {
    if (phone.length <= 4) return '****';
    return '${'*' * (phone.length - 4)}${phone.substring(phone.length - 4)}';
  }
}
