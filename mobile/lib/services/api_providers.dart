import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../environment/environment.dart';
import '../services/auth_client.dart';
import '../state/user_state.dart'; // for authTokenProvider
import '../services/token_storage.dart';

/// Base URL (e.g., http://10.0.2.2:3000 for Android emulator)
final baseUrlProvider = Provider<String>((_) => env['base']!);

/// HTTP client that injects Authorization: Bearer <token>
final httpClientProvider = Provider<http.Client>((ref) {
  return AuthClient(http.Client(), () async {
    // Prefer in-memory first; fallback to disk (survive restarts)
    final inMem = ref.read(authTokenProvider);
    if (inMem != null && inMem.isNotEmpty) return inMem;
    return TokenStorage().readAccess();
  });
});
