import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart'; // if you use SVG assets

class AppPickerScreen extends ConsumerWidget {
  const AppPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose apps to block')),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConst.spacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Failed to load apps:\n$err', textAlign: TextAlign.center),
                const SizedBox(height: AppConst.spacing),
                FilledButton(
                  onPressed: () => ref
                      .read(appsProvider.notifier)
                      .loadFromDevice(includeSystemApps: false),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (apps) {
          if (apps.isEmpty) {
            return const Center(child: Text("No apps found"));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(appsProvider.notifier)
                  .loadFromDevice(includeSystemApps: false);
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConst.spacing),
              itemCount: apps.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final a = apps[i];
                return SwitchListTile(
                  title: Text(a.name),
                  subtitle: Text(a.package),
                  value: a.blocked,
                  onChanged: (v) =>
                      ref.read(appsProvider.notifier).setBlocked(a.package, v),

                  // ✅ Avatar supports both PNG and SVG
                  secondary: CircleAvatar(
                    backgroundImage: MemoryImage(a.icon!),
                  ),

                  // Theming
                  trackOutlineColor: WidgetStatePropertyAll(
                    AppConst.primaryColor,
                  ),
                  inactiveTrackColor: AppConst.secondaryTextColor,
                  activeThumbColor: AppConst.primaryColor,
                  inactiveThumbColor: AppConst.disableColor,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
