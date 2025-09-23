import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models.dart';
import '../services/mock_data.dart';

// App preferences (onboarded + points)
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

// List of apps
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
}

final appsProvider = StateNotifierProvider<AppsNotifier, List<BlockableApp>>((
  ref,
) {
  return AppsNotifier();
});

// Tasks
class TasksNotifier extends StateNotifier<List<TaskItem>> {
  TasksNotifier() : super(mockTasks());

  void complete(String id) {
    state = [
      for (final t in state) t.id == id ? t.copyWith(completed: true) : t,
    ];
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskItem>>((
  ref,
) {
  return TasksNotifier();
});
