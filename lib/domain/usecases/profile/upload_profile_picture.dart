import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/profile_repository.dart';

class UploadProfilePicture implements UseCase<String, UploadProfilePictureParams> {
  final ProfileRepository repository;

  UploadProfilePicture(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfilePictureParams params) async {
    return await repository.uploadProfilePicture(filePath: params.filePath);
  }
}

class UploadProfilePictureParams extends Equatable {
  final String filePath;

  const UploadProfilePictureParams({required this.filePath});

  @override
  List<Object> get props => [filePath];
}
