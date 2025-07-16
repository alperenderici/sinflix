class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException({required this.message});

  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthorizationException implements Exception {
  final String message;

  const AuthorizationException({required this.message});

  @override
  String toString() => 'AuthorizationException: $message';
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException({required this.message});

  @override
  String toString() => 'NotFoundException: $message';
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException({required this.message});

  @override
  String toString() => 'TimeoutException: $message';
}

class UnknownException implements Exception {
  final String message;

  const UnknownException({required this.message});

  @override
  String toString() => 'UnknownException: $message';
}
