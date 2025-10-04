import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_it/environment/environment.dart';
import 'package:lock_it/models/task.dart';
import 'package:lock_it/services/api/task_api.dart';
import 'package:lock_it/state/user_state.dart';
import 'package:lock_it/ui/shared/constant/style_constant.dart';
import 'package:lock_it/ui/shared/widgets/tag.dart';
import 'package:logger/web.dart';

class TaskCard extends ConsumerWidget {
  final Task? task;
  TaskCard({super.key, required this.task});

  final taskApiProvider = Provider<TaskApi>((ref) {
    return TaskApi(env['base']!); // make sure env['base'] exists
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authTokenProvider);

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
                  onPressed: () => {
                    if (task != null && token != null)
                      {
                        Logger().d(token),
                        Logger().d(task?.uid),
                        ref.read(taskApiProvider).completedTask(task!, token),
                      },
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('Complete'),
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
