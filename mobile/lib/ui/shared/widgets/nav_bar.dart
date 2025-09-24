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
      height: 80,
      decoration: BoxDecoration(
        color: AppConst.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Row(
        children: [
          navItem(
            "lib/assets/icons/home.svg",
            pageIndex == 0,
            onTap: () => onTap(0),
          ),
          navItem(
            "lib/assets/icons/th-large.svg",
            pageIndex == 1,
            onTap: () => onTap(1),
          ),
          navItem(
            "lib/assets/icons/database.svg",
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            "lib/assets/icons/user.svg",
            pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

Widget navItem(String svgPath, bool selected, {Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        svgPath,
        color: selected ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    ),
  );
}
