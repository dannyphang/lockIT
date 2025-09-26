import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../shared/constant/style_constant.dart';

import 'package:intl/intl.dart';

class RecentTile extends ConsumerWidget {
  const RecentTile({super.key, required this.transaction});

  final PointTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(AppConst.spacing),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  transaction.typeId == 1
                      ? 'lib/assets/icons/list.svg'
                      : 'lib/assets/icons/th-large.svg',
                  colorFilter: transaction.typeId == 1
                      ? const ColorFilter.mode(Colors.green, BlendMode.srcIn)
                      : const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
                const SizedBox(width: AppConst.spacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(fontSize: AppConst.fontH4),
                    ),
                    Text(
                      DateFormat(
                        'hh:mm, dd MMM yyyy',
                      ).format(transaction.createdDate!),
                      style: const TextStyle(
                        fontSize: AppConst.fontH5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppConst.spacing),
            Text(
              (transaction.typeId == 1 ? '+' : '-') +
                  transaction.amount.toString(),
              style: TextStyle(
                fontSize: AppConst.fontH4,
                fontWeight: FontWeight.bold,
                color: transaction.typeId == 1 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      onTap: () => {
        // TODO: open transaction details
      },
    );
  }
}
