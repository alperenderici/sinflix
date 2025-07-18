import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../models/auth/register_response.dart';
import '../../models/user_model.dart';

/// Auth işlemleri için remote data source interface
abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(String name, String email, String password);
  Future<UserModel> getCurrentUser();
  Future<void> logout();

  // Additional methods (to be implemented later)
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

/// Auth remote data source implementasyonu
/// API çağrılarını gerçekleştirir
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      AppLogger.debug('Attempting login for: ${request.email}');

      // API endpoint: /user/login (POST)
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      AppLogger.debug('Login response received');

      // Response'u LoginResponse'e çevir (API token ve user döndürüyor)
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Login failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected login error', e);
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      AppLogger.debug('Attempting registration for: $email');

      final response = await _dioClient.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      AppLogger.debug('Registration response received');

      // Response'u RegisterResponse'e çevir (API data wrapper'ı içinde döndürüyor)
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Registration failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected registration error', e);
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      AppLogger.debug('Getting current user');

      final response = await _dioClient.get(ApiEndpoints.profile);

      AppLogger.debug('Current user response received');
      // API response yapısı: { "response": {...}, "data": { "id": "...", "name": "...", "email": "...", "photoUrl": "..." } }
      final data = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.error('Get current user failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected get current user error', e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.debug('Attempting logout');

      await _dioClient.post('/user/logout');

      AppLogger.debug('Logout successful');
    } on DioException catch (e) {
      AppLogger.error('Logout failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected logout error', e);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      AppLogger.debug('Attempting forgot password for: $email');

      // TODO: Implement forgot password API call
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.info('Forgot password request sent for: $email');
    } catch (e) {
      AppLogger.error('Forgot password failed', e);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      AppLogger.debug('Attempting password reset');

      // TODO: Implement reset password API call
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.info('Password reset successfully');
    } catch (e) {
      AppLogger.error('Password reset failed', e);
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      AppLogger.debug('Attempting password change');

      // TODO: Implement change password API call
      await Future.delayed(const Duration(seconds: 1));

      AppLogger.info('Password changed successfully');
    } catch (e) {
      AppLogger.error('Password change failed', e);
      rethrow;
    }
  }

  /// Dio exception'larını handle eder
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Bağlantı zaman aşımına uğradı');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Bilinmeyen hata';

        switch (statusCode) {
          case 400:
            return Exception('Geçersiz istek: $message');
          case 401:
            return Exception('Email veya şifre hatalı');
          case 403:
            return Exception('Bu işlem için yetkiniz yok');
          case 404:
            return Exception('Kullanıcı bulunamadı');
          case 422:
            return Exception('Girilen bilgiler geçersiz');
          case 500:
            return Exception('Sunucu hatası');
          default:
            return Exception('Hata: $message');
        }
      case DioExceptionType.cancel:
        return Exception('İstek iptal edildi');
      case DioExceptionType.connectionError:
        return Exception('İnternet bağlantınızı kontrol edin');
      default:
        return Exception('Beklenmeyen bir hata oluştu');
    }
  }
}
