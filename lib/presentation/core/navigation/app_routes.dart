class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes
  static const String main = '/main';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String favorites = '/favorites';

  // Movie Routes
  static const String movieDetails = '/movie/:id';
  static const String search = '/search';

  // Profile Routes
  static const String editProfile = '/profile/edit';
  static const String uploadPhoto = '/profile/upload-photo';
  static const String settings = '/settings';

  // Error Routes
  static const String notFound = '/404';
}
