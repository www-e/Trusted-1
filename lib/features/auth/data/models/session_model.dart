// Session Model - Represents authentication session with token and expiry
// Used for storing and managing user sessions

import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  final String id;
  final String token;
  final String expiresAt;
  final String? ipAddress;
  final String? userAgent;

  SessionModel({
    required this.id,
    required this.token,
    required this.expiresAt,
    this.ipAddress,
    this.userAgent,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  /// Check if session is expired
  bool get isExpired {
    try {
      final expiry = DateTime.parse(expiresAt);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  SessionModel copyWith({
    String? id,
    String? token,
    String? expiresAt,
    String? ipAddress,
    String? userAgent,
  }) {
    return SessionModel(
      id: id ?? this.id,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
    );
  }
}
