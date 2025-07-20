import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/profile_repository.dart';

class GetUserProfile implements UseCaseNoParams<User> {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call() async {
    return await repository.getUserProfile();
  }
}
