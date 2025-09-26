// lib/core/state/user_repository_http.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_providers.dart';
import '../services/user_api.dart';
import 'user_state.dart' show UserRepository;

class HttpUserRepository implements UserRepository {
  final UserApi _api;
  final String? _token;
  HttpUserRepository(this._api, this._token);

  String get _t {
    if (_token == null || _token.isEmpty) {
      throw Exception('Missing auth token');
    }
    return _token;
  }

  @override
  Future<User> getCurrentUser() async {
    // If your backend doesn’t have /user/me, you can call fetchUserById instead.
    final json = await _api.fetchMe(_t);
    return User.fromJson(json);
  }

  @override
  Future<User> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
  }) async {
    final json = await _api.updateMe(
      _t,
      displayName: displayName,
      email: email,
      avatarUrl: avatarUrl,
    );
    return User.fromJson(json);
  }

  @override
  Future<User> setPoints(int points) async {
    // Implement if you add this endpoint; otherwise remove from interface.
    throw UnimplementedError('setPoints not implemented on API repo');
  }

  @override
  Future<User> addPoints(int delta) async {
    // Implement if you add this endpoint; otherwise remove from interface.
    throw UnimplementedError('addPoints not implemented on API repo');
  }
}

// Expose the HTTP repo as a provider
final httpUserRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(userApiProvider);
  final token = ref.watch(authTokenProvider);
  return HttpUserRepository(api, token);
});
