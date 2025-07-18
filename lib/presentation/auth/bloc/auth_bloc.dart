import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/crashlytics_service.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/auth/get_current_user.dart';
import '../../../domain/usecases/auth/login_user.dart';
import '../../../domain/usecases/auth/logout_user.dart';
import '../../../domain/usecases/auth/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('Checking authentication status...');
    emit(const AuthLoading());

    final result = await getCurrentUser();

    result.fold(
      (failure) {
        AppLogger.debug('User not authenticated: ${failure.message}');
        emit(const AuthUnauthenticated());
      },
      (user) {
        AppLogger.debug('User authenticated: ${user.email}');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('Login requested for: ${event.email}');
    emit(const AuthLoginLoading());

    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        AppLogger.error('Login failed: ${failure.message}');
        emit(AuthError(message: failure.message ?? 'Login failed'));
      },
      (user) async {
        AppLogger.info('Login successful for: ${user.email}');

        // Analytics: Log login event
        await AnalyticsService.logLogin(method: 'email');
        await AnalyticsService.setUserId(user.id);

        // Crashlytics: Set user info
        await CrashlyticsService.setUserId(user.id);
        await CrashlyticsService.setCustomKey(
          key: 'user_email',
          value: user.email,
        );

        // Check if emit is still valid before calling
        if (!emit.isDone) {
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('Registration requested for: ${event.email}');
    emit(const AuthRegisterLoading());

    final result = await registerUser(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.error('Registration failed: ${failure.message}');
        emit(AuthError(message: failure.message ?? 'Registration failed'));
      },
      (user) async {
        AppLogger.info('Registration successful for: ${user.email}');

        // Analytics: Log sign up event
        await AnalyticsService.logSignUp(method: 'email');
        await AnalyticsService.setUserId(user.id);

        // Crashlytics: Set user info
        await CrashlyticsService.setUserId(user.id);
        await CrashlyticsService.setCustomKey(
          key: 'user_email',
          value: user.email,
        );

        // Check if emit is still valid before calling
        if (!emit.isDone) {
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.debug('Logout requested');
    emit(const AuthLogoutLoading());

    final result = await logoutUser();

    result.fold(
      (failure) {
        AppLogger.error('Logout failed: ${failure.message}');
        // Even if logout fails on server, we should clear local state
        emit(const AuthUnauthenticated());
      },
      (_) {
        AppLogger.info('Logout successful');
        emit(const AuthUnauthenticated());
      },
    );
  }
}
