import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../services/api_providers.dart';

/// Holds only the access token in memory (fast lookups).
final authTokenProvider = StateProvider<String?>((_) => null);

class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? role;

  AppUser({required this.id, required this.email, this.name, this.role});

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id']?.toString() ?? j['userId']?.toString() ?? '',
    email: j['email'] ?? '',
    name: j['name'],
    role: j['role'],
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
      final res = await client.get(Uri.parse('$base/user/me'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        state = AsyncValue.data(AppUser.fromJson(data));
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
