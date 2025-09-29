import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/models.dart';
import '../../../../state/app_state.dart';
import '../../../shared/constant/style_constant.dart';

class AppChip extends ConsumerWidget {
  final BlockableApp app;
  const AppChip({super.key, required this.app});

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final allowed = app.allowedUntil > now;

    return InkWell(
      borderRadius: BorderRadius.circular(AppConst.circleSize * 2),
      onTap: () {
        if (allowed) return; // already allowed

        final ok = ref.read(appPrefsProvider.notifier).spendPoints(1);
        if (ok) {
          ref
              .read(appsProvider.notifier)
              .allowTemporarily(app.package, const Duration(minutes: 5));
          _showSnackBar(context, 'Allowed ${app.name} for 5 minutes');
        } else {
          _showSnackBar(
            context,
            'Not enough points. Complete tasks to earn more.',
          );
        }
      },
      child: Chip(
        avatar: CircleAvatar(
          radius: AppConst.circleSize,
          backgroundColor: allowed
              ? Colors.green
              : AppConst.primaryColor.withOpacity(0.2),
          child: SvgPicture.asset(
            AppConst.defaultAppIcon, // centralize path
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        label: Text(
          app.name + (allowed ? ' (allowed)' : ''),
          style: TextStyle(
            color: allowed ? Colors.green : null,
            fontWeight: allowed ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: allowed
            ? Colors.green.withOpacity(0.15)
            : Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
