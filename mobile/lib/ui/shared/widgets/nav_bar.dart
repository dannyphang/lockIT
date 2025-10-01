import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constant/style_constant.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConst.spacingL,
        vertical: AppConst.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppConst.primaryColor,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(50),
        //   topRight: Radius.circular(50),
        // ),
      ),
      child: Row(
        children: [
          navItem(
            "Home",
            "assets/icons/home.svg",
            pageIndex == 0,
            onTap: () => onTap(0),
          ),
          navItem(
            "Apps",
            "assets/icons/th-large.svg",
            pageIndex == 1,
            onTap: () => onTap(1),
          ),
          navItem(
            "Tasks",
            "assets/icons/database.svg",
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            "User",
            "assets/icons/user.svg",
            pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

Widget navItem(
  String navName,
  String svgPath,
  bool selected, {
  Function()? onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: selected
          ? TextButton.icon(
              onPressed: onTap,
              label: Text(navName, style: const TextStyle(color: Colors.white)),
              icon: SvgPicture.asset(
                svgPath,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConst.radiusM),
                ),
                backgroundColor: AppConst.secondaryTextColor.withValues(
                  alpha: 0.2,
                ),
                foregroundColor: AppConst.secondaryTextColor,
              ),
            )
          : SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.4),
                BlendMode.srcIn,
              ),
            ),
    ),
  );
}
