import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../constants/app_colors.dart';
import '../utils/app_logger.dart';

/// Service for managing image caching throughout the app
class ImageCacheService {
  static ImageCacheService? _instance;
  static ImageCacheService get instance => _instance ??= ImageCacheService._();
  
  ImageCacheService._();

  /// Custom cache manager for movie images
  static final CacheManager _movieImageCacheManager = CacheManager(
    Config(
      'movie_images',
      stalePeriod: const Duration(days: 7), // Cache for 7 days
      maxNrOfCacheObjects: 200, // Max 200 images
      repo: JsonCacheInfoRepository(databaseName: 'movie_images'),
      fileService: HttpFileService(),
    ),
  );

  /// Custom cache manager for profile images
  static final CacheManager _profileImageCacheManager = CacheManager(
    Config(
      'profile_images',
      stalePeriod: const Duration(days: 30), // Cache for 30 days
      maxNrOfCacheObjects: 50, // Max 50 profile images
      repo: JsonCacheInfoRepository(databaseName: 'profile_images'),
      fileService: HttpFileService(),
    ),
  );

  /// Clear all image caches
  static Future<void> clearAllCaches() async {
    try {
      AppLogger.info('Clearing all image caches...');
      await _movieImageCacheManager.emptyCache();
      await _profileImageCacheManager.emptyCache();
      await DefaultCacheManager().emptyCache();
      AppLogger.info('All image caches cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing image caches: $e');
    }
  }

  /// Clear only movie image cache
  static Future<void> clearMovieImageCache() async {
    try {
      AppLogger.info('Clearing movie image cache...');
      await _movieImageCacheManager.emptyCache();
      AppLogger.info('Movie image cache cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing movie image cache: $e');
    }
  }

  /// Clear only profile image cache
  static Future<void> clearProfileImageCache() async {
    try {
      AppLogger.info('Clearing profile image cache...');
      await _profileImageCacheManager.emptyCache();
      AppLogger.info('Profile image cache cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing profile image cache: $e');
    }
  }

  /// Get cache info for debugging
  static Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final movieCacheInfo = await _movieImageCacheManager.getFileFromCache('');
      final profileCacheInfo = await _profileImageCacheManager.getFileFromCache('');
      
      return {
        'movieCacheSize': movieCacheInfo?.file.lengthSync() ?? 0,
        'profileCacheSize': profileCacheInfo?.file.lengthSync() ?? 0,
      };
    } catch (e) {
      AppLogger.error('Error getting cache info: $e');
      return {};
    }
  }

  /// Build movie poster image widget with consistent styling
  static Widget buildMoviePosterImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Validate and clean URL
    final cleanUrl = _validateAndCleanUrl(imageUrl);
    if (cleanUrl.isEmpty) {
      return _buildErrorWidget(width, height, borderRadius);
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: cleanUrl,
      cacheManager: _movieImageCacheManager,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildPlaceholderWidget(width, height),
      errorWidget: (context, url, error) {
        AppLogger.warning('Failed to load movie image: $url, Error: $error');
        return errorWidget ?? _buildErrorWidget(width, height, borderRadius);
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Build profile image widget with consistent styling
  static Widget buildProfileImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Validate and clean URL
    final cleanUrl = _validateAndCleanUrl(imageUrl);
    if (cleanUrl.isEmpty) {
      return _buildProfileErrorWidget(width, height, borderRadius);
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: cleanUrl,
      cacheManager: _profileImageCacheManager,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildProfilePlaceholderWidget(width, height),
      errorWidget: (context, url, error) {
        AppLogger.warning('Failed to load profile image: $url, Error: $error');
        return errorWidget ?? _buildProfileErrorWidget(width, height, borderRadius);
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Validate and clean image URL
  static String _validateAndCleanUrl(String url) {
    if (url.isEmpty) return '';
    
    // Remove any whitespace
    url = url.trim();
    
    // Check if it's a valid URL
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return '';
    }
    
    return url;
  }

  /// Build consistent placeholder widget for movie images
  static Widget _buildPlaceholderWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  /// Build consistent error widget for movie images
  static Widget _buildErrorWidget(double? width, double? height, BorderRadius? borderRadius) {
    Widget errorWidget = Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 48,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );

    if (borderRadius != null) {
      errorWidget = ClipRRect(
        borderRadius: borderRadius,
        child: errorWidget,
      );
    }

    return errorWidget;
  }

  /// Build consistent placeholder widget for profile images
  static Widget _buildProfilePlaceholderWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade800,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  /// Build consistent error widget for profile images
  static Widget _buildProfileErrorWidget(double? width, double? height, BorderRadius? borderRadius) {
    Widget errorWidget = Container(
      width: width,
      height: height,
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.white54,
        ),
      ),
    );

    if (borderRadius != null) {
      errorWidget = ClipRRect(
        borderRadius: borderRadius,
        child: errorWidget,
      );
    }

    return errorWidget;
  }
}
