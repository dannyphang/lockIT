import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models.dart';
import '../../../../state/app_state.dart';

class AppChip extends ConsumerWidget {
  final BlockableApp app;
  const AppChip({super.key, required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final allowed = app.allowedUntil > now;

    return InkWell(
      onTap: () async {
        if (allowed) return; // already allowed
        final ok = ref.read(appPrefsProvider.notifier).spendPoints(1);
        if (ok) {
          ref
              .read(appsProvider.notifier)
              .allowFor(app.package, const Duration(minutes: 5));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Allowed ${app.name} for 5 minutes')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not enough points. Complete tasks to earn more.'),
            ),
          );
        }
      },
      child: Chip(
        avatar: const CircleAvatar(child: Icon(Icons.apps_rounded)),
        label: Text(app.name + (allowed ? ' (allowed)' : '')),
      ),
    );
  }
}
