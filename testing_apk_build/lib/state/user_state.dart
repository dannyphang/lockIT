import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_providers.dart';

/// Holds only the access token in memory (fast lookups).
final authTokenProvider = StateProvider<String?>((_) => null);

class AppUser {
  final String uid;
  final String authUid;
  final int id;
  final String email;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final int scorePoint;
  final String local;
  final String? timeZone;

  AppUser({
    required this.uid,
    required this.authUid,
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.avatarUrl,
    required this.scorePoint,
    required this.local,
    this.timeZone,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    uid: j['uid'] as String,
    authUid: j['authUid'] as String,
    id: j['id'] as int,
    email: j['email'] ?? '',
    displayName: j['displayName'],
    username: j['username'],
    avatarUrl: j['avatarUrl'],
    scorePoint: j['scorePoint'] as int,
    local: j['local'] ?? 'en',
    timeZone: j['timeZone'],
  );
}

class UserNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final Ref ref;
  UserNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(httpClientProvider);
      final base = ref.read(baseUrlProvider);

      final res = await client.get(Uri.parse('$base/user/auth/me'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        state = AsyncValue.data(AppUser.fromJson(data['data']));
      } else if (res.statusCode == 401) {
        // token invalid/expired
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          'Failed: ${res.statusCode}',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() => state = const AsyncValue.data(null);
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<AppUser?>>(
  (ref) => UserNotifier(ref),
);
