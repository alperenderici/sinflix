import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/crashlytics_service.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/secure_storage_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_remote_data_source.dart';
import '../models/auth/login_request.dart';

import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.debug('Repository: Attempting login for $email');

      // LoginRequest oluştur
      final loginRequest = LoginRequest(email: email, password: password);

      // API çağrısı yap - LoginResponse döndürüyor (token + user)
      final loginResponse = await remoteDataSource.login(loginRequest);

      // Token'ı güvenli storage'a kaydet
      await SecureStorageManager.saveAccessToken(loginResponse.token);

      // Kullanıcı bilgilerini güvenli storage'a kaydet
      await SecureStorageManager.saveUserId(loginResponse.user.id);
      await SecureStorageManager.saveUserEmail(loginResponse.user.email);

      // Analytics: Login event'i logla
      await AnalyticsService.logLogin(method: 'email');
      await AnalyticsService.setUserId(loginResponse.user.id);

      // Crashlytics: Kullanıcı bilgilerini set et
      await CrashlyticsService.setUserId(loginResponse.user.id);
      await CrashlyticsService.setCustomKey(key: 'user_email', value: email);

      AppLogger.info('User logged in successfully: $email');

      // User entity'sini döndür
      return Right(loginResponse.user.toEntity());
    } catch (e) {
      AppLogger.error('Login failed', e);

      // Crashlytics: Auth error'u logla
      await CrashlyticsService.recordAuthError(
        operation: 'login',
        error: e,
        stackTrace: StackTrace.current,
      );

      // Exception tipine göre failure döndür
      if (e.toString().contains('401') ||
          e.toString().contains('Email veya şifre hatalı')) {
        return Left(AuthFailure('Email veya şifre hatalı'));
      } else if (e.toString().contains('İnternet bağlantınızı kontrol edin')) {
        return Left(NetworkFailure('İnternet bağlantınızı kontrol edin'));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final registerResponse = await remoteDataSource.register(
        name ?? '',
        email,
        password,
      );

      // Token'ı güvenli storage'a kaydet
      await SecureStorageManager.saveAccessToken(registerResponse.token);

      // User bilgilerini kaydet
      await SecureStorageManager.saveUserId(registerResponse.user.id);
      await SecureStorageManager.saveUserEmail(registerResponse.user.email);

      // Analytics: Register event'i logla
      await AnalyticsService.logSignUp(method: 'email');
      await AnalyticsService.setUserId(registerResponse.user.id);

      // Crashlytics: Kullanıcı bilgilerini set et
      await CrashlyticsService.setUserId(registerResponse.user.id);
      await CrashlyticsService.setCustomKey(key: 'user_email', value: email);

      AppLogger.info(
        'User registered successfully: ${registerResponse.user.email}',
      );

      return Right(registerResponse.user.toEntity());
    } on ValidationException catch (e) {
      AppLogger.error('Validation error during registration', e);
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error during registration', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error during registration', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error during registration', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await SecureStorageManager.clearAuthData();

      AppLogger.info('User logged out successfully');
      return const Right(null);
    } on NetworkException catch (e) {
      AppLogger.error('Network error during logout', e);
      // Still clear local data even if network call fails
      await SecureStorageManager.clearAuthData();
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error during logout', e);
      // Still clear local data even if network call fails
      await SecureStorageManager.clearAuthData();
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error during logout', e);
      // Still clear local data even if network call fails
      await SecureStorageManager.clearAuthData();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      AppLogger.debug('Current user retrieved: ${userModel.email}');
      return Right(userModel.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error getting current user', e);
      await SecureStorageManager.clearAuthData();
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting current user', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting current user', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting current user', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      final refreshToken = await SecureStorageManager.getRefreshToken();
      if (refreshToken == null) {
        return const Left(
          AuthFailure('No refresh token found'),
        );
      }

      // TODO: Implement refresh token API call
      AppLogger.info('Refresh token not implemented yet');
      return const Left(
        ServerFailure('Refresh token not implemented'),
      );
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error refreshing token', e);
      await SecureStorageManager.clearAuthData();
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error refreshing token', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error refreshing token', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error refreshing token', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      AppLogger.info('Password reset email sent to: $email');
      return const Right(null);
    } on ValidationException catch (e) {
      AppLogger.error('Validation error sending password reset', e);
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error sending password reset', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error sending password reset', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error sending password reset', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      AppLogger.info('Password reset successfully');
      return const Right(null);
    } on ValidationException catch (e) {
      AppLogger.error('Validation error resetting password', e);
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error resetting password', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error resetting password', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error resetting password', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      AppLogger.info('Password changed successfully');
      return const Right(null);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error changing password', e);
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      AppLogger.error('Validation error changing password', e);
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error changing password', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error changing password', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error changing password', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await SecureStorageManager.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      AppLogger.error('Error checking login status', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
