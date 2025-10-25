// User Model - Represents user profile and account information
// Contains all user data returned from API

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  final String email;
  final bool emailVerified;
  final String? name;
  final String role;
  final String? phoneNumber;
  final String? secondPhone;
  final String? deviceId;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerified,
    this.name,
    required this.role,
    this.phoneNumber,
    this.secondPhone,
    this.deviceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    bool? emailVerified,
    String? name,
    String? role,
    String? phoneNumber,
    String? secondPhone,
    String? deviceId,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      secondPhone: secondPhone ?? this.secondPhone,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
