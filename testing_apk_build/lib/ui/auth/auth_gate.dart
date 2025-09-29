import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/user_state.dart';
import '../screens/home/main_screen.dart';
import '../screens/profile/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authTokenProvider);
    final userAsync = ref.watch(userProvider);

    // // No token -> show login
    // if (token == null || token.isEmpty) {
    //   return const LoginScreen();
    // }

    // // If we have a token but no user loaded yet, you can kick off a fetch
    // userAsync.whenOrNull(
    //   data: (u) {
    //     // already hydrated
    //   },
    //   loading: () {},
    //   error: (_, __) {},
    // );

    // // If user state is null (not loaded yet), show a small splash
    // if (userAsync is AsyncLoading) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }
    // if (userAsync.hasError) {
    //   return const LoginScreen(); // or an error screen
    // }
    // final user = userAsync.value;
    // if (user == null) {
    //   // Not hydrated yet -> trigger fetch once
    //   Future.microtask(() => ref.read(userProvider.notifier).fetch());
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    // Authed + user loaded
    return const MainScreen();
  }
}
