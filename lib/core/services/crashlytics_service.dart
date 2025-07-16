import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Initialize Crashlytics
  static Future<void> initialize() async {
    try {
      // Set up automatic crash reporting
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // Handle errors outside of Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      AppLogger.info('Crashlytics: Initialized successfully');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to initialize', e);
    }
  }

  // User Information
  static Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      AppLogger.info('Crashlytics: User ID set to $userId');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to set user ID', e);
    }
  }

  static Future<void> setCustomKey({
    required String key,
    required Object value,
  }) async {
    try {
      await _crashlytics.setCustomKey(key, value);
      AppLogger.info('Crashlytics: Custom key set - $key: $value');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to set custom key', e);
    }
  }

  // Error Reporting
  static Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Iterable<Object> information = const [],
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
        information: information,
      );
      AppLogger.info('Crashlytics: Error recorded - $exception');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to record error', e);
    }
  }

  static Future<void> recordFlutterError(
    FlutterErrorDetails errorDetails,
  ) async {
    try {
      await _crashlytics.recordFlutterError(errorDetails);
      AppLogger.info('Crashlytics: Flutter error recorded');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to record Flutter error', e);
    }
  }

  // Logging
  static Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      AppLogger.debug('Crashlytics: Log recorded - $message');
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to log message', e);
    }
  }

  // Test Crash (for testing purposes only)
  static void testCrash() {
    try {
      _crashlytics.crash();
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to trigger test crash', e);
    }
  }

  // Check if crash reporting is enabled
  static Future<bool> isCrashlyticsCollectionEnabled() async {
    try {
      return _crashlytics.isCrashlyticsCollectionEnabled;
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to check collection status', e);
      return false;
    }
  }

  // Enable/Disable crash reporting
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      AppLogger.info(
        'Crashlytics: Collection ${enabled ? 'enabled' : 'disabled'}',
      );
    } catch (e) {
      AppLogger.error('Crashlytics: Failed to set collection status', e);
    }
  }

  // App-specific error handlers
  static Future<void> recordAuthError({
    required String operation,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey(key: 'auth_operation', value: operation);
    await recordError(
      exception: error,
      stackTrace: stackTrace,
      reason: 'Authentication Error: $operation',
      fatal: false,
    );
  }

  static Future<void> recordNetworkError({
    required String endpoint,
    required int statusCode,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey(key: 'network_endpoint', value: endpoint);
    await setCustomKey(key: 'status_code', value: statusCode);
    await recordError(
      exception: error,
      stackTrace: stackTrace,
      reason: 'Network Error: $endpoint (Status: $statusCode)',
      fatal: false,
    );
  }

  static Future<void> recordMovieError({
    required String operation,
    String? movieId,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    await setCustomKey(key: 'movie_operation', value: operation);
    if (movieId != null) {
      await setCustomKey(key: 'movie_id', value: movieId);
    }
    await recordError(
      exception: error,
      stackTrace: stackTrace,
      reason: 'Movie Error: $operation',
      fatal: false,
    );
  }
}
