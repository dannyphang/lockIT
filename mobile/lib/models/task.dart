import 'package:flutter/foundation.dart';

import 'models.dart'; // <- this should export BaseDto, or change to your BaseDto import

@immutable
class Task extends BaseDto {
  final String uid; // backend uid (string)
  final int id; // numeric id if your API also returns one
  final String title;
  final String? description;
  final int rewardPoints;
  final String type;
  final int? duration;

  Task({
    required this.uid,
    required this.id,
    required this.title,
    this.description,
    required this.rewardPoints,
    required this.type,
    this.duration,
    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  });

  Task copyWith({
    String? uid,
    int? id,
    String? title,
    String? description,
    int? rewardPoints,
    String? type,
    int? duration,
    int? statusId,
    DateTime? createdDate,
    String? createdBy,
    DateTime? modifiedDate,
    String? modifiedBy,
  }) {
    return Task(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      statusId: statusId ?? this.statusId,
      createdDate: createdDate ?? this.createdDate,
      createdBy: createdBy ?? this.createdBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
    );
  }

  // Convenience helpers for points
  bool get isTimed => type == 'timed';
  bool get isOneOff => type == 'one-off';
  bool get isRecurring => type == 'recurring';

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      uid: json['uid'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] ?? '',
      rewardPoints: json['rewardPoints'] as int,
      type: json['type'] as String,
      duration: json['duration'] as int?,
      statusId: json['statusId'] as int?,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : null,
      createdBy: json['createdBy'] as String?,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'] as String)
          : null,
      modifiedBy: json['modifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'title': title,
      'description': description,
      'rewardPoints': rewardPoints,
      'type': type,
      'duration': duration,
      'statusId': statusId,
      'createdDate': createdDate?.toIso8601String(),
      'createdBy': createdBy,
      'modifiedDate': modifiedDate?.toIso8601String(),
      'modifiedBy': modifiedBy,
    };
  }
}
