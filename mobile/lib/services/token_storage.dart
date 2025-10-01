import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token'; // if you implement refresh later
  final _s = const FlutterSecureStorage();

  Future<void> saveAccess(String token) =>
      _s.write(key: _kAccess, value: token);
  Future<String?> readAccess() => _s.read(key: _kAccess);
  Future<void> clearAccess() => _s.delete(key: _kAccess);

  Future<void> saveRefresh(String token) =>
      _s.write(key: _kRefresh, value: token);
  Future<String?> readRefresh() => _s.read(key: _kRefresh);
  Future<void> clearRefresh() => _s.delete(key: _kRefresh);

  Future<void> clearAll() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
  }
}
