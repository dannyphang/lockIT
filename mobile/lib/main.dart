import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/app_state.dart';
import 'state/user_state.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home/main_screen.dart';
import 'ui/screens/home/onboarding_screen.dart';
import 'ui/screens/profile/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: LockGateApp()));
}

class LockGateApp extends ConsumerWidget {
  const LockGateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPrefsProvider);
    final onboarded = prefs.onboarded;

    // // If not onboarded, go straight to onboarding.
    // if (!onboarded) {
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'LockGate',
    //     theme: AppTheme.light(),
    //     // darkTheme: AppTheme.dark(),
    //     // themeMode: ThemeMode.system,
    //     home: const OnboardingScreen(),
    //   );
    // }

    // Already onboarded → check user auth state.
    final userAsync = ref.watch(userProvider);
    print(userAsync);
    final Widget home = userAsync.when(
      loading: () => const SplashScreen(),
      error: (e, _) => const LoginScreen(), // if loading user fails, show login
      data: (user) => user == null
          ? const LoginScreen() // signed out → login
          : const MainScreen(), // signed in → main
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LockGate',
      theme: AppTheme.light(),
      // darkTheme: AppTheme.dark(),
      // themeMode: ThemeMode.system,
      home: home,
    );
  }
}

/// A tiny splash used while providers are loading.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 12),
            Text('Preparing LockGate…', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
