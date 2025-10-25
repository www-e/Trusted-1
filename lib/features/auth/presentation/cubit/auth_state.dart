// Auth State - Defines all possible authentication states
// Used by AuthCubit to manage authentication flow

import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state - app just started
class AuthInitial extends AuthState {}

/// Loading state - operation in progress
class AuthLoading extends AuthState {}

/// Authenticated - user is logged in
class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated - user is not logged in
class AuthUnauthenticated extends AuthState {}

/// Sign Up Success
class AuthSignUpSuccess extends AuthState {
  final UserModel user;
  final String message;

  AuthSignUpSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// Sign In Success
class AuthSignInSuccess extends AuthState {
  final UserModel user;
  final String message;

  AuthSignInSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// OTP Sent
class AuthOtpSent extends AuthState {
  final String email;
  final String message;
  final int expiresIn;

  AuthOtpSent({
    required this.email,
    required this.message,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [email, message, expiresIn];
}

/// Email Verified
class AuthEmailVerified extends AuthState {
  final String message;

  AuthEmailVerified({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Profile Updated
class AuthProfileUpdated extends AuthState {
  final UserModel user;
  final String message;

  AuthProfileUpdated({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// Sign Out Success
class AuthSignOutSuccess extends AuthState {}

/// Error state
class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  AuthError({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}
