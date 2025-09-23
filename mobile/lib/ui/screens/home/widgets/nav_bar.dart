import 'package:flutter/material.dart';
import '../../../shared/constant/style_constant.dart';

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
          navItem(Icons.home, pageIndex == 0, onTap: () => onTap(0)),
          navItem(
            Icons.app_registration_rounded,
            pageIndex == 1,
            onTap: () => onTap(1),
          ),
          navItem(
            Icons.emoji_events_rounded,
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
          navItem(
            Icons.people_alt_rounded,
            pageIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: selected ? Colors.white : Colors.white.withOpacity(0.4),
      ),
    ),
  );
}
