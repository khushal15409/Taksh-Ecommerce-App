import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/data/models/auth_response_model.dart';
import 'package:taksh_e_commerce/features/auth/data/models/update_profile_data.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Send OTP to phone number
  Future<String> sendOtp(String phone);

  /// Verify OTP and get user data
  Future<AuthResponseModel> verifyOtp(
      String phone, String otp, String guestToken);

  /// Fetch user profile from server
  Future<UpdateProfileData> fetchProfile();

  /// Update user profile
  Future<UpdateProfileData> updateProfile(UpdateProfileParams params);
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<String> sendOtp(String phone) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'datasource', 'action': 'sendOtp'});
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Initiating OTP request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.sendOtp,
          'phone_length': phone.length,
        },
      );

      final response = await _apiClient.post(
        ApiConstants.sendOtp,
        data: FormData.fromMap({'mobile': phone}),
      );

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => SendOtpData.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        log.errorWithContext(
          'API returned unsuccessful response',
          {
            'request_id': requestId,
            'success': false,
            'message': baseResponse.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw ServerException(baseResponse.message);
      }

      log.infoWithContext(
        'OTP sent successfully',
        {
          'request_id': requestId,
          'response_message': baseResponse.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      // Return a guest token or empty string based on your needs
      return 'test_token'; // You may want to extract this from response if API provides it
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error sending OTP',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.sendOtp,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp(
    String phone,
    String otp,
    String guestToken,
  ) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'datasource', 'action': 'verifyOtp'});
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Initiating OTP verification request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.verifyOtp,
          'phone_length': phone.length,
          'otp_length': otp.length,
          'has_guest_token': guestToken.isNotEmpty,
        },
      );

      final response = await _apiClient.post(
        ApiConstants.verifyOtp,
        data: FormData.fromMap({
          'mobile': phone,
          'otp': otp,
          'guest_token': guestToken,
        }),
      );

      log.debugWithContext(
        'OTP verification response received',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => AuthData.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        log.errorWithContext(
          'API returned unsuccessful response',
          {
            'request_id': requestId,
            'success': false,
            'message': baseResponse.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw AuthException(baseResponse.message);
      }

      final authData = baseResponse.data;
      if (authData == null) {
        log.errorWithContext(
          'Auth data missing in response',
          {
            'request_id': requestId,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw const ServerException('Auth data not received');
      }

      // Convert BaseResponse to AuthResponseModel for backward compatibility
      final authResponse = AuthResponseModel(
        success: baseResponse.success,
        message: baseResponse.message,
        data: authData,
      );

      log.infoWithContext(
        'OTP verified successfully',
        {
          'request_id': requestId,
          'user_id': authData.user.id,
          'user_name': authData.user.name,
          'has_token': authData.token.isNotEmpty,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      return authResponse;
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error verifying OTP',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.verifyOtp,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e is AppException) rethrow;
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UpdateProfileData> fetchProfile() async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'datasource', 'action': 'fetchProfile'});
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Fetching profile from API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.profile,
        },
      );

      final response = await _apiClient.get(ApiConstants.profile);

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => UpdateProfileData.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        log.errorWithContext(
          'API returned unsuccessful profile fetch response',
          {
            'request_id': requestId,
            'success': false,
            'message': baseResponse.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw ServerException(baseResponse.message);
      }

      log.infoWithContext(
        'Profile fetched successfully',
        {
          'request_id': requestId,
          'response_message': baseResponse.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return baseResponse.data ?? const UpdateProfileData();
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error fetching profile',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.profile,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UpdateProfileData> updateProfile(UpdateProfileParams params) async {
    final log = loggerWithContext(
        {'feature': 'auth', 'layer': 'datasource', 'action': 'updateProfile'});
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final requestData = <String, dynamic>{};

      if (params.firstName?.isNotEmpty ?? false) {
        requestData['first_name'] = params.firstName?.trim();
      }
      if (params.lastName?.isNotEmpty ?? false) {
        requestData['last_name'] = params.lastName?.trim();
      }
      if (params.email?.isNotEmpty ?? false) {
        requestData['email'] = params.email?.trim();
      }
      if (params.mobile?.isNotEmpty ?? false) {
        requestData['mobile'] = params.mobile?.trim();
      }
      if (params.birthday?.isNotEmpty ?? false) {
        requestData['birthday'] = params.birthday?.trim();
      }

      if (requestData.isEmpty) {
        throw const ValidationException('No profile fields provided');
      }

      log.infoWithContext(
        'Initiating profile update request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.updateProfile,
          'fields_count': requestData.length,
        },
      );

      final response = await _apiClient.post(
        ApiConstants.updateProfile,
        data: FormData.fromMap(requestData),
      );

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => UpdateProfileData.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        log.errorWithContext(
          'API returned unsuccessful profile update response',
          {
            'request_id': requestId,
            'success': false,
            'message': baseResponse.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw ServerException(baseResponse.message);
      }

      log.infoWithContext(
        'Profile updated successfully',
        {
          'request_id': requestId,
          'response_message': baseResponse.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return baseResponse.data ?? const UpdateProfileData();
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error updating profile',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.updateProfile,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
