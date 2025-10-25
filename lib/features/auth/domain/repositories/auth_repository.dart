// Auth Repository Interface - Defines contract for authentication operations
// This is implemented by AuthRepositoryImpl in the data layer

import '../../data/models/auth_request_models.dart';
import '../../data/models/auth_response_models.dart';
import '../../data/models/user_model.dart';
import '../../data/models/session_model.dart';

abstract class AuthRepository {
  Future<SignUpResponseModel> signUp(SignUpRequestModel request);
  Future<SignInResponseModel> signIn(SignInRequestModel request);
  Future<SendEmailOtpResponseModel> sendEmailVerificationOtp(String email);
  Future<VerifyEmailOtpResponseModel> verifyEmailOtp(String email, String otp);
  Future<GetMeResponseModel> getMe();
  Future<UpdateProfileResponseModel> updateProfile(
    UpdateProfileRequestModel request,
  );
  Future<SignOutResponseModel> signOut([String? sessionToken]);
  Future<void> saveSession(UserModel user, SessionModel session);
  Future<void> clearSession();
  Future<UserModel?> getCachedUser();
  Future<String?> getToken();
  Future<bool> isTokenExpired();
}
