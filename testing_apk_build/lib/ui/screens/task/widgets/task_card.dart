import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/models.dart';
import '../../../../models/task.dart';
import '../../../shared/constant/style_constant.dart';
import '../../../shared/widgets/tag.dart';

class TaskCard extends ConsumerWidget {
  final Task? task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConst.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task?.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text('+${task?.rewardPoints} pts')),
              ],
            ),
            const SizedBox(height: AppConst.spacing),
            Text(task?.description ?? ''),
            const SizedBox(height: AppConst.spacing),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('???'),
                ),
                const SizedBox(width: AppConst.spacing),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                ),
                const SizedBox(width: AppConst.spacing),
                TagWidget(textLabel: task?.type ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
