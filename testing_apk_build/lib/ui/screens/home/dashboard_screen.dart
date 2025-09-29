import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../models/models.dart';
import '../../../state/app_state.dart';
import '../../../state/nav_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/points_header.dart';
import '../app/widgets/app_chip.dart';
import '../setting/rules_screen.dart';
import '../setting/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LockGate'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/plus.svg",
              color: AppConst.primaryColor,
            ),
            tooltip: 'Rules',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RulesScreen()),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/cog.svg"),
            tooltip: 'Settings',
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
          _BlockedAppsCard(ref: ref, apps: apps.value ?? []),
          const SizedBox(height: AppConst.spacing),
          _EarnPointsCard(ref: ref),
          const SizedBox(height: AppConst.spacing),
          _FocusSessionCard(
            onStart: () {
              _showSnackBar(context, 'Focus session demo started (UI only).');
            },
          ),
        ],
      ),
    );
  }
}

class _BlockedAppsCard extends StatelessWidget {
  final WidgetRef ref;
  final List<BlockableApp> apps;
  const _BlockedAppsCard({required this.ref, required this.apps});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  icon: SvgPicture.asset(
                    "assets/icons/plus.svg",
                    color: AppConst.primaryColor,
                  ),
                  label: const Text('Add'),
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
    );
  }
}

class _EarnPointsCard extends StatelessWidget {
  final WidgetRef ref;
  const _EarnPointsCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SvgPicture.asset("assets/icons/database.svg"),
        title: const Text('Earn points'),
        subtitle: const Text('Complete quick tasks to unlock apps'),
        trailing: FilledButton(
          onPressed: () => ref.read(currentTabProvider.notifier).state = 2,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConst.radius),
            ),
            backgroundColor: AppConst.primaryColor,
          ),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

class _FocusSessionCard extends StatelessWidget {
  final VoidCallback onStart;
  const _FocusSessionCard({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SvgPicture.asset("assets/icons/stopwatch.svg"),
        title: const Text('Start focus session'),
        subtitle: const Text('Block everything except whitelisted apps'),
        trailing: OutlinedButton(
          onPressed: onStart,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConst.radius),
            ),
          ),
          child: const Text('Start'),
        ),
      ),
    );
  }
}
