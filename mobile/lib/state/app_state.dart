import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';

import '../environment/environment.dart';
import '../models/models.dart';
import '../models/task.dart';
import '../services/api/user_api.dart';
import '../services/api/task_api.dart';

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
            icon: app.icon, // default placeholder
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
/// =======================
/// Tasks (API-backed)
/// =======================
class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskApi api;
  final Ref ref;

  TasksNotifier(this.ref, this.api) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await api.getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void complete(String uid) {
    state.whenData((tasks) {
      final updated = [for (final t in tasks) t.uid == uid ? t.copyWith() : t];
      state = AsyncValue.data(updated);
    });
  }
}

final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>((ref) {
      final api = TaskApi(env['base']!); // 🔥 set base URL
      return TasksNotifier(ref, api);
    });

/// =======================
/// Transactions
/// =======================
class TransactionsNotifier
    extends StateNotifier<AsyncValue<List<PointTransaction>>> {
  final PointTransactionApi api;
  final Ref ref;

  TransactionsNotifier(this.ref, this.api, String userUid)
    : super(const AsyncValue<List<PointTransaction>>.loading()) {
    loadPointTransactions(userUid);
  }

  Future<void> loadPointTransactions(String userUid) async {
    state = const AsyncValue.loading();
    try {
      api
          .getAllTransactions(userUid)
          .then((t) => {state = AsyncValue.data(t)})
          .onError(
            (error, stackTrace) => {
              state = AsyncValue.error(error!, stackTrace),
            },
          );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void complete(String uid) {
    state.whenData((transactions) {
      final updated = [
        for (final t in transactions) t.uid == uid ? t.copyWith() : t,
      ];
      state = AsyncValue.data(updated);
    });
  }
}

final transactionsProvider =
    StateNotifierProvider.family<
      TransactionsNotifier,
      AsyncValue<List<PointTransaction>>,
      String
    >((ref, userUid) {
      final api = PointTransactionApi(env['base']!);
      return TransactionsNotifier(ref, api, userUid);
    });
