import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/movie_repository.dart';

class ToggleFavorite implements UseCase<bool, ToggleFavoriteParams> {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.movieId);
  }
}

class ToggleFavoriteParams {
  final String movieId;

  ToggleFavoriteParams({required this.movieId});
}
