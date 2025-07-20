import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/movie_model.dart';
import '../../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();

  Future<UserModel> updateUserProfile({
    String? name,
    String? profilePictureUrl,
  });

  Future<String> uploadProfilePicture({required String filePath});

  Future<List<MovieModel>> getFavoriteMovies({int page = 1, int limit = 10});

  Future<void> addToFavorites({required String movieId});

  Future<void> removeFromFavorites({required String movieId});

  Future<bool> isMovieFavorite({required String movieId});

  Future<void> clearFavorites();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUserProfile() async {
    final response = await dioClient.get('/user/profile');

    // API response yapısı: { "response": {...}, "data": {...} }
    final data = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data);
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
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      // Validate file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw ValidationException('File does not exist: $filePath');
      }

      // Check file size (max 2MB after compression)
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        throw ValidationException(
          'File too large: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );
      }

      AppLogger.info(
        'Uploading profile picture: ${(fileSize / 1024).toStringAsFixed(2)} KB',
      );

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await dioClient.post(
        '/user/upload_photo',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 60), // 60 seconds timeout
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      AppLogger.info('Profile picture upload response: ${response.statusCode}');

      // API response: { "response": {...}, "data": { "photoUrl": "string" } }
      final data = response.data['data'];
      if (data == null) {
        throw ServerException('Invalid response: data is null');
      }

      final photoUrl = data['photoUrl'] as String?;
      if (photoUrl == null || photoUrl.isEmpty) {
        throw ServerException('Invalid response: photoUrl is null or empty');
      }

      return photoUrl;
    } on DioException catch (e) {
      AppLogger.error('Dio error uploading profile picture: ${e.message}');

      if (e.response?.statusCode == 413) {
        throw ValidationException(
          'File too large for server. Please compress more.',
        );
      } else if (e.response?.statusCode == 400) {
        throw ValidationException(
          'Invalid file format. Please use JPG, PNG, or WebP.',
        );
      } else if (e.response?.statusCode == 401) {
        throw AuthenticationException('Authentication required');
      } else if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Upload timeout. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('Connection error. Please check your internet.');
      } else {
        throw ServerException('Upload failed: ${e.message}');
      }
    } catch (e) {
      AppLogger.error('Unknown error uploading profile picture: $e');
      throw ServerException('Upload failed: $e');
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dioClient.get('/movie/favorites');

    // API response yapısı: { "response": {...}, "data": [...] }
    final List<dynamic> moviesJson = response.data['data'] ?? [];
    return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<void> addToFavorites({required String movieId}) async {
    await dioClient.post('/movie/favorite/$movieId');
  }

  @override
  Future<void> removeFromFavorites({required String movieId}) async {
    await dioClient.post('/movie/favorite/$movieId'); // Same endpoint toggles
  }

  @override
  Future<bool> isMovieFavorite({required String movieId}) async {
    final response = await dioClient.get('/profile/favorites/$movieId/check');
    return response.data['is_favorite'] ?? false;
  }

  @override
  Future<void> clearFavorites() async {
    await dioClient.delete('/profile/favorites');
  }
}
