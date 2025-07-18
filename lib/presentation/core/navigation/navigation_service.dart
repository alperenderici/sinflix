import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_logger.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static GoRouter? _router;

  static GoRouter get router {
    if (_router == null) {
      throw StateError(
        'NavigationService router has not been initialized. Call NavigationService.initialize() first.',
      );
    }
    return _router!;
  }

  static void initialize(GoRouter router) {
    if (_router != null) {
      AppLogger.debug(
        'NavigationService router already initialized, skipping...',
      );
      return;
    }
    _router = router;
    AppLogger.debug('NavigationService router initialized successfully');
  }

  static BuildContext? get context => navigatorKey.currentContext;

  // Navigation methods
  static void go(String location, {Object? extra}) {
    AppLogger.debug('Navigating to: $location');
    router.go(location, extra: extra);
  }

  static void push(String location, {Object? extra}) {
    AppLogger.debug('Pushing to: $location');
    router.push(location, extra: extra);
  }

  static void pushReplacement(String location, {Object? extra}) {
    AppLogger.debug('Push replacement to: $location');
    router.pushReplacement(location, extra: extra);
  }

  static void pop([Object? result]) {
    AppLogger.debug('Popping current route');
    router.pop(result);
  }

  static void popUntil(String location) {
    AppLogger.debug('Popping until: $location');
    while (router.canPop()) {
      router.pop();
    }
  }

  static bool canPop() {
    return router.canPop();
  }

  // Route information
  static String get currentLocation {
    final ctx = context;
    if (ctx != null) {
      return GoRouterState.of(ctx).uri.path;
    }
    return '/';
  }

  static Map<String, String> get pathParameters {
    final ctx = context;
    if (ctx != null) {
      return GoRouterState.of(ctx).pathParameters;
    }
    return {};
  }

  static Map<String, String> get queryParameters {
    final ctx = context;
    if (ctx != null) {
      return GoRouterState.of(ctx).uri.queryParameters;
    }
    return {};
  }

  // Auth navigation helpers
  static void goToLogin() {
    go('/login');
  }

  static void goToRegister() {
    go('/register');
  }

  static void goToHome() {
    go('/main/home');
  }

  static void goToProfile() {
    go('/main/profile');
  }

  static void goToFavorites() {
    go('/main/favorites');
  }

  // Movie navigation helpers
  static void goToMovieDetails(String movieId) {
    go('/movie/$movieId');
  }

  static void goToSearch() {
    go('/search');
  }

  // Profile navigation helpers
  static void goToEditProfile() {
    go('/profile/edit');
  }

  static void goToUploadPhoto() {
    go('/profile/upload-photo');
  }

  static void goToSettings() {
    go('/settings');
  }

  // Error handling
  static void goToNotFound() {
    go('/404');
  }

  // Show dialogs and bottom sheets
  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    final ctx = context;
    if (ctx == null) return Future.value(null);
    return showDialog<T>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  static Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final ctx = context;
    if (ctx == null) return Future.value(null);
    return showModalBottomSheet<T>(
      context: ctx,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => child,
    );
  }

  // Snackbar
  static void showSnackBar({
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
  }) {
    final ctx = context;
    if (ctx == null) return;
    final messenger = ScaffoldMessenger.of(ctx);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Error snackbar
  static void showErrorSnackBar(String message) {
    final ctx = context;
    if (ctx == null) return;
    showSnackBar(
      message: message,
      backgroundColor: Theme.of(ctx).colorScheme.error,
    );
  }

  // Success snackbar
  static void showSuccessSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.green);
  }
}
