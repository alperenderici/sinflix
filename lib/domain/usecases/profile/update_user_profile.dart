import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/profile_repository.dart';

class UpdateUserProfile implements UseCase<User, UpdateUserProfileParams> {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
      name: params.name,
      profilePictureUrl: params.profilePictureUrl,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String? name;
  final String? profilePictureUrl;

  const UpdateUserProfileParams({
    this.name,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [name, profilePictureUrl];
}
