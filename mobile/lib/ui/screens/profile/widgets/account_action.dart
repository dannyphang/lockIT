import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constant/style_constant.dart';

class AccountAction extends ConsumerWidget {
  const AccountAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppConst.spacingXS,
          children: [
            Text(
              "Account Actions",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: AppConst.fontH3,
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset("lib/assets/icons/sign-out.svg"),
              title: const Text('Sign Out'),
              onTap: () {
                // TODO: Implement sign out functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
