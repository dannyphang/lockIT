import 'package:flutter/foundation.dart';

import 'models.dart'; // <- this should export BaseDto, or change to your BaseDto import

@immutable
class User extends BaseDto {
  final String uid; // backend uid (string)
  final int id; // numeric id if your API also returns one
  final String displayName;
  final String username;
  final String email;
  final int scorePoint;
  final String? avatarUrl;

  User({
    required this.uid,
    required this.id,
    required this.displayName,
    required this.username,
    required this.email,
    required this.scorePoint,
    this.avatarUrl,
    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  });

  User copyWith({
    String? uid,
    int? id,
    String? displayName,
    String? username,
    String? email,
    int? scorePoint,
    String? avatarUrl,
    int? statusId,
    DateTime? createdDate,
    String? createdBy,
    DateTime? modifiedDate,
    String? modifiedBy,
  }) {
    return User(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      email: email ?? this.email,
      scorePoint: scorePoint ?? this.scorePoint,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      statusId: statusId ?? this.statusId,
      createdDate: createdDate ?? this.createdDate,
      createdBy: createdBy ?? this.createdBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
    );
  }

  // Convenience helpers for points
  User addPoints(int delta) => copyWith(scorePoint: scorePoint + delta);
  User spendPoints(int cost) =>
      copyWith(scorePoint: (scorePoint - cost).clamp(0, 1 << 31));

  // ---------- Serialization ----------
  factory User.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) =>
        (v is String && v.isNotEmpty) ? DateTime.tryParse(v) : null;

    return User(
      uid: json['uid'] as String,
      id: (json['id'] as num).toInt(),
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      scorePoint: (json['scorePoint'] as num).toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      statusId: (json['statusId'] as num?)?.toInt(),
      createdDate: parseDate(json['createdDate']),
      createdBy: json['createdBy'] as String?,
      modifiedDate: parseDate(json['modifiedDate']),
      modifiedBy: json['modifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'id': id,
    'displayName': displayName,
    'username': username,
    'email': email,
    'scorePoint': scorePoint,
    'avatarUrl': avatarUrl,
    'statusId': statusId,
    'createdDate': createdDate?.toIso8601String(),
    'createdBy': createdBy,
    'modifiedDate': modifiedDate?.toIso8601String(),
    'modifiedBy': modifiedBy,
  };
}
