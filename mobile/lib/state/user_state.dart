// lib/core/state/user_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import 'user_http.dart'; // exposes httpUserRepositoryProvider

// 1) Interface
abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<User> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
  });
  Future<User> setPoints(int points);
  Future<User> addPoints(int delta);
}

// 2) Repo provider (HTTP repo)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ref.watch(httpUserRepositoryProvider);
});

// 3) Notifier (DEFINE IT here or import it)
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  UserNotifier(this._repo) : super(const AsyncValue.loading());

  final UserRepository _repo;

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    final previous = state;
    final current = state.value;
    if (current == null) {
      await fetch();
      return;
    }

    // optimistic
    final optimistic = current.copyWith(
      displayName: displayName ?? current.displayName,
      email: email ?? current.email,
      avatarUrl: avatarUrl ?? current.avatarUrl,
      modifiedDate: DateTime.now(),
    );
    state = AsyncValue.data(optimistic);

    try {
      final updated = await _repo.updateProfile(
        displayName: displayName,
        email: email,
        avatarUrl: avatarUrl,
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = previous; // rollback
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setPoints(int points) async {
    try {
      final updated = await _repo.setPoints(points);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPoints(int delta) async {
    try {
      final updated = await _repo.addPoints(delta);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// 4) Provider using the notifier type
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((
  ref,
) {
  final repo = ref.watch(userRepositoryProvider);
  final notifier = UserNotifier(repo);
  Future.microtask(() => notifier.fetch());
  return notifier;
});
