// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestModel _$SignUpRequestModelFromJson(Map<String, dynamic> json) =>
    SignUpRequestModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      secondPhone: json['secondPhone'] as String?,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$SignUpRequestModelToJson(SignUpRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'secondPhone': instance.secondPhone,
      'deviceId': instance.deviceId,
    };

SignInRequestModel _$SignInRequestModelFromJson(Map<String, dynamic> json) =>
    SignInRequestModel(
      username: json['username'] as String,
      password: json['password'] as String,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$SignInRequestModelToJson(SignInRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'deviceId': instance.deviceId,
    };

SendEmailOtpRequestModel _$SendEmailOtpRequestModelFromJson(
  Map<String, dynamic> json,
) => SendEmailOtpRequestModel(email: json['email'] as String);

Map<String, dynamic> _$SendEmailOtpRequestModelToJson(
  SendEmailOtpRequestModel instance,
) => <String, dynamic>{'email': instance.email};

VerifyEmailOtpRequestModel _$VerifyEmailOtpRequestModelFromJson(
  Map<String, dynamic> json,
) => VerifyEmailOtpRequestModel(
  email: json['email'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$VerifyEmailOtpRequestModelToJson(
  VerifyEmailOtpRequestModel instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};

UpdateProfileRequestModel _$UpdateProfileRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequestModel(
  name: json['name'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  secondPhone: json['secondPhone'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestModelToJson(
  UpdateProfileRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'secondPhone': instance.secondPhone,
};

SignOutRequestModel _$SignOutRequestModelFromJson(Map<String, dynamic> json) =>
    SignOutRequestModel(sessionToken: json['sessionToken'] as String?);

Map<String, dynamic> _$SignOutRequestModelToJson(
  SignOutRequestModel instance,
) => <String, dynamic>{'sessionToken': instance.sessionToken};
