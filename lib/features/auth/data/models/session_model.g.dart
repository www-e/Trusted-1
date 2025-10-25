// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  token: json['token'] as String,
  expiresAt: json['expiresAt'] as String,
  ipAddress: json['ipAddress'] as String?,
  userAgent: json['userAgent'] as String?,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'expiresAt': instance.expiresAt,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
    };
