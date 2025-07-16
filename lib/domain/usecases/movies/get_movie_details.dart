import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movies_repository.dart';

class GetMovieDetails implements UseCase<Movie, GetMovieDetailsParams> {
  final MoviesRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, Movie>> call(GetMovieDetailsParams params) async {
    return await repository.getMovieDetails(movieId: params.movieId);
  }
}

class GetMovieDetailsParams extends Equatable {
  final String movieId;

  const GetMovieDetailsParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
