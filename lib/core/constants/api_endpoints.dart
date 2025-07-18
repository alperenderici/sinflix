/// API endpoint constants for the application
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  // Auth endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';

  // User endpoints
  static const String profile = '/user/profile';
  static const String uploadPhoto = '/user/upload_photo';

  // Movie endpoints
  static const String movieList = '/movie/list';
  static const String favorites = '/movie/favorites';
  static String toggleFavorite(String movieId) => '/movie/favorite/$movieId';
}
