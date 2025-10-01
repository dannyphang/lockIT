import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../state/user_state.dart';
import '../../../../theme/app_theme.dart';
import '../../../shared/constant/style_constant.dart';

class PointsCircle extends ConsumerWidget {
  const PointsCircle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(userProvider).value?.scorePoint ?? 0;

    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(width: 3, color: AppTheme.light().primaryColor),
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 2),
              color: Colors.black12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$points',
            style: const TextStyle(
              color: AppConst.primaryColor,
              fontSize: AppConst.fontH2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
