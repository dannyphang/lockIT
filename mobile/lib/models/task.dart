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
  final TaskProgress? taskProgress;

  Task({
    required this.uid,
    required this.id,
    required this.title,
    this.description,
    required this.rewardPoints,
    required this.type,
    this.duration,
    this.taskProgress,
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
    TaskProgress? taskProgress,
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
      taskProgress: taskProgress ?? this.taskProgress,
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
      taskProgress: json['taskProgress'] != null
          ? TaskProgress.fromJson(json['taskProgress'] as Map<String, dynamic>)
          : null,
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
      'taskProgress': taskProgress?.toJson(),
      'statusId': statusId,
      'createdDate': createdDate?.toIso8601String(),
      'createdBy': createdBy,
      'modifiedDate': modifiedDate?.toIso8601String(),
      'modifiedBy': modifiedBy,
    };
  }
}

class TaskProgress {
  final String uid;
  final int taskStatusId;
  final String taskUid;
  final String userUid;
  final DateTime startedDate;
  final DateTime? completedDate;
  final int statusId;

  TaskProgress({
    required this.uid,
    required this.taskStatusId,
    required this.taskUid,
    required this.userUid,
    this.completedDate,
    required this.startedDate,
    required this.statusId,
  });

  factory TaskProgress.fromJson(Map<String, dynamic> json) {
    return TaskProgress(
      uid: json['uid'] as String,
      taskStatusId: json['taskStatusId'] as int,
      taskUid: json['taskUid'] as String,
      userUid: json['userUid'] as String,
      startedDate: DateTime.parse(json['startedDate'] as String),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      statusId: json['statusId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'taskStatusId': taskStatusId,
      'taskUid': taskUid,
      'userUid': userUid,
      'startedDate': startedDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'statusId': statusId,
    };
  }
}
