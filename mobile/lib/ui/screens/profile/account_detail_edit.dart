import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';
import '../../../state/user_state.dart';

class AccountDetail extends ConsumerStatefulWidget {
  const AccountDetail({super.key});
  @override
  ConsumerState<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends ConsumerState<AccountDetail> {
  final controllers = AccountFormControllers();
  bool _prefilled = false; // prevent repeated overwrites

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ allowed: listen inside build
    ref.listen<AsyncValue<User?>>(
      userProvider as ProviderListenable<AsyncValue<User?>>,
      (prev, next) {
        final user = next.valueOrNull;
        if (user == null) return;
        if (_prefilled && prev?.valueOrNull?.uid == user.uid) return;

        controllers.username.text = user.username;
        controllers.displayName.text = user.displayName;
        controllers.email.text = user.email;
        controllers.preferredLanguage ??= 'en';

        _prefilled = true;
        // no setState() needed for controller text assignments
      },
    );

    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account Details')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) {
          // ... your existing Form/UI here ...
          return /* your widget tree */;
        },
      ),
    );
  }
}

class AccountFormControllers {
  final username = TextEditingController();
  final email = TextEditingController();
  final displayName = TextEditingController();
  final password = TextEditingController();
  String? preferredLanguage = "en";

  void dispose() {
    username.dispose();
    email.dispose();
    displayName.dispose();
    password.dispose();
  }

  Map<String, String?> value() => {
    "username": username.text,
    "email": email.text,
    "displayName": displayName.text,
    "preferredLanguage": preferredLanguage,
  };
}
