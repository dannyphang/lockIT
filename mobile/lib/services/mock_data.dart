import '../models.dart';

List<BlockableApp> mockApps() => [
  BlockableApp(
    package: 'com.instagram.android',
    name: 'Instagram',
    icon: 'assets/ig.png',
    blocked: true,
    allowedUntil: 0,
  ),
  BlockableApp(
    package: 'com.tiktok.app',
    name: 'TikTok',
    icon: 'assets/tiktok.png',
    blocked: true,
    allowedUntil: 0,
  ),
  BlockableApp(
    package: 'com.mobile.legends',
    name: 'Mobile Legends',
    icon: 'assets/ml.png',
    blocked: true,
    allowedUntil: 0,
  ),
  BlockableApp(
    package: 'com.whatsapp',
    name: 'WhatsApp',
    icon: 'assets/wa.png',
    blocked: false,
    allowedUntil: 0,
  ),
];

List<TaskItem> mockTasks() => [
  TaskItem(
    uid: 't1',
    id: 1,
    title: '25 push-ups',
    description: 'Do a quick workout to earn points.',
    rewardPoints: 1,
    duration: 5,
    type: 'exercise',
  ),
  TaskItem(
    uid: 't2',
    id: 2,
    title: 'Read 10 pages',
    description: 'Read a book or notes.',
    rewardPoints: 2,
    duration: 15,
    type: 'reading',
  ),
  TaskItem(
    uid: 't3',
    id: 3,
    title: 'Focus 20 minutes',
    description: 'Start a focus timer and complete it.',
    rewardPoints: 3,
    duration: 20,
    type: 'focus',
  ),
];

List<PointTransaction> mockTransactions() => [
  PointTransaction(
    uid: 'pt1',
    userUid: 'u1',
    typeId: 1,
    title: 'Completed 25 push-ups',
    amount: 1,
    source: 'task',
    createdDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  PointTransaction(
    uid: 'pt2',
    userUid: 'u1',
    typeId: 2,
    title: 'Instagram',
    amount: 2,
    source: null,
    createdDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  PointTransaction(
    uid: 'pt3',
    userUid: 'u1',
    typeId: 1,
    title: 'Completed 20 minutes focus',
    amount: 3,
    source: 'task',
    createdDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
