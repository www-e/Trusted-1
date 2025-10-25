// Auth Remote Datasource - Handles all authentication API calls
// Implements exact API endpoints as per documentation

import '../../../../core/network/http_client.dart';
import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';

class AuthRemoteDatasource {
  final HttpClient _httpClient;

  AuthRemoteDatasource({required HttpClient httpClient})
      : _httpClient = httpClient;

  /// Sign Up - Creates a new user account
  /// POST /auth.signUp
  Future<SignUpResponseModel> signUp(SignUpRequestModel request) async {
    final response = await _httpClient.post(
      'auth.signUp',
      body: request.toJson(),
      requiresAuth: false,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return SignUpResponseModel.fromJson(data);
  }

  /// Sign In - Authenticates user and creates session
  /// POST /auth.signIn
  Future<SignInResponseModel> signIn(SignInRequestModel request) async {
    final response = await _httpClient.post(
      'auth.signIn',
      body: request.toJson(),
      requiresAuth: false,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return SignInResponseModel.fromJson(data);
  }

  /// Send Email Verification OTP
  /// POST /auth.sendEmailVerificationOTP
  Future<SendEmailOtpResponseModel> sendEmailVerificationOtp(
    SendEmailOtpRequestModel request,
  ) async {
    final response = await _httpClient.post(
      'auth.sendEmailVerificationOTP',
      body: request.toJson(),
      requiresAuth: false,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return SendEmailOtpResponseModel.fromJson(data);
  }

  /// Verify Email OTP
  /// POST /auth.verifyEmailOTP
  Future<VerifyEmailOtpResponseModel> verifyEmailOtp(
    VerifyEmailOtpRequestModel request,
  ) async {
    final response = await _httpClient.post(
      'auth.verifyEmailOTP',
      body: request.toJson(),
      requiresAuth: false,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return VerifyEmailOtpResponseModel.fromJson(data);
  }

  /// Get Current User - Protected endpoint
  /// GET /auth.getMe
  Future<GetMeResponseModel> getMe() async {
    final response = await _httpClient.get(
      'auth.getMe',
      requiresAuth: true,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return GetMeResponseModel.fromJson(data);
  }

  /// Update Profile - Protected endpoint
  /// POST /auth.updateProfile
  Future<UpdateProfileResponseModel> updateProfile(
    UpdateProfileRequestModel request,
  ) async {
    final response = await _httpClient.post(
      'auth.updateProfile',
      body: request.toJson(),
      requiresAuth: true,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return UpdateProfileResponseModel.fromJson(data);
  }

  /// Sign Out - Protected endpoint
  /// POST /auth.signOut
  Future<SignOutResponseModel> signOut([String? sessionToken]) async {
    final response = await _httpClient.post(
      'auth.signOut',
      body: sessionToken != null
          ? SignOutRequestModel(sessionToken: sessionToken).toJson()
          : {},
      requiresAuth: true,
    );

    // Extract data from tRPC response structure
    final data = response['result']['data'] as Map<String, dynamic>;
    return SignOutResponseModel.fromJson(data);
  }
}
