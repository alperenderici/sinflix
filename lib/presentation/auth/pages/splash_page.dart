import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/firebase_test_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../core/navigation/navigation_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  void _checkAuthStatus() {
    // Delay to show splash screen
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // The AuthBloc will handle the navigation based on auth state
        // This is just a placeholder - actual navigation will be handled by the BLoC listener
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.movie,
                          size: 60,
                          color: AppColors.onPrimary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // App Name
                      const Text('Sinflix', style: AppTextStyles.headlineLarge),

                      const SizedBox(height: 8),

                      // Tagline
                      Text(
                        'Your Movie Experience',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Loading Indicator
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),

                      // Debug Test Buttons (only in debug mode)
                      if (kDebugMode) ...[
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseTestService.testFirebaseServices();
                            } catch (e) {
                              AppLogger.error('Firebase test failed', e);
                            }
                          },
                          child: const Text('🧪 Test Firebase'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseTestService.simulateUserSession();
                            } catch (e) {
                              AppLogger.error('User simulation failed', e);
                            }
                          },
                          child: const Text('👤 Simulate User'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
