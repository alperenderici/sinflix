import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getUserProfile();

  Future<Either<Failure, User>> updateUserProfile({
    String? name,
    String? profilePictureUrl,
  });

  Future<Either<Failure, String>> uploadProfilePicture({
    required String filePath,
  });

  Future<Either<Failure, List<Movie>>> getFavoriteMovies({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, void>> addToFavorites({
    required String movieId,
  });

  Future<Either<Failure, void>> removeFromFavorites({
    required String movieId,
  });

  Future<Either<Failure, bool>> isMovieFavorite({
    required String movieId,
  });

  Future<Either<Failure, void>> clearFavorites();
}
