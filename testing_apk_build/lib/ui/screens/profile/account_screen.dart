import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/account_action.dart';
import 'widgets/profile_info.dart';
import 'widgets/recent_activity.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppConst.spacing),
        children: [
          const ProfileInfo(),
          const SizedBox(height: AppConst.spacing),
          const RecentActivity(),
          const AccountAction(),
        ],
      ),
    );
  }
}
