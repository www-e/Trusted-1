// Auth Request Models - All request models for authentication endpoints
// Used for sending data to the API

import 'package:json_annotation/json_annotation.dart';

part 'auth_request_models.g.dart';

/// Sign Up Request
@JsonSerializable()
class SignUpRequestModel {
  final String username;
  final String email;
  final String password;
  final String? name;
  final String? phoneNumber;
  final String? secondPhone;
  final String deviceId;

  SignUpRequestModel({
    required this.username,
    required this.email,
    required this.password,
    this.name,
    this.phoneNumber,
    this.secondPhone,
    required this.deviceId,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestModelToJson(this);
}

/// Sign In Request
@JsonSerializable()
class SignInRequestModel {
  final String username;
  final String password;
  final String deviceId;

  SignInRequestModel({
    required this.username,
    required this.password,
    required this.deviceId,
  });

  factory SignInRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestModelToJson(this);
}

/// Send Email OTP Request
@JsonSerializable()
class SendEmailOtpRequestModel {
  final String email;

  SendEmailOtpRequestModel({required this.email});

  factory SendEmailOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendEmailOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendEmailOtpRequestModelToJson(this);
}

/// Verify Email OTP Request
@JsonSerializable()
class VerifyEmailOtpRequestModel {
  final String email;
  final String otp;

  VerifyEmailOtpRequestModel({
    required this.email,
    required this.otp,
  });

  factory VerifyEmailOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailOtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailOtpRequestModelToJson(this);
}

/// Update Profile Request
@JsonSerializable()
class UpdateProfileRequestModel {
  final String? name;
  final String? phoneNumber;
  final String? secondPhone;

  UpdateProfileRequestModel({
    this.name,
    this.phoneNumber,
    this.secondPhone,
  });

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestModelToJson(this);
}

/// Sign Out Request
@JsonSerializable()
class SignOutRequestModel {
  final String? sessionToken;

  SignOutRequestModel({this.sessionToken});

  factory SignOutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignOutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignOutRequestModelToJson(this);
}
