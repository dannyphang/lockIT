import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/shared/constant/style_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../state/app_state.dart';
import 'recent_tile.dart';

class RecentActivity extends ConsumerWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent activity',
                      style: TextStyle(
                        fontSize: AppConst.fontH3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Earning and spending',
                      style: TextStyle(fontSize: AppConst.fontH5),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => {
                    //TODO: Refresh transactions
                  },
                  icon: SvgPicture.asset("lib/assets/icons/refresh.svg"),
                ),
              ],
            ),

            if (transactions.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('No activity yet.'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConst.spacing),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final t = transactions[i];
                  return RecentTile(transaction: t);
                },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    //TODO: Navigate to all transactions screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
