import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/profile_repository.dart';

class AddToFavorites implements UseCase<void, AddToFavoritesParams> {
  final ProfileRepository repository;

  AddToFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToFavoritesParams params) async {
    return await repository.addToFavorites(movieId: params.movieId);
  }
}

class AddToFavoritesParams extends Equatable {
  final String movieId;

  const AddToFavoritesParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
