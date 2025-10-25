// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
  SignUpResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'user': instance.user,
  'session': instance.session,
};

SignInResponseModel _$SignInResponseModelFromJson(Map<String, dynamic> json) =>
    SignInResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      session: SignInSessionData.fromJson(
        json['session'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SignInResponseModelToJson(
  SignInResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'session': instance.session,
};

SignInSessionData _$SignInSessionDataFromJson(Map<String, dynamic> json) =>
    SignInSessionData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInSessionDataToJson(SignInSessionData instance) =>
    <String, dynamic>{'user': instance.user, 'session': instance.session};

SendEmailOtpResponseModel _$SendEmailOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => SendEmailOtpResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  email: json['email'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
);

Map<String, dynamic> _$SendEmailOtpResponseModelToJson(
  SendEmailOtpResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'email': instance.email,
  'expiresIn': instance.expiresIn,
};

VerifyEmailOtpResponseModel _$VerifyEmailOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyEmailOtpResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  emailVerified: json['emailVerified'] as bool,
);

Map<String, dynamic> _$VerifyEmailOtpResponseModelToJson(
  VerifyEmailOtpResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'emailVerified': instance.emailVerified,
};

GetMeResponseModel _$GetMeResponseModelFromJson(Map<String, dynamic> json) =>
    GetMeResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetMeResponseModelToJson(GetMeResponseModel instance) =>
    <String, dynamic>{'user': instance.user, 'session': instance.session};

UpdateProfileResponseModel _$UpdateProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => UpdateProfileResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateProfileResponseModelToJson(
  UpdateProfileResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'user': instance.user,
};

SignOutResponseModel _$SignOutResponseModelFromJson(
  Map<String, dynamic> json,
) => SignOutResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$SignOutResponseModelToJson(
  SignOutResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
