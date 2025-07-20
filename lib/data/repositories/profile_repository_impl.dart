import 'package:dartz/dartz.dart';
import 'package:sinflix/data/models/user_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final userModel = await remoteDataSource.getUserProfile();
      AppLogger.info('Retrieved user profile: ${userModel.email}');
      return Right(userModel.toEntity());
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error getting user profile', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting user profile', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting user profile', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting user profile', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? profilePictureUrl,
  }) async {
    try {
      final userModel = await remoteDataSource.updateUserProfile(
        name: name,
        profilePictureUrl: profilePictureUrl,
      );
      AppLogger.info('Updated user profile: ${userModel.email}');
      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      AppLogger.error('Validation error updating user profile', e);
      return Left(ValidationFailure(e.message));
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error updating user profile', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error updating user profile', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error updating user profile', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error updating user profile', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture({
    required String filePath,
  }) async {
    try {
      final url = await remoteDataSource.uploadProfilePicture(
        filePath: filePath,
      );
      AppLogger.info('Uploaded profile picture: $url');
      return Right(url);
    } on ValidationException catch (e) {
      AppLogger.error('Validation error uploading profile picture', e);
      return Left(ValidationFailure(e.message));
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error uploading profile picture', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error uploading profile picture', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error uploading profile picture', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error uploading profile picture', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final movieModels = await remoteDataSource.getFavoriteMovies(
        page: page,
        limit: limit,
      );

      final movies = movieModels.map((model) => model.toEntity()).toList();
      AppLogger.info('Retrieved ${movies.length} favorite movies');
      return Right(movies);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error getting favorite movies', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error getting favorite movies', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error getting favorite movies', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error getting favorite movies', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites({
    required String movieId,
  }) async {
    try {
      await remoteDataSource.addToFavorites(movieId: movieId);
      AppLogger.info('Added movie to favorites: $movieId');
      return const Right(null);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error adding to favorites', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error adding to favorites', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error adding to favorites', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error adding to favorites', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites({
    required String movieId,
  }) async {
    try {
      await remoteDataSource.removeFromFavorites(movieId: movieId);
      AppLogger.info('Removed movie from favorites: $movieId');
      return const Right(null);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error removing from favorites', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error removing from favorites', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error removing from favorites', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error removing from favorites', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isMovieFavorite({
    required String movieId,
  }) async {
    try {
      final isFavorite = await remoteDataSource.isMovieFavorite(
        movieId: movieId,
      );
      AppLogger.debug('Movie $movieId favorite status: $isFavorite');
      return Right(isFavorite);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error checking favorite status', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error checking favorite status', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error checking favorite status', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error checking favorite status', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites() async {
    try {
      await remoteDataSource.clearFavorites();
      AppLogger.info('Cleared all favorites');
      return const Right(null);
    } on AuthenticationException catch (e) {
      AppLogger.error('Authentication error clearing favorites', e);
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      AppLogger.error('Network error clearing favorites', e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.error('Server error clearing favorites', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unknown error clearing favorites', e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
