import '../../../core/network/dio_client.dart';
import '../../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies({
    int page = 1,
    int limit = 5,
  });

  Future<MovieModel> getMovieDetails({
    required String movieId,
  });

  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
    int limit = 5,
  });

  Future<List<MovieModel>> getPopularMovies({
    int page = 1,
    int limit = 5,
  });

  Future<List<MovieModel>> getTopRatedMovies({
    int page = 1,
    int limit = 5,
  });

  Future<List<MovieModel>> getUpcomingMovies({
    int page = 1,
    int limit = 5,
  });

  Future<List<MovieModel>> getNowPlayingMovies({
    int page = 1,
    int limit = 5,
  });

  Future<List<MovieModel>> getMoviesByGenre({
    required String genreId,
    int page = 1,
    int limit = 5,
  });
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final DioClient dioClient;

  MoviesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MovieModel>> getMovies({
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<MovieModel> getMovieDetails({
    required String movieId,
  }) async {
    final response = await dioClient.get('/movies/$movieId');
    return MovieModel.fromJson(response.data);
  }

  @override
  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/search',
      queryParameters: {
        'query': query,
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getPopularMovies({
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/popular',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/top-rated',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies({
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/upcoming',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies({
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/now-playing',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre({
    required String genreId,
    int page = 1,
    int limit = 5,
  }) async {
    final response = await dioClient.get(
      '/movies/genre/$genreId',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> moviesJson = response.data['results'] ?? response.data;
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }
}
