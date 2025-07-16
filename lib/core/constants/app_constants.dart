class AppConstants {
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://api.sinflix.com';
  static const String apiVersion = 'v1';
  static const String apiUrl = '$baseUrl/$apiVersion';

  // Pagination
  static const int defaultPageSize = 5;
  static const int maxPageSize = 20;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheMaxAge = Duration(hours: 1);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Image Configuration
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'tr'];
  static const String defaultLanguage = 'en';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardElevation = 4.0;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxEmailLength = 254;

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred';
  static const String unknownErrorMessage = 'An unknown error occurred';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String serverErrorMessage = 'Server error occurred';

  // Storage Keys (for non-secure storage)
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String firstLaunchKey = 'first_launch';

  // Firebase
  static const String firebaseCollectionUsers = 'users';
  static const String firebaseCollectionMovies = 'movies';
  static const String firebaseCollectionFavorites = 'favorites';

  // Deep Links
  static const String deepLinkScheme = 'sinflix';
  static const String deepLinkHost = 'app';

  // Social Media
  static const String twitterUrl = 'https://twitter.com/sinflix';
  static const String instagramUrl = 'https://instagram.com/sinflix';
  static const String facebookUrl = 'https://facebook.com/sinflix';

  // App Store
  static const String appStoreId = '123456789';
  static const String playStoreId = 'com.sinflix.app';

  // Version
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
}
