import '../../../core/network/dio_client.dart';
import '../../models/movie_model.dart';
import '../../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();

  Future<UserModel> updateUserProfile({
    String? name,
    String? profilePictureUrl,
  });

  Future<String> uploadProfilePicture({
    required String filePath,
  });

  Future<List<MovieModel>> getFavoriteMovies({
    int page = 1,
    int limit = 10,
  });

  Future<void> addToFavorites({
    required String movieId,
  });

  Future<void> removeFromFavorites({
    required String movieId,
  });

  Future<bool> isMovieFavorite({
    required String movieId,
  });

  Future<void> clearFavorites();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUserProfile() async {
    final response = await dioClient.get('/profile');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateUserProfile({
    String? name,
    String? profilePictureUrl,
  }) async {
    final response = await dioClient.put(
      '/profile',
      data: {
        if (name != null) 'name': name,
        if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<String> uploadProfilePicture({
    required String filePath,
  }) async {
    // TODO: Implement file upload logic
    // This would typically use FormData for multipart upload
    final response = await dioClient.post(
      '/profile/upload-picture',
      data: {
        'file_path': filePath,
      },
    );
    return response.data['url'];
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get(
      '/profile/favorites',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<void> addToFavorites({
    required String movieId,
  }) async {
    await dioClient.post(
      '/profile/favorites',
      data: {
        'movie_id': movieId,
      },
    );
  }

  @override
  Future<void> removeFromFavorites({
    required String movieId,
  }) async {
    await dioClient.delete('/profile/favorites/$movieId');
  }

  @override
  Future<bool> isMovieFavorite({
    required String movieId,
  }) async {
    final response = await dioClient.get('/profile/favorites/$movieId/check');
    return response.data['is_favorite'] ?? false;
  }

  @override
  Future<void> clearFavorites() async {
    await dioClient.delete('/profile/favorites');
  }
}
