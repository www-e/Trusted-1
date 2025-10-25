// Auth Response Models - All response models for authentication endpoints
// Maps API responses to strongly-typed models

import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'session_model.dart';

part 'auth_response_models.g.dart';

/// Sign Up Response
@JsonSerializable()
class SignUpResponseModel {
  final bool success;
  final String message;
  final UserModel user;
  final SessionModel session;

  SignUpResponseModel({
    required this.success,
    required this.message,
    required this.user,
    required this.session,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);
}

/// Sign In Response
@JsonSerializable()
class SignInResponseModel {
  final bool success;
  final String message;
  final SignInSessionData session;

  SignInResponseModel({
    required this.success,
    required this.message,
    required this.session,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseModelToJson(this);
}

@JsonSerializable()
class SignInSessionData {
  final UserModel user;
  final SessionModel session;

  SignInSessionData({
    required this.user,
    required this.session,
  });

  factory SignInSessionData.fromJson(Map<String, dynamic> json) =>
      _$SignInSessionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SignInSessionDataToJson(this);
}

/// Send Email OTP Response
@JsonSerializable()
class SendEmailOtpResponseModel {
  final bool success;
  final String message;
  final String email;
  final int expiresIn;

  SendEmailOtpResponseModel({
    required this.success,
    required this.message,
    required this.email,
    required this.expiresIn,
  });

  factory SendEmailOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendEmailOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendEmailOtpResponseModelToJson(this);
}

/// Verify Email OTP Response
@JsonSerializable()
class VerifyEmailOtpResponseModel {
  final bool success;
  final String message;
  final bool emailVerified;

  VerifyEmailOtpResponseModel({
    required this.success,
    required this.message,
    required this.emailVerified,
  });

  factory VerifyEmailOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailOtpResponseModelToJson(this);
}

/// Get Me Response
@JsonSerializable()
class GetMeResponseModel {
  final UserModel user;
  final SessionModel session;

  GetMeResponseModel({
    required this.user,
    required this.session,
  });

  factory GetMeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetMeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetMeResponseModelToJson(this);
}

/// Update Profile Response
@JsonSerializable()
class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final UserModel user;

  UpdateProfileResponseModel({
    required this.success,
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileResponseModelToJson(this);
}

/// Sign Out Response
@JsonSerializable()
class SignOutResponseModel {
  final bool success;
  final String message;

  SignOutResponseModel({
    required this.success,
    required this.message,
  });

  factory SignOutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignOutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignOutResponseModelToJson(this);
}
