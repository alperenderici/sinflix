import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getMovies({int page = 1, int limit = 5});

  Future<Either<Failure, Movie>> getMovieDetails({required String movieId});

  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getPopularMovies({
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getTopRatedMovies({
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getUpcomingMovies({
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getMoviesByGenre({
    required String genreId,
    int page = 1,
    int limit = 5,
  });

  Future<Either<Failure, List<Movie>>> getFavoriteMovies();

  Future<Either<Failure, Map<String, dynamic>>> toggleFavorite({
    required String movieId,
  });
}
