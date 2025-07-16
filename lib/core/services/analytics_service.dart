import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/app_logger.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  static FirebaseAnalyticsObserver get observer => _observer;

  // User Events
  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      AppLogger.info('Analytics: User ID set to $userId');
    } catch (e) {
      AppLogger.error('Analytics: Failed to set user ID', e);
    }
  }

  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      AppLogger.info('Analytics: User property set - $name: $value');
    } catch (e) {
      AppLogger.error('Analytics: Failed to set user property', e);
    }
  }

  // Authentication Events
  static Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      AppLogger.info('Analytics: Login event logged');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log login event', e);
    }
  }

  static Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method ?? 'email');
      AppLogger.info('Analytics: Sign up event logged');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log sign up event', e);
    }
  }

  // Movie Events
  static Future<void> logMovieView({
    required String movieId,
    required String movieTitle,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'movie_view',
        parameters: {'movie_id': movieId, 'movie_title': movieTitle},
      );
      AppLogger.info('Analytics: Movie view logged - $movieTitle');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log movie view', e);
    }
  }

  static Future<void> logMovieSearch({
    required String searchTerm,
    int? resultCount,
  }) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
      if (resultCount != null) {
        await _analytics.logEvent(
          name: 'search_results',
          parameters: {'search_term': searchTerm, 'result_count': resultCount},
        );
      }
      AppLogger.info('Analytics: Movie search logged - $searchTerm');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log movie search', e);
    }
  }

  static Future<void> logAddToFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'add_to_favorites',
        parameters: {'movie_id': movieId, 'movie_title': movieTitle},
      );
      AppLogger.info('Analytics: Add to favorites logged - $movieTitle');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log add to favorites', e);
    }
  }

  static Future<void> logRemoveFromFavorites({
    required String movieId,
    required String movieTitle,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'remove_from_favorites',
        parameters: {'movie_id': movieId, 'movie_title': movieTitle},
      );
      AppLogger.info('Analytics: Remove from favorites logged - $movieTitle');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log remove from favorites', e);
    }
  }

  // Screen Events
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      AppLogger.info('Analytics: Screen view logged - $screenName');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log screen view', e);
    }
  }

  // Custom Events
  static Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: eventName, parameters: parameters);
      AppLogger.info('Analytics: Custom event logged - $eventName');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log custom event', e);
    }
  }

  // App Events
  static Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      AppLogger.info('Analytics: App open logged');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log app open', e);
    }
  }

  // Error Events
  static Future<void> logError({
    required String errorMessage,
    String? errorCode,
    String? stackTrace,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'app_error',
        parameters: {
          'error_message': errorMessage,
          if (errorCode != null) 'error_code': errorCode,
          if (stackTrace != null) 'stack_trace': stackTrace,
        },
      );
      AppLogger.info('Analytics: Error logged - $errorMessage');
    } catch (e) {
      AppLogger.error('Analytics: Failed to log error event', e);
    }
  }
}
