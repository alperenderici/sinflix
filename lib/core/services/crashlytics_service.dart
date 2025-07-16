// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Mock Crashlytics Service - Firebase temporarily disabled
class CrashlyticsService {
  // Initialize Crashlytics (Mock)
  static Future<void> initialize() async {
    AppLogger.info('Crashlytics (Mock): Initialized');
  }

  // Enable/Disable Crashlytics Collection (Mock)
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    AppLogger.info('Crashlytics (Mock): Collection enabled: $enabled');
  }

  // Check if collection is enabled (Mock)
  static Future<bool> isCrashlyticsCollectionEnabled() async {
    AppLogger.info('Crashlytics (Mock): Collection status checked');
    return !kDebugMode;
  }

  // User Identification (Mock)
  static Future<void> setUserId(String userId) async {
    AppLogger.info('Crashlytics (Mock): User ID set to $userId');
  }

  static Future<void> setCustomKey({
    required String key,
    required dynamic value,
  }) async {
    AppLogger.info('Crashlytics (Mock): Custom key set - $key: $value');
  }

  // Error Recording (Mock)
  static Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    AppLogger.error(
      'Crashlytics (Mock): Error recorded - $exception',
      exception,
    );
  }

  static Future<void> recordAuthError({
    required String operation,
    required dynamic error,
    StackTrace? stackTrace,
  }) async {
    AppLogger.error(
      'Crashlytics (Mock): Auth error recorded - $operation: $error',
      error,
    );
  }

  static Future<void> recordNetworkError({
    required String url,
    required int statusCode,
    required String method,
    dynamic error,
  }) async {
    AppLogger.error(
      'Crashlytics (Mock): Network error recorded - $method $url ($statusCode)',
      error,
    );
  }

  static Future<void> recordMovieError({
    required String movieId,
    required String operation,
    required dynamic error,
  }) async {
    AppLogger.error(
      'Crashlytics (Mock): Movie error recorded - $operation for $movieId: $error',
      error,
    );
  }

  // Log Messages (Mock)
  static Future<void> log(String message) async {
    AppLogger.info('Crashlytics (Mock): Log - $message');
  }

  // Test Crash (Mock - only in debug mode)
  static void testCrash() {
    if (kDebugMode) {
      AppLogger.warning(
        'Crashlytics (Mock): Test crash called (not executed in mock)',
      );
    }
  }
}
