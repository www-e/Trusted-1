// Auth Cubit - Manages authentication state and business logic
// Coordinates between UI and repository

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/device/device_service.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../data/models/auth_request_models.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final DeviceService _deviceService;

  AuthCubit({
    required AuthRepository repository,
    required DeviceService deviceService,
  })  : _repository = repository,
        _deviceService = deviceService,
        super(AuthInitial());

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      final token = await _repository.getToken();
      final isExpired = await _repository.isTokenExpired();

      if (token != null && !isExpired) {
        // Token exists and is valid, get user data
        final user = await _repository.getCachedUser();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// Sign Up
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
    String? secondPhone,
  }) async {
    try {
      emit(AuthLoading());

      // Get device ID
      final deviceId = await _deviceService.getDeviceId();

      // Create request
      final request = SignUpRequestModel(
        username: username,
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        secondPhone: secondPhone,
        deviceId: deviceId,
      );

      // Sign up
      final response = await _repository.signUp(request);

      emit(AuthSignUpSuccess(
        user: response.user,
        message: response.message,
      ));
    } on ApiException catch (e) {
      emit(AuthError(message: e.message, errorCode: e.errorCode));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Sign In
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      // Get device ID
      final deviceId = await _deviceService.getDeviceId();

      // Create request
      final request = SignInRequestModel(
        username: username,
        password: password,
        deviceId: deviceId,
      );

      // Sign in
      final response = await _repository.signIn(request);

      emit(AuthSignInSuccess(
        user: response.session.user,
        message: response.message,
      ));
    } on ApiException catch (e) {
      emit(AuthError(message: e.message, errorCode: e.errorCode));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Send Email Verification OTP
  Future<void> sendEmailVerificationOtp(String email) async {
    try {
      emit(AuthLoading());

      final response = await _repository.sendEmailVerificationOtp(email);

      emit(AuthOtpSent(
        email: response.email,
        message: response.message,
        expiresIn: response.expiresIn,
      ));
    } on ApiException catch (e) {
      emit(AuthError(message: e.message, errorCode: e.errorCode));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Verify Email OTP
  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      emit(AuthLoading());

      final response = await _repository.verifyEmailOtp(email, otp);

      emit(AuthEmailVerified(message: response.message));
    } on ApiException catch (e) {
      emit(AuthError(message: e.message, errorCode: e.errorCode));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Get Current User
  Future<void> getCurrentUser() async {
    try {
      emit(AuthLoading());

      final response = await _repository.getMe();

      emit(AuthAuthenticated(user: response.user));
    } on TokenExpiredException {
      await _repository.clearSession();
      emit(AuthUnauthenticated());
    } on ApiException catch (e) {
      if (e is UnauthorizedException) {
        await _repository.clearSession();
        emit(AuthUnauthenticated());
      } else {
        emit(AuthError(message: e.message, errorCode: e.errorCode));
      }
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Update Profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? secondPhone,
  }) async {
    try {
      emit(AuthLoading());

      final request = UpdateProfileRequestModel(
        name: name,
        phoneNumber: phoneNumber,
        secondPhone: secondPhone,
      );

      final response = await _repository.updateProfile(request);

      emit(AuthProfileUpdated(
        user: response.user,
        message: response.message,
      ));
    } on TokenExpiredException {
      await _repository.clearSession();
      emit(AuthUnauthenticated());
    } on ApiException catch (e) {
      emit(AuthError(message: e.message, errorCode: e.errorCode));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      emit(AuthLoading());

      await _repository.signOut();

      emit(AuthSignOutSuccess());
    } catch (e) {
      // Even if API call fails, clear local session
      await _repository.clearSession();
      emit(AuthSignOutSuccess());
    }
  }

  /// Reset to unauthenticated state
  void reset() {
    emit(AuthUnauthenticated());
  }
}
