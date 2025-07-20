/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  const ServerException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when there's an authentication error
class AuthenticationException extends AppException {
  const AuthenticationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception thrown when there's a validation error
class ValidationException extends AppException {
  const ValidationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there's a parsing error
class ParsingException extends AppException {
  const ParsingException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'ParsingException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  const NotFoundException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when there's a permission error
class PermissionException extends AppException {
  const PermissionException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'PermissionException: $message';
}

/// Exception thrown when there's a timeout error
class TimeoutException extends AppException {
  const TimeoutException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);

  @override
  String toString() => 'TimeoutException: $message';
}
