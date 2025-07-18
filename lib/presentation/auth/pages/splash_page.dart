import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/app_logger.dart';
import '../../../src/extensions/shared/widgets/image/asset_image.dart';
import '../../core/navigation/navigation_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Delay to show splash screen
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        AppLogger.debug('Splash: Auth state changed to ${state.runtimeType}');

        if (state is AuthAuthenticated) {
          NavigationService.goToHome();
        } else if (state is AuthUnauthenticated) {
          NavigationService.goToLogin();
        } else if (state is AuthError) {
          NavigationService.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AImage(imgPath: AppAssets.sinflixSplash, fit: BoxFit.cover),
      ),
    );
  }
}
