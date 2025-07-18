import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies({int page = 1});
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> toggleFavorite(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final DioClient _dioClient;

  MovieRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MovieModel>> getMovies({int page = 1}) async {
    try {
      AppLogger.debug('Fetching movies for page: $page');
      
      final response = await _dioClient.get(
        ApiEndpoints.movieList,
        queryParameters: {'page': page},
      );

      final List<dynamic> moviesJson = response.data['movies'] ?? [];
      final movies = moviesJson
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.debug('Fetched ${movies.length} movies');
      return movies;
    } catch (e) {
      AppLogger.error('Error fetching movies: $e');
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      AppLogger.debug('Fetching favorite movies');
      
      final response = await _dioClient.get(ApiEndpoints.favorites);

      final List<dynamic> moviesJson = response.data['movies'] ?? [];
      final movies = moviesJson
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();

      AppLogger.debug('Fetched ${movies.length} favorite movies');
      return movies;
    } catch (e) {
      AppLogger.error('Error fetching favorite movies: $e');
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      AppLogger.debug('Toggling favorite for movie: $movieId');
      
      final response = await _dioClient.post(
        ApiEndpoints.toggleFavorite(movieId),
      );

      final success = response.data['success'] ?? false;
      AppLogger.debug('Toggle favorite result: $success');
      
      return success;
    } catch (e) {
      AppLogger.error('Error toggling favorite: $e');
      rethrow;
    }
  }
}
