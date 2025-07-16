import 'package:flutter/foundation.dart';
import 'analytics_service.dart';
import 'crashlytics_service.dart';
import '../utils/app_logger.dart';

class FirebaseTestService {
  /// Test Firebase Analytics functionality
  static Future<void> testAnalytics() async {
    try {
      AppLogger.info('🧪 Testing Firebase Analytics...');
      
      // Test basic events
      await AnalyticsService.logCustomEvent(
        eventName: 'test_analytics',
        parameters: {
          'test_type': 'functionality_check',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      // Test user properties
      await AnalyticsService.setUserProperty(
        name: 'test_user_type',
        value: 'developer',
      );
      
      // Test screen view
      await AnalyticsService.logScreenView(
        screenName: 'test_screen',
        screenClass: 'TestScreen',
      );
      
      // Test movie-specific events
      await AnalyticsService.logMovieView(
        movieId: 'test_movie_123',
        movieTitle: 'Test Movie',
      );
      
      await AnalyticsService.logMovieSearch(
        searchTerm: 'test search',
        resultCount: 5,
      );
      
      AppLogger.info('✅ Analytics test completed successfully');
    } catch (e) {
      AppLogger.error('❌ Analytics test failed', e);
      rethrow;
    }
  }
  
  /// Test Firebase Crashlytics functionality
  static Future<void> testCrashlytics() async {
    try {
      AppLogger.info('🧪 Testing Firebase Crashlytics...');
      
      // Test custom keys
      await CrashlyticsService.setCustomKey(
        key: 'test_environment',
        value: 'development',
      );
      
      await CrashlyticsService.setCustomKey(
        key: 'test_timestamp',
        value: DateTime.now().toIso8601String(),
      );
      
      // Test logging
      await CrashlyticsService.log('Test log message from FirebaseTestService');
      
      // Test non-fatal error recording
      await CrashlyticsService.recordError(
        exception: Exception('Test non-fatal error'),
        stackTrace: StackTrace.current,
        reason: 'Testing Crashlytics functionality',
        fatal: false,
      );
      
      // Test app-specific error handlers
      await CrashlyticsService.recordAuthError(
        operation: 'test_login',
        error: Exception('Test auth error'),
        stackTrace: StackTrace.current,
      );
      
      await CrashlyticsService.recordNetworkError(
        endpoint: '/test/endpoint',
        statusCode: 404,
        error: Exception('Test network error'),
        stackTrace: StackTrace.current,
      );
      
      await CrashlyticsService.recordMovieError(
        operation: 'test_movie_load',
        movieId: 'test_movie_123',
        error: Exception('Test movie error'),
        stackTrace: StackTrace.current,
      );
      
      // Check if collection is enabled
      final isEnabled = await CrashlyticsService.isCrashlyticsCollectionEnabled();
      AppLogger.info('Crashlytics collection enabled: $isEnabled');
      
      AppLogger.info('✅ Crashlytics test completed successfully');
    } catch (e) {
      AppLogger.error('❌ Crashlytics test failed', e);
      rethrow;
    }
  }
  
  /// Test both Analytics and Crashlytics
  static Future<void> testFirebaseServices() async {
    try {
      AppLogger.info('🚀 Starting Firebase services test...');
      
      await testAnalytics();
      await testCrashlytics();
      
      AppLogger.info('🎉 All Firebase services tests completed successfully!');
      AppLogger.info('📊 Check Firebase Console for Analytics events');
      AppLogger.info('🐛 Check Firebase Console for Crashlytics reports');
      
    } catch (e) {
      AppLogger.error('💥 Firebase services test failed', e);
      
      // Report this test failure to Crashlytics
      await CrashlyticsService.recordError(
        exception: e,
        stackTrace: StackTrace.current,
        reason: 'Firebase services test failed',
        fatal: false,
      );
      
      rethrow;
    }
  }
  
  /// Trigger a test crash (USE ONLY FOR TESTING!)
  static void triggerTestCrash() {
    if (kDebugMode) {
      AppLogger.info('⚠️ Triggering test crash...');
      CrashlyticsService.testCrash();
    } else {
      AppLogger.info('⚠️ Test crash only available in debug mode');
    }
  }
  
  /// Log a comprehensive test event with user simulation
  static Future<void> simulateUserSession() async {
    try {
      AppLogger.info('👤 Simulating user session...');
      
      // Simulate user login
      await AnalyticsService.logLogin(method: 'email');
      await AnalyticsService.setUserId('test_user_123');
      await AnalyticsService.setUserProperty(name: 'user_type', value: 'premium');
      
      // Simulate app usage
      await AnalyticsService.logScreenView(screenName: 'home', screenClass: 'HomePage');
      await AnalyticsService.logMovieSearch(searchTerm: 'action movies', resultCount: 15);
      await AnalyticsService.logMovieView(movieId: 'movie_456', movieTitle: 'Action Hero');
      await AnalyticsService.logAddToFavorites(movieId: 'movie_456', movieTitle: 'Action Hero');
      
      // Set Crashlytics user info
      await CrashlyticsService.setUserId('test_user_123');
      await CrashlyticsService.setCustomKey(key: 'user_type', value: 'premium');
      await CrashlyticsService.setCustomKey(key: 'session_id', value: 'session_${DateTime.now().millisecondsSinceEpoch}');
      
      AppLogger.info('✅ User session simulation completed');
      
    } catch (e) {
      AppLogger.error('❌ User session simulation failed', e);
      await CrashlyticsService.recordError(
        exception: e,
        stackTrace: StackTrace.current,
        reason: 'User session simulation failed',
        fatal: false,
      );
    }
  }
}
