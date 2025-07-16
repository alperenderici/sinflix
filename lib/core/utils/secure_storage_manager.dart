import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_logger.dart';

class SecureStorageManager {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';

  // Token Management
  static Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      AppLogger.debug('Access token saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save access token', e);
      rethrow;
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      AppLogger.debug('Access token retrieved: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e) {
      AppLogger.error('Failed to get access token', e);
      return null;
    }
  }

  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      AppLogger.debug('Refresh token saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save refresh token', e);
      rethrow;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: _refreshTokenKey);
      AppLogger.debug('Refresh token retrieved: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e) {
      AppLogger.error('Failed to get refresh token', e);
      return null;
    }
  }

  // User Data Management
  static Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
      AppLogger.debug('User ID saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save user ID', e);
      rethrow;
    }
  }

  static Future<String?> getUserId() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      AppLogger.debug('User ID retrieved: ${userId != null ? 'Found' : 'Not found'}');
      return userId;
    } catch (e) {
      AppLogger.error('Failed to get user ID', e);
      return null;
    }
  }

  static Future<void> saveUserEmail(String email) async {
    try {
      await _storage.write(key: _userEmailKey, value: email);
      AppLogger.debug('User email saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save user email', e);
      rethrow;
    }
  }

  static Future<String?> getUserEmail() async {
    try {
      final email = await _storage.read(key: _userEmailKey);
      AppLogger.debug('User email retrieved: ${email != null ? 'Found' : 'Not found'}');
      return email;
    } catch (e) {
      AppLogger.error('Failed to get user email', e);
      return null;
    }
  }

  // App Settings
  static Future<void> saveLanguage(String language) async {
    try {
      await _storage.write(key: _languageKey, value: language);
      AppLogger.debug('Language saved: $language');
    } catch (e) {
      AppLogger.error('Failed to save language', e);
      rethrow;
    }
  }

  static Future<String?> getLanguage() async {
    try {
      final language = await _storage.read(key: _languageKey);
      AppLogger.debug('Language retrieved: ${language ?? 'Default'}');
      return language;
    } catch (e) {
      AppLogger.error('Failed to get language', e);
      return null;
    }
  }

  static Future<void> saveTheme(String theme) async {
    try {
      await _storage.write(key: _themeKey, value: theme);
      AppLogger.debug('Theme saved: $theme');
    } catch (e) {
      AppLogger.error('Failed to save theme', e);
      rethrow;
    }
  }

  static Future<String?> getTheme() async {
    try {
      final theme = await _storage.read(key: _themeKey);
      AppLogger.debug('Theme retrieved: ${theme ?? 'Default'}');
      return theme;
    } catch (e) {
      AppLogger.error('Failed to get theme', e);
      return null;
    }
  }

  // Clear All Data
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('All secure storage data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', e);
      rethrow;
    }
  }

  // Clear Auth Data Only
  static Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
        _storage.delete(key: _userIdKey),
        _storage.delete(key: _userEmailKey),
      ]);
      AppLogger.info('Auth data cleared from secure storage');
    } catch (e) {
      AppLogger.error('Failed to clear auth data', e);
      rethrow;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final accessToken = await getAccessToken();
      final userId = await getUserId();
      return accessToken != null && userId != null;
    } catch (e) {
      AppLogger.error('Failed to check login status', e);
      return false;
    }
  }
}
