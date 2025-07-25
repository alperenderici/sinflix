import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

class AuthRegisterLoading extends AuthState {
  const AuthRegisterLoading();
}

class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();
}

class AuthPasswordResetEmailSent extends AuthState {
  final String email;

  const AuthPasswordResetEmailSent({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

class AuthPasswordChangeSuccess extends AuthState {
  const AuthPasswordChangeSuccess();
}
