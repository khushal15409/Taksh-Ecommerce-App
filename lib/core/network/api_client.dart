import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/secure_store.dart';

/// API client wrapper around Dio with interceptors and error handling
class ApiClient {
  late final Dio _dio;
  final SecureStore _secureStore;
  final String baseUrl;

  ApiClient({
    required this.baseUrl,
    required SecureStore secureStore,
  }) : _secureStore = secureStore {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) {
          // Accept all status codes from 200-299 and handle redirects
          return status != null && status >= 200 && status < 300;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// Expose the underlying Dio instance for advanced use cases (e.g.
  /// streaming binary downloads with custom response types).
  Dio get dio => _dio;

  /// Get the currently stored auth token, if any.
  Future<String?> get authToken => _secureStore.getToken();

  /// Setup request/response interceptors
  void _setupInterceptors() {
    final log = loggerWithContext({'feature': 'network', 'class': 'ApiClient'});
    log.infoWithContext('Setting up API interceptors', {'action': 'init'});

    // Add verbose logging interceptor (only for debugging)
    // _dio.interceptors.add(VerboseInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Generate unique request ID
          final requestId = DateTime.now().millisecondsSinceEpoch.toString();
          options.extra['request_id'] = requestId;
          options.extra['start_time'] = DateTime.now();

          // Inject authentication token
          final token = await _secureStore.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            log.debugWithContext(
              'Auth token injected',
              {'request_id': requestId, 'has_token': true},
            );
          }

          // Log request
          final requestData = options.data is FormData
              ? (options.data as FormData).fields.fold<Map<String, dynamic>>({},
                  (map, field) {
                  map[field.key] = field.value;
                  return map;
                })
              : options.data;

          print(
              '🚀 API Request: ${options.method} ${options.baseUrl}${options.path}');
          if (options.queryParameters.isNotEmpty) {
            print('❓ Query Parameters: ${options.queryParameters}');
          }
          if (requestData != null) {
            print('📦 Request Body: $requestData');
          }

          log.infoWithContext(
            'API Request initiated',
            {
              'request_id': requestId,
              'method': options.method,
              'path': options.path,
              'has_data': requestData != null,
              'has_query_params': options.queryParameters.isNotEmpty,
            },
          );

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final requestId = response.requestOptions.extra['request_id'];
          final startTime =
              response.requestOptions.extra['start_time'] as DateTime?;
          final duration = startTime != null
              ? DateTime.now().difference(startTime).inMilliseconds
              : 0;

          // Log response
          print(
              '✅ API Response [${response.statusCode}] ${response.requestOptions.path}');
          print('📨 Response Body: ${response.data}');

          log.infoWithContext(
            'API Response received',
            {
              'request_id': requestId,
              'path': response.requestOptions.path,
              'status_code': response.statusCode,
              'duration_ms': duration,
              'has_data': response.data != null,
            },
          );

          return handler.next(response);
        },
        onError: (error, handler) async {
          final requestId = error.requestOptions.extra['request_id'];
          final startTime =
              error.requestOptions.extra['start_time'] as DateTime?;
          final duration = startTime != null
              ? DateTime.now().difference(startTime).inMilliseconds
              : 0;

          // Log error
          print(
              '❌ API Error [${error.response?.statusCode}] ${error.requestOptions.path}');
          print('⚠️ Error Type: ${error.type}');
          if (error.response?.data != null) {
            print('📥 Error Response Data: ${error.response?.data}');
          }

          log.errorWithContext(
            'API Error occurred',
            {
              'request_id': requestId,
              'path': error.requestOptions.path,
              'status_code': error.response?.statusCode,
              'error_type': error.type.toString(),
              'duration_ms': duration,
              'response_data': error.response?.data,
            },
            error,
            error.stackTrace,
          );

          // Handle unauthorized response (401)
          // Note: This API uses single token without refresh capability
          // User needs to re-authenticate when token expires
          if (error.response?.statusCode == 401) {
            log.warnWithContext(
              'Unauthorized response - token may be expired',
              {'request_id': requestId},
            );
            // Clear token to force re-authentication
            await _secureStore.clearToken();
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to app exceptions
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data) ??
            error.response?.statusMessage ??
            'Request failed';

        print(
            'API error response: ${error.response?.data}'); // Debug log for response data

        switch (statusCode) {
          case 400:
          case 422:
            return BadRequestException(message, statusCode);
          case 401:
            return AuthException(
                'Unauthorized. Please login again.', statusCode);
          case 403:
            return AuthException('Access forbidden.', statusCode);
          case 404:
            return NotFoundException('Resource not found.', statusCode);
          case 500:
          case 502:
          case 503:
            return ServerException(message, statusCode);
          default:
            return GeneralException(message, statusCode);
        }

      case DioExceptionType.cancel:
        return const GeneralException('Request cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      case DioExceptionType.badCertificate:
        return const GeneralException('Invalid certificate');

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkException('No internet connection');
        }
        return GeneralException(
            error.message ?? 'An unexpected error occurred');
    }
  }

  /// Pulls a user-facing message from API error bodies.
  /// Prefer field-level `data.errors` when present (Laravel validation).
  String? _extractErrorMessage(dynamic data) {
    if (data is! Map) return null;

    final errors = data['data'] is Map
        ? (data['data'] as Map)['errors']
        : data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final messages = <String>[];
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          messages.add(value.first.toString());
        } else if (value != null) {
          messages.add(value.toString());
        }
      }
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    return null;
  }
}
