import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_api.dart';
import '../environment/environment.dart';

final baseUrlProvider = Provider<String>(
  (_) => env['base']!,
); // change for your env
final authTokenProvider = StateProvider<String?>(
  (_) => null,
); // set after login

final userApiProvider = Provider<UserApi>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  return UserApi(baseUrl);
});
