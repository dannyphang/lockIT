import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../state/app_state.dart';
import '../../../../state/nav_state.dart';
import '../../../shared/constant/style_constant.dart';
import '../account_detail_edit.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(appPrefsProvider).points;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacingL),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: AppConst.circleSize,
                  child: SvgPicture.asset(
                    "assets/icons/user.svg",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: AppConst.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: AppConst.fontH4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('email_123@email.com'),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AccountDetail()),
                  ),
                  icon: SvgPicture.asset("assets/icons/pencil.svg"),
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
                          SvgPicture.asset(
                            "assets/icons/star.svg",
                            color: AppConst.primaryColor,
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
                        icon: SvgPicture.asset(
                          "assets/icons/plus.svg",
                          color: AppConst.secondaryTextColor,
                        ),
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
