// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  emailVerified: json['emailVerified'] as bool,
  name: json['name'] as String?,
  role: json['role'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  secondPhone: json['secondPhone'] as String?,
  deviceId: json['deviceId'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'name': instance.name,
  'role': instance.role,
  'phoneNumber': instance.phoneNumber,
  'secondPhone': instance.secondPhone,
  'deviceId': instance.deviceId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
