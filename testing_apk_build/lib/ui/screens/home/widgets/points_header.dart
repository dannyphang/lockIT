import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../state/app_state.dart';
import '../../../../state/nav_state.dart';
import '../../../shared/constant/style_constant.dart';

class PointsHeader extends ConsumerWidget {
  const PointsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(appPrefsProvider).points;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacing),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppConst.circleSize,
              backgroundColor: AppConst.primaryColor,
              child: Text(
                '$points',
                style: const TextStyle(
                  fontSize: AppConst.fontH2,
                  fontWeight: FontWeight.bold,
                  color: AppConst.secondaryTextColor,
                ),
              ),
            ),
            const SizedBox(width: AppConst.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Your points',
                    style: TextStyle(
                      fontSize: AppConst.fontH4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppConst.spacingXS),
                  Text('Spend points to unlock apps for a short time'),
                ],
              ),
            ),
            const SizedBox(width: AppConst.spacing),
            FilledButton.icon(
              onPressed: () => ref.read(currentTabProvider.notifier).state = 2,
              icon: SvgPicture.asset(
                "assets/icons/plus.svg",
                colorFilter: ColorFilter.mode(
                  AppConst.secondaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text('Earn'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConst.radius),
                ),
                backgroundColor: AppConst.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
