import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';
import '../utils/secure_storage_manager.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient(Dio dio) {
    _dio = dio;
    _dio
      ..options.baseUrl = AppConstants.apiUrl
      ..options.connectTimeout = AppConstants.connectTimeout
      ..options.receiveTimeout = AppConstants.receiveTimeout
      ..options.sendTimeout = AppConstants.sendTimeout
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException(message: 'Request timeout');
        case DioExceptionType.connectionError:
          return const NetworkException(message: 'Network connection error');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 'Server error';
          
          if (statusCode == 401) {
            return AuthenticationException(message: message);
          } else if (statusCode == 403) {
            return AuthorizationException(message: message);
          } else if (statusCode == 404) {
            return NotFoundException(message: message);
          } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
            return ValidationException(message: message);
          } else {
            return ServerException(message: message, statusCode: statusCode);
          }
        case DioExceptionType.cancel:
          return const UnknownException(message: 'Request cancelled');
        case DioExceptionType.unknown:
          return UnknownException(message: error.message ?? 'Unknown error');
        default:
          return UnknownException(message: error.message ?? 'Unknown error');
      }
    }
    return UnknownException(message: error.toString());
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshToken = await SecureStorageManager.getRefreshToken();
      if (refreshToken != null) {
        // TODO: Implement token refresh logic
        AppLogger.warning('Token expired, refresh logic needed');
      } else {
        // No refresh token, clear auth data
        await SecureStorageManager.clearAuthData();
      }
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
    AppLogger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      AppLogger.debug('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    AppLogger.debug('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    AppLogger.error('Message: ${err.message}');
    if (err.response?.data != null) {
      AppLogger.error('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Global error handling can be added here
    handler.next(err);
  }
}
