// import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/app_logger.dart';

/// Mock Analytics Service - Firebase temporarily disabled
class AnalyticsService {
  // User Events (Mock implementation)
  static Future<void> setUserId(String userId) async {
    AppLogger.info('Analytics (Mock): User ID set to $userId');
  }

  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    AppLogger.info('Analytics (Mock): User property set - $name: $value');
  }

  // Authentication Events (Mock implementation)
  static Future<void> logLogin({String? method}) async {
    AppLogger.info('Analytics (Mock): Login event logged with method: $method');
  }

  static Future<void> logSignUp({String? method}) async {
    AppLogger.info(
      'Analytics (Mock): Sign up event logged with method: ${method ?? 'email'}',
    );
  }

  // Movie Events (Mock implementation)
  static Future<void> logMovieView({
    required String movieId,
    required String movieTitle,
  }) async {
    AppLogger.info('Analytics (Mock): Movie view event logged for $movieTitle');
  }

  static Future<void> logMovieSearch({
    required String searchTerm,
    int? resultCount,
  }) async {
    AppLogger.info(
      'Analytics (Mock): Search event logged for "$searchTerm" with $resultCount results',
    );
  }

  static Future<void> logAddToFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    AppLogger.info(
      'Analytics (Mock): Add to favorites event logged for $movieTitle',
    );
  }

  static Future<void> logRemoveFromFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    AppLogger.info(
      'Analytics (Mock): Remove from favorites event logged for $movieTitle',
    );
  }

  // Screen Events (Mock implementation)
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    AppLogger.info('Analytics (Mock): Screen view logged - $screenName');
  }

  // Custom Events (Mock implementation)
  static Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    AppLogger.info(
      'Analytics (Mock): Custom event logged - $eventName with parameters: $parameters',
    );
  }

  // Error Events (Mock implementation)
  static Future<void> logError({
    required String errorMessage,
    String? errorCode,
    String? stackTrace,
  }) async {
    AppLogger.info('Analytics (Mock): Error logged - $errorMessage');
  }

  // App Events (Mock implementation)
  static Future<void> logAppOpen() async {
    AppLogger.info('Analytics (Mock): App open event logged');
  }
}
