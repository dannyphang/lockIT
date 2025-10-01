import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/token_repository.dart';
import '../../state/user_state.dart';
import '../screens/home/main_screen.dart';
import '../screens/profile/login_screen.dart';

class AuthGate extends ConsumerWidget {
  AuthGate({super.key});

  final tokenLoaderProvider = FutureProvider<String?>((ref) async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.readAccess();

    // Save it into the in-memory provider too
    ref.read(authTokenProvider.notifier).state = token;
    return token;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenLoader = ref.watch(tokenLoaderProvider);

    return tokenLoader.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const LoginScreen(),
      data: (token) {
        final userAsync = ref.watch(userProvider);

        if (token == null || token.isEmpty) {
          return const LoginScreen();
        }

        // If user not loaded, trigger fetch
        if (userAsync.value == null && userAsync is! AsyncLoading) {
          Future.microtask(() => ref.read(userProvider.notifier).fetch());
        }

        if (userAsync is AsyncLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (userAsync.hasError) {
          return const LoginScreen();
        }
        final user = userAsync.value;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const MainScreen();
      },
    );
  }
}
