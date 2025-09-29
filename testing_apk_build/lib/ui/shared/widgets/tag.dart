import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/style_constant.dart';

class TagWidget extends ConsumerWidget {
  final String textLabel;
  const TagWidget({super.key, required this.textLabel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppConst.primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        textLabel.toUpperCase(),
        style: const TextStyle(
          color: AppConst.secondaryTextColor,
          fontSize: AppConst.fontS,
        ),
      ),
    );
  }
}
