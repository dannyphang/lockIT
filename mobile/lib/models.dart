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
  final String icon; // could be asset path for demo
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
  final int typeId;
  final String title;
  final int amount;
  final String? source;

  PointTransaction({
    required this.uid,
    required this.userUid,
    required this.typeId,
    required this.title,
    required this.amount,
    this.source,

    super.statusId,
    super.createdDate,
    super.createdBy,
    super.modifiedDate,
    super.modifiedBy,
  }) : super();

  PointTransaction copyWith({bool? completed}) => PointTransaction(
    uid: uid,
    userUid: userUid,
    typeId: typeId,
    title: title,
    amount: amount,
    source: source,
  );
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
