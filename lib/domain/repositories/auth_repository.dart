import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> refreshToken();

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> isLoggedIn();
}
