import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
  Future<Either<Failure, bool>> toggleFavorite(String movieId);
}
