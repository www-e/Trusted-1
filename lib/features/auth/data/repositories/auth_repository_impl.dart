// Auth Repository Implementation - Implements AuthRepository interface
// Coordinates between remote datasource and local storage

import 'dart:convert';
import '../../../../core/config/env.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required SecureStorageService storage,
  })  : _remoteDatasource = remoteDatasource,
        _storage = storage;

  @override
  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    final response = await _remoteDatasource.signUp(request);
    // Save session after successful signup
    await saveSession(response.user, response.session);
    return response;
  }

  @override
  Future<SignInResponseModel> signIn(SignInRequestModel request) async {
    final response = await _remoteDatasource.signIn(request);
    // Save session after successful signin
    await saveSession(response.session.user, response.session.session);
    return response;
  }

  @override
  Future<SendEmailOtpResponseModel> sendEmailVerificationOtp(
    String email,
  ) async {
    final request = SendEmailOtpRequestModel(email: email);
    return await _remoteDatasource.sendEmailVerificationOtp(request);
  }

  @override
  Future<VerifyEmailOtpResponseModel> verifyEmailOtp(
    String email,
    String otp,
  ) async {
    final request = VerifyEmailOtpRequestModel(email: email, otp: otp);
    final response = await _remoteDatasource.verifyEmailOtp(request);

    // Update cached user's emailVerified status
    final cachedUser = await getCachedUser();
    if (cachedUser != null && response.emailVerified) {
      final updatedUser = cachedUser.copyWith(emailVerified: true);
      await _storage.write(
        AppConfig.storageKeyUser,
        jsonEncode(updatedUser.toJson()),
      );
    }

    return response;
  }

  @override
  Future<GetMeResponseModel> getMe() async {
    final response = await _remoteDatasource.getMe();
    // Update cached user data
    await saveSession(response.user, response.session);
    return response;
  }

  @override
  Future<UpdateProfileResponseModel> updateProfile(
    UpdateProfileRequestModel request,
  ) async {
    final response = await _remoteDatasource.updateProfile(request);
    // Update cached user data
    await _storage.write(
      AppConfig.storageKeyUser,
      jsonEncode(response.user.toJson()),
    );
    return response;
  }

  @override
  Future<SignOutResponseModel> signOut([String? sessionToken]) async {
    final response = await _remoteDatasource.signOut(sessionToken);
    // Clear local session
    await clearSession();
    return response;
  }

  @override
  Future<void> saveSession(UserModel user, SessionModel session) async {
    // Save token
    await _storage.write(AppConfig.storageKeyToken, session.token);

    // Save token expiry
    await _storage.write(AppConfig.storageKeyTokenExpiry, session.expiresAt);

    // Save user data
    await _storage.write(
      AppConfig.storageKeyUser,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(AppConfig.storageKeyToken);
    await _storage.delete(AppConfig.storageKeyTokenExpiry);
    await _storage.delete(AppConfig.storageKeyUser);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = await _storage.read(AppConfig.storageKeyUser);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(AppConfig.storageKeyToken);
  }

  @override
  Future<bool> isTokenExpired() async {
    final expiryStr = await _storage.read(AppConfig.storageKeyTokenExpiry);
    if (expiryStr == null) return true;

    try {
      final expiryDate = DateTime.parse(expiryStr);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }
}
