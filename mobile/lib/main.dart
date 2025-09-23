import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/ui/screens/home/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/app_state.dart';
import 'ui/screens/home/onboarding_screen.dart';

void main() {
  runApp(const ProviderScope(child: LockGateApp()));
}

class LockGateApp extends ConsumerWidget {
  const LockGateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(appPrefsProvider).onboarded;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LockGate',
      theme: AppTheme.light(),
      // darkTheme: AppTheme.dark(),
      // themeMode: ThemeMode.system,
      home: onboarded ? const MainScreen() : const OnboardingScreen(),
    );
  }
}
