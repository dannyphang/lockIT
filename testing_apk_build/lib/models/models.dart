import 'dart:typed_data';

class BaseDto {
  final int? statusId;
  final DateTime? createdDate;
  final String? createdBy;
  final DateTime? modifiedDate;
  final String? modifiedBy;

  BaseDto({
    this.statusId,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });
}

class BlockableApp extends BaseDto {
  final String package;
  final String name;
  final Uint8List? icon; // could be asset path for demo
  final bool blocked;
  final int allowedUntil; // epoch ms (0 = not allowed)

  BlockableApp({
    required this.package,
    required this.name,
    required this.icon,
    required this.blocked,
    required this.allowedUntil,

    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  }) : super();

  BlockableApp copyWith({bool? blocked, int? allowedUntil}) => BlockableApp(
    package: package,
    name: name,
    icon: icon,
    blocked: blocked ?? this.blocked,
    allowedUntil: allowedUntil ?? this.allowedUntil,
  );
}

class TaskItem extends BaseDto {
  final String uid;
  final int id;
  final String title;
  final String description;
  final String type;
  final int duration;
  final int rewardPoints;

  TaskItem({
    required this.uid,
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.duration,
    required this.type,

    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  });

  TaskItem copyWith({bool? completed}) => TaskItem(
    uid: uid,
    id: id,
    title: title,
    description: description,
    rewardPoints: rewardPoints,
    duration: duration,
    type: type,
  );
}

class PointTransaction extends BaseDto {
  final String uid;
  final String userUid;
  final String? taskUid;
  final String? title;
  final String? description;
  final String? source;
  final int typeId;
  final int? spentPoint;
  final int? earnedPoint;

  PointTransaction({
    required this.uid,
    required this.userUid,
    this.taskUid,
    required this.typeId,
    this.spentPoint,
    this.title,
    this.description,
    this.source,
    this.earnedPoint,

    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  }) : super();

  PointTransaction copyWith({bool? completed}) => PointTransaction(
    uid: uid,
    userUid: userUid,
    taskUid: taskUid,
    typeId: typeId,
    spentPoint: spentPoint,
    earnedPoint: earnedPoint,
    title: title,
    description: description,
  );

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      uid: json['uid']?.toString() ?? '',
      userUid: json['userUid']?.toString() ?? '',
      taskUid: json['taskUid']?.toString(), // nullable
      typeId: int.tryParse(json['typeId']?.toString() ?? '') ?? 0,
      spentPoint: json['spentPoint'] != null
          ? int.tryParse(json['spentPoint'].toString())
          : null,
      earnedPoint: json['earnedPoint'] != null
          ? int.tryParse(json['earnedPoint'].toString())
          : null,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      source: json['source']?.toString(),
      statusId: int.tryParse(json['statusId']?.toString() ?? ''),
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'].toString())
          : null,
      createdBy: json['createdBy']?.toString(),
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'].toString())
          : null,
      modifiedBy: json['modifiedBy']?.toString(),
    );
  }
}

class AppPrefs {
  final bool onboarded;
  final int points;

  const AppPrefs({this.onboarded = false, this.points = 5});

  AppPrefs copyWith({bool? onboarded, int? points}) => AppPrefs(
    onboarded: onboarded ?? this.onboarded,
    points: points ?? this.points,
  );
}
