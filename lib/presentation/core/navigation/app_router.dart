import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection_container.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/pages/register_page.dart';
import '../../auth/pages/splash_page.dart';
import '../../debug/pages/firebase_test_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../shared_widgets/main_wrapper.dart';
import 'app_routes.dart';
import 'navigation_service.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      initialLocation: AppRoutes.splash,
      routes: [
        // Splash Route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // Auth Routes
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const RegisterPage(),
          ),
        ),

        // Main App Routes with Bottom Navigation
        ShellRoute(
          builder: (context, state, child) => MainWrapper(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),

        // Movie Details Route
        GoRoute(
          path: AppRoutes.movieDetails,
          builder: (context, state) {
            final movieId = state.pathParameters['id']!;
            return MovieDetailsPage(movieId: movieId);
          },
        ),

        // Search Route
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchPage(),
        ),

        // Profile Edit Route
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),

        // Settings Route
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsPage(),
        ),

        // Firebase Test Route (Debug only)
        GoRoute(
          path: AppRoutes.firebaseTest,
          builder: (context, state) => const FirebaseTestPage(),
        ),
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
      redirect: (context, state) {
        // Add authentication redirect logic here
        // This is a placeholder - implement based on auth state
        return null;
      },
    );
  }
}

// Placeholder pages - these would be implemented in their respective feature folders
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Favorites Page')));
  }
}

class MovieDetailsPage extends StatelessWidget {
  final String movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Center(child: Text('Movie ID: $movieId')),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(child: Text('Search Page')),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(child: Text('404 - Page Not Found')),
    );
  }
}
