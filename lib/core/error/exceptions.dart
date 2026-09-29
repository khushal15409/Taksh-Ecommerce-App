/// Base class for all exceptions in the data layer
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'AppException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Server-related exceptions (5xx errors)
class ServerException extends AppException {
  const ServerException(
      [super.message = 'Server error occurred', super.statusCode]);
}

/// Network/connectivity exceptions
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Cache/local storage exceptions
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Validation exceptions (invalid input)
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed']);
}

/// Authentication exceptions (401, 403)
class AuthException extends AppException {
  const AuthException(
      [super.message = 'Authentication failed', super.statusCode]);
}

/// Resource not found exceptions (404)
class NotFoundException extends AppException {
  const NotFoundException(
      [super.message = 'Resource not found', super.statusCode]);
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timeout']);
}

/// Bad request exceptions (400)
class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Bad request', super.statusCode]);
}

/// General/unknown exceptions
class GeneralException extends AppException {
  const GeneralException(
      [super.message = 'An unexpected error occurred', super.statusCode]);
}
