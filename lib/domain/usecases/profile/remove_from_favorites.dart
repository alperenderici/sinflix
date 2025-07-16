import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/profile_repository.dart';

class RemoveFromFavorites implements UseCase<void, RemoveFromFavoritesParams> {
  final ProfileRepository repository;

  RemoveFromFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromFavoritesParams params) async {
    return await repository.removeFromFavorites(movieId: params.movieId);
  }
}

class RemoveFromFavoritesParams extends Equatable {
  final String movieId;

  const RemoveFromFavoritesParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
