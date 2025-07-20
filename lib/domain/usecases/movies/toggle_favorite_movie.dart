import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/movies_repository.dart';

class ToggleFavoriteMovie implements UseCase<Map<String, dynamic>, ToggleFavoriteMovieParams> {
  final MoviesRepository repository;

  ToggleFavoriteMovie(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(ToggleFavoriteMovieParams params) async {
    return await repository.toggleFavorite(movieId: params.movieId);
  }
}

class ToggleFavoriteMovieParams extends Equatable {
  final String movieId;

  const ToggleFavoriteMovieParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
