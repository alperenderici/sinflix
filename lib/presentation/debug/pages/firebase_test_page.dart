import 'package:flutter/material.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/crashlytics_service.dart';
import '../../../core/utils/app_logger.dart';

class FirebaseTestPage extends StatelessWidget {
  const FirebaseTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Analytics & Crashlytics Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Analytics Tests
            const Text(
              'Analytics Tests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _testAnalyticsLogin(),
              child: const Text('Test Login Event'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testAnalyticsMovieView(),
              child: const Text('Test Movie View Event'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testAnalyticsSearch(),
              child: const Text('Test Search Event'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testAnalyticsCustomEvent(),
              child: const Text('Test Custom Event'),
            ),
            const SizedBox(height: 32),
            
            // Crashlytics Tests
            const Text(
              'Crashlytics Tests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _testCrashlyticsError(),
              child: const Text('Test Error Logging'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testCrashlyticsCustomKeys(),
              child: const Text('Test Custom Keys'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testCrashlyticsUserInfo(),
              child: const Text('Test User Info'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () => _testCrashlyticsLog(),
              child: const Text('Test Log Message'),
            ),
            const SizedBox(height: 32),
            
            // Status Check
            ElevatedButton(
              onPressed: () => _checkFirebaseStatus(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Check Firebase Status'),
            ),
          ],
        ),
      ),
    );
  }

  // Analytics Test Functions
  Future<void> _testAnalyticsLogin() async {
    try {
      await AnalyticsService.logLogin(method: 'test');
      await AnalyticsService.setUserId('test_user_123');
      AppLogger.info('✅ Analytics Login test completed');
    } catch (e) {
      AppLogger.error('❌ Analytics Login test failed', e);
    }
  }

  Future<void> _testAnalyticsMovieView() async {
    try {
      await AnalyticsService.logMovieView(
        movieId: 'test_movie_123',
        movieTitle: 'Test Movie Title',
      );
      AppLogger.info('✅ Analytics Movie View test completed');
    } catch (e) {
      AppLogger.error('❌ Analytics Movie View test failed', e);
    }
  }

  Future<void> _testAnalyticsSearch() async {
    try {
      await AnalyticsService.logMovieSearch(
        searchTerm: 'test search',
        resultCount: 5,
      );
      AppLogger.info('✅ Analytics Search test completed');
    } catch (e) {
      AppLogger.error('❌ Analytics Search test failed', e);
    }
  }

  Future<void> _testAnalyticsCustomEvent() async {
    try {
      await AnalyticsService.logCustomEvent(
        eventName: 'test_custom_event',
        parameters: {
          'test_param': 'test_value',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      AppLogger.info('✅ Analytics Custom Event test completed');
    } catch (e) {
      AppLogger.error('❌ Analytics Custom Event test failed', e);
    }
  }

  // Crashlytics Test Functions
  Future<void> _testCrashlyticsError() async {
    try {
      await CrashlyticsService.recordError(
        exception: Exception('Test error for Crashlytics'),
        stackTrace: StackTrace.current,
        reason: 'Testing Crashlytics error reporting',
        fatal: false,
      );
      AppLogger.info('✅ Crashlytics Error test completed');
    } catch (e) {
      AppLogger.error('❌ Crashlytics Error test failed', e);
    }
  }

  Future<void> _testCrashlyticsCustomKeys() async {
    try {
      await CrashlyticsService.setCustomKey(key: 'test_key', value: 'test_value');
      await CrashlyticsService.setCustomKey(key: 'test_number', value: 123);
      await CrashlyticsService.setCustomKey(key: 'test_bool', value: true);
      AppLogger.info('✅ Crashlytics Custom Keys test completed');
    } catch (e) {
      AppLogger.error('❌ Crashlytics Custom Keys test failed', e);
    }
  }

  Future<void> _testCrashlyticsUserInfo() async {
    try {
      await CrashlyticsService.setUserId('test_user_crashlytics_123');
      AppLogger.info('✅ Crashlytics User Info test completed');
    } catch (e) {
      AppLogger.error('❌ Crashlytics User Info test failed', e);
    }
  }

  Future<void> _testCrashlyticsLog() async {
    try {
      await CrashlyticsService.log('Test log message from Firebase test page');
      AppLogger.info('✅ Crashlytics Log test completed');
    } catch (e) {
      AppLogger.error('❌ Crashlytics Log test failed', e);
    }
  }

  // Status Check Function
  Future<void> _checkFirebaseStatus() async {
    try {
      // Check Crashlytics status
      final isEnabled = await CrashlyticsService.isCrashlyticsCollectionEnabled();
      AppLogger.info('🔍 Crashlytics Collection Enabled: $isEnabled');
      
      // Log current status
      AppLogger.info('🔍 Firebase Status Check:');
      AppLogger.info('  - Analytics: Available');
      AppLogger.info('  - Crashlytics: Available');
      AppLogger.info('  - Collection Enabled: $isEnabled');
      
      AppLogger.info('✅ Firebase Status Check completed');
    } catch (e) {
      AppLogger.error('❌ Firebase Status Check failed', e);
    }
  }
}
