import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/secure_storage_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens to secure storage
      await SecureStorageManager.saveAccessToken(authResponse.accessToken);
      await SecureStorageManager.saveRefreshToken(authResponse.refreshToken);
      await SecureStorageManager.saveUserId(authResponse.user.id);
      await SecureStorageManager.saveUserEmail(authResponse.user.email);

      AppLogger.info('User logged in successfully: ${authResponse.user.email}');
      return Right(authResponse.user.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication failed', e);
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error during login', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error during login', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error during login', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final authResponse = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      // Save tokens to secure storage
      await SecureStorageManager.saveAccessToken(authResponse.accessToken);
      await SecureStorageManager.saveRefreshToken(authResponse.refreshToken);
      await SecureStorageManager.saveUserId(authResponse.user.id);
      await SecureStorageManager.saveUserEmail(authResponse.user.email);

      AppLogger.info('User registered successfully: ${authResponse.user.email}');
      return Right(authResponse.user.toEntity());
    } on ValidationException catch (e) {
      AppLogger.error('Validation error during registration', e);
      return Left(ValidationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error during registration', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error during registration', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error during registration', e);
      return Left(UnknownFailure(message: e.toString()));
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
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error during logout', e);
      // Still clear local data even if network call fails
      await SecureStorageManager.clearAuthData();
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error during logout', e);
      // Still clear local data even if network call fails
      await SecureStorageManager.clearAuthData();
      return Left(UnknownFailure(message: e.toString()));
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
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting current user', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting current user', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting current user', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      final refreshToken = await SecureStorageManager.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthenticationFailure(message: 'No refresh token found'));
      }

      final authResponse = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );

      // Update tokens in secure storage
      await SecureStorageManager.saveAccessToken(authResponse.accessToken);
      await SecureStorageManager.saveRefreshToken(authResponse.refreshToken);

      AppLogger.info('Token refreshed successfully');
      return Right(authResponse.user.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error refreshing token', e);
      await SecureStorageManager.clearAuthData();
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error refreshing token', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error refreshing token', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error refreshing token', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      AppLogger.info('Password reset email sent to: $email');
      return const Right(null);
    } on ValidationException catch (e) {
      AppLogger.error('Validation error sending password reset', e);
      return Left(ValidationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error sending password reset', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error sending password reset', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error sending password reset', e);
      return Left(UnknownFailure(message: e.toString()));
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
      return Left(ValidationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error resetting password', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error resetting password', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error resetting password', e);
      return Left(UnknownFailure(message: e.toString()));
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
      return Left(AuthenticationFailure(message: e.message));
    } on ValidationException catch (e) {
      AppLogger.error('Validation error changing password', e);
      return Left(ValidationFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error changing password', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error changing password', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error changing password', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await SecureStorageManager.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      AppLogger.error('Error checking login status', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
