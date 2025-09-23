import 'package:flutter/material.dart';
import 'package:flutter_application_1/state/nav_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../state/app_state.dart';
import '../../../shared/constant/style_constant.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(appPrefsProvider).points;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacingS),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: AppConst.circleSize,
                  child: Icon(Icons.person_2_rounded, size: 40),
                ),
                const SizedBox(width: AppConst.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('email_123@email.com'),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(currentTabProvider.notifier).state = 2,
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConst.radius),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConst.spacing),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(AppConst.radius),
                color: Colors.grey.shade100,
              ),
              padding: const EdgeInsets.all(AppConst.spacing),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            color: AppConst.primaryColor,
                            size: AppConst.circleSizeS,
                          ),
                          const SizedBox(width: AppConst.spacingS),
                          Text(
                            "$points",
                            style: const TextStyle(fontSize: AppConst.fontH3),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () =>
                            ref.read(currentTabProvider.notifier).state = 2,
                        icon: const Icon(Icons.add),
                        label: const Text('Earn'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConst.radius,
                            ),
                          ),
                          backgroundColor: AppConst.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConst.spacing),
                  const Text(
                    'User points to temporily unlock apps. Points can be earned by completing offers.',
                    style: TextStyle(fontSize: AppConst.font),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
