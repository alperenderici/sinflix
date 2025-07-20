import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../core/constants/app_assets.dart';
import '../../../src/extensions/shared/widgets/image/asset_image.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/navigation/navigation_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Kullanıcı giriş ekranı - Tasarıma uygun dark theme
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName: 'login_page');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      AnalyticsService.logCustomEvent(
        eventName: 'login_attempt',
        parameters: {'method': 'email'},
      );

      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _goToRegister() {
    NavigationService.push(AppRoutes.register);
  }

  void _forgotPassword() {
    NavigationService.showSnackBar(
      message: 'Şifremi unuttum özelliği yakında!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          AppLogger.debug(
            'Login page: Auth state changed to ${state.runtimeType}',
          );
          if (state is AuthAuthenticated) {
            AppLogger.info('Login page: Navigating to home...');
            NavigationService.goToHome();
          } else if (state is AuthError) {
            AppLogger.error('Login page: Auth error - ${state.message}');
            NavigationService.showErrorSnackBar(state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),

                  // Başlık
                  const Text(
                    'Merhabalar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Alt başlık
                  const Text(
                    'Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Email Input
                  _buildEmailField(),

                  const SizedBox(height: 16),

                  // Password Input
                  _buildPasswordField(),

                  const SizedBox(height: 16),

                  // Şifremi Unuttum
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Şifremi unuttum',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Giriş Yap Butonu
                  _buildLoginButton(),

                  const SizedBox(height: 40),

                  // Sosyal Medya Butonları
                  _buildSocialButtons(),

                  const SizedBox(height: 40),

                  // Kayıt Ol Linki
                  _buildRegisterLink(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'ornek@email.com',
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
          prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email adresi gerekli';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Geçerli bir email adresi girin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'En az 6 karakter',
          hintStyle: const TextStyle(color: Color(0xFF6B7280)),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6B7280)),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF6B7280),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Şifre gerekli';
          }
          if (value.length < 6) {
            return 'Şifre en az 6 karakter olmalı';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading || state is AuthLoginLoading;

        return Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Giriş Yap',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          svgAsset: AppAssets.googleLogo,
          onPressed: () {
            NavigationService.showSnackBar(message: 'Google girişi yakında!');
          },
        ),
        if (PlatformUtils.shouldShowAppleSignIn) ...[
          const SizedBox(width: 16),
          _buildSocialButton(
            svgAsset: AppAssets.appleLogo,
            onPressed: () {
              NavigationService.showSnackBar(message: 'Apple girişi yakında!');
            },
          ),
        ],
        const SizedBox(width: 16),
        _buildSocialButton(
          svgAsset: AppAssets.facebookLogo,
          onPressed: () {
            NavigationService.showSnackBar(message: 'Facebook girişi yakında!');
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String svgAsset,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: AImage(
          imgPath: svgAsset,
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Bir hesabın yok mu? ',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
        TextButton(
          onPressed: _goToRegister,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Kayıt Ol!',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
