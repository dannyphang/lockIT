import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/token_storage.dart';
import 'state/user_state.dart';
import 'ui/auth/auth_gate.dart';

void main() {
  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});
  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final stored = await TokenStorage().readAccess();
    if (mounted) {
      ref.read(authTokenProvider.notifier).state = stored;
      // Optional: prefetch user now
      if (stored != null && stored.isNotEmpty) {
        await ref.read(userProvider.notifier).fetch();
      }
      setState(() => _hydrated = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hydrated) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return const MaterialApp(home: AuthGate());
  }
}
