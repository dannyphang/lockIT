import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

import '../models.dart';
import '../services/mock_data.dart';

/// =======================
/// App preferences (onboarded + points)
/// =======================
class AppPrefsNotifier extends StateNotifier<AppPrefs> {
  AppPrefsNotifier() : super(const AppPrefs());

  void finishOnboarding() => state = state.copyWith(onboarded: true);
  void setPoints(int v) => state = state.copyWith(points: v);
  void addPoints(int v) => state = state.copyWith(points: state.points + v);

  bool spendPoints(int v) {
    if (state.points < v) return false;
    state = state.copyWith(points: state.points - v);
    return true;
  }
}

final appPrefsProvider = StateNotifierProvider<AppPrefsNotifier, AppPrefs>((
  ref,
) {
  return AppPrefsNotifier();
});

/// =======================
/// Apps (blockable apps)
/// =======================
class AppsNotifier extends StateNotifier<List<BlockableApp>> {
  AppsNotifier() : super(mockApps());

  void toggleBlock(String pkg, bool block) {
    state = [
      for (final a in state) a.package == pkg ? a.copyWith(blocked: block) : a,
    ];
  }

  void allowFor(String pkg, Duration d) {
    final until = DateTime.now().millisecondsSinceEpoch + d.inMilliseconds;
    state = [
      for (final a in state)
        a.package == pkg ? a.copyWith(allowedUntil: until) : a,
    ];
  }

  Future<void> loadFromDevice({
    bool includeSystemApps = false,
    bool includeIcons = false,
  }) async {
    final existingByPkg = {for (final a in state) a.package: a};

    final List<AppInfo> raw = await InstalledApps.getInstalledApps(
      includeSystemApps, // pass false to hide system apps
      includeIcons,
    );

    raw.sort(
      (a, b) => (a.name).toLowerCase().compareTo((b.name).toLowerCase()),
    );

    final mapped = <BlockableApp>[
      for (final app in raw)
        BlockableApp(
          package: app.packageName,
          name: app.name,
          icon:
              existingByPkg[app.packageName]?.icon ??
              '../assets/images/app.png',
          blocked: existingByPkg[app.packageName]?.blocked ?? false,
          allowedUntil: existingByPkg[app.packageName]?.allowedUntil ?? 0,
        ),
    ];

    state = mapped;
  }
}

final appsProvider = StateNotifierProvider<AppsNotifier, List<BlockableApp>>((
  ref,
) {
  return AppsNotifier();
});

/// =======================
/// Tasks
/// =======================
class TasksNotifier extends StateNotifier<List<TaskItem>> {
  TasksNotifier() : super(mockTasks());

  void complete(String id) {
    state = [
      for (final t in state) t.uid == id ? t.copyWith(completed: true) : t,
    ];
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskItem>>((
  ref,
) {
  return TasksNotifier();
});
