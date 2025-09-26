import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';

import '../models/models.dart';
import '../services/mock_data.dart';

/// =======================
/// App preferences (onboarding + points)
/// =======================
class AppPrefsNotifier extends StateNotifier<AppPrefs> {
  AppPrefsNotifier() : super(const AppPrefs());

  void finishOnboarding() => state = state.copyWith(onboarded: true);

  void setPoints(int value) => state = state.copyWith(points: value);

  void addPoints(int delta) =>
      state = state.copyWith(points: state.points + delta);

  bool spendPoints(int cost) {
    if (state.points < cost) return false;
    state = state.copyWith(points: state.points - cost);
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
class AppsNotifier extends StateNotifier<AsyncValue<List<BlockableApp>>> {
  AppsNotifier() : super(const AsyncValue.loading());

  Future<void> loadFromDevice({
    bool includeSystemApps = false,
    bool includeIcons = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      final raw = await InstalledApps.getInstalledApps(
        includeSystemApps,
        includeIcons,
      );

      // 🔎 Configurable banned keywords
      const bannedKeywords = [
        // "android", // most core system apps
        "com.android",
        "cts", // test/compatibility apps
        "emulator", // emulator-only services
        "config", // config packages
        "rro", // runtime resource overlays
        "priv", // privileged CTS/system packages
      ];

      final filtered = raw.where((app) {
        final pkg = app.packageName.toLowerCase();
        final name = app.name.trim().toLowerCase();

        // Skip if empty name
        if (name.isEmpty) return false;

        // Skip if matches banned keywords
        if (bannedKeywords.any((kw) => pkg.contains(kw))) {
          return false;
        }

        return true;
      }).toList();

      filtered.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      final mapped = [
        for (final app in filtered)
          BlockableApp(
            package: app.packageName,
            name: app.name,
            icon: 'assets/icons/th-large.png', // default placeholder
            blocked: false,
            allowedUntil: 0,
          ),
      ];

      state = AsyncValue.data(mapped);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setBlocked(String pkg, bool blocked) {
    state.whenData((apps) {
      final updated = apps
          .map((a) => a.package == pkg ? a.copyWith(blocked: blocked) : a)
          .toList();
      state = AsyncValue.data(updated);
    });
  }

  void allowTemporarily(String pkg, Duration duration) {
    state.whenData((apps) {
      final until =
          DateTime.now().millisecondsSinceEpoch + duration.inMilliseconds;
      final updated = apps
          .map((a) => a.package == pkg ? a.copyWith(allowedUntil: until) : a)
          .toList();
      state = AsyncValue.data(updated);
    });
  }
}

final appsProvider =
    StateNotifierProvider<AppsNotifier, AsyncValue<List<BlockableApp>>>((ref) {
      final notifier = AppsNotifier();
      // 🔥 trigger auto-load AFTER provider is created (no freeze)
      Future.microtask(() => notifier.loadFromDevice(includeSystemApps: false));
      return notifier;
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

/// =======================
/// Transactions
/// =======================
class TransactionsNotifier extends StateNotifier<List<PointTransaction>> {
  TransactionsNotifier() : super(mockTransactions());

  void complete(String id) {
    state = [
      for (final t in state) t.uid == id ? t.copyWith(completed: true) : t,
    ];
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<PointTransaction>>((ref) {
      return TransactionsNotifier();
    });
