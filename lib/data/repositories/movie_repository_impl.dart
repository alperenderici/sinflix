import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getMovies({int page = 1}) async {
    try {
      AppLogger.debug('Getting movies from repository, page: $page');
      
      final movieModels = await _remoteDataSource.getMovies(page: page);
      final movies = movieModels.map((model) => model.toEntity()).toList();
      
      AppLogger.debug('Successfully retrieved ${movies.length} movies');
      return Right(movies);
    } catch (e) {
      AppLogger.error('Error getting movies: $e');
      return Left(ServerFailure('Failed to fetch movies: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      AppLogger.debug('Getting favorite movies from repository');
      
      final movieModels = await _remoteDataSource.getFavoriteMovies();
      final movies = movieModels.map((model) => model.toEntity()).toList();
      
      AppLogger.debug('Successfully retrieved ${movies.length} favorite movies');
      return Right(movies);
    } catch (e) {
      AppLogger.error('Error getting favorite movies: $e');
      return Left(ServerFailure('Failed to fetch favorite movies: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String movieId) async {
    try {
      AppLogger.debug('Toggling favorite for movie: $movieId');
      
      final success = await _remoteDataSource.toggleFavorite(movieId);
      
      AppLogger.debug('Successfully toggled favorite: $success');
      return Right(success);
    } catch (e) {
      AppLogger.error('Error toggling favorite: $e');
      return Left(ServerFailure('Failed to toggle favorite: ${e.toString()}'));
    }
  }
}
