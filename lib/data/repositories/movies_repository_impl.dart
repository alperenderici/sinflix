import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies/movies_remote_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getMovies({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getMovies(
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} movies from page $page');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails({
    required String movieId,
  }) async {
    try {
      final movieModel = await remoteDataSource.getMovieDetails(movieId: movieId);
      
      AppLogger.info('Retrieved movie details for: ${movieModel.title}');
      return Right(movieModel.toEntity());
    } on NotFoundException catch (e) {
      AppLogger.error('Movie not found: $movieId', e);
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting movie details', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting movie details', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting movie details', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.searchMovies(
        query: query,
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Found ${movies.length} movies for query: $query');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error searching movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error searching movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error searching movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getPopularMovies(
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} popular movies');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting popular movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting popular movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting popular movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getTopRatedMovies(
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} top rated movies');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting top rated movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting top rated movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting top rated movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getUpcomingMovies(
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} upcoming movies');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting upcoming movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting upcoming movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting upcoming movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getNowPlayingMovies(
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} now playing movies');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting now playing movies', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting now playing movies', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting now playing movies', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre({
    required String genreId,
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final movieModels = await remoteDataSource.getMoviesByGenre(
        genreId: genreId,
        page: page,
        limit: limit,
      );
      
      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} movies for genre: $genreId');
      return Right(movies);
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting movies by genre', e);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting movies by genre', e);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting movies by genre', e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
