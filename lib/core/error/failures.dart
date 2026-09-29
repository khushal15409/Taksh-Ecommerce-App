import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-related failures (5xx errors)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Network/connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Validation failures (invalid input)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Authentication failures (401, 403)
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Resource not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// General/unknown failures
class GeneralFailure extends Failure {
  const GeneralFailure([super.message = 'An unexpected error occurred']);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Bad request failures (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure([super.message = 'Bad request']);
}
