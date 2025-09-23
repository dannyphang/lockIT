import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/app_state.dart';
import '../../../state/nav_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/points_header.dart';
import '../app/widgets/app_chip.dart';
import '../setting/rules_screen.dart';
import '../setting/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LockGate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.rule_folder_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RulesScreen()),
            ),
            tooltip: 'Rules',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConst.spacing),
        children: [
          const PointsHeader(),
          const SizedBox(height: AppConst.spacing),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConst.spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Blocked apps',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            ref.read(currentTabProvider.notifier).state = 1,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Add',
                          selectionColor: AppConst.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConst.spacingS),
                  Wrap(
                    spacing: AppConst.spacingS,
                    runSpacing: AppConst.spacingS,
                    children: apps
                        .where((a) => a.blocked)
                        .map((a) => AppChip(app: a))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConst.spacing),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Earn points'),
              subtitle: const Text('Complete quick tasks to unlock apps'),
              trailing: FilledButton(
                onPressed: () =>
                    ref.read(currentTabProvider.notifier).state = 2,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConst.radius),
                  ),
                  backgroundColor: AppConst.primaryColor,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
          const SizedBox(height: AppConst.spacing),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Start focus session'),
              subtitle: const Text('Block everything except whitelisted apps'),
              trailing: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Focus session demo started (UI only).'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConst.radius),
                  ),
                ),
                child: const Text('Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
