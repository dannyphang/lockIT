import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lock_it/environment/environment.dart';
import 'package:lock_it/models/task.dart';
import 'package:lock_it/services/api/task_api.dart';
import 'package:lock_it/state/app_state.dart';
import 'package:lock_it/state/user_state.dart';
import 'package:lock_it/ui/shared/constant/style_constant.dart';
import 'package:lock_it/ui/shared/widgets/tag.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
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
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text('+${task.rewardPoints} pts')),
              ],
            ),
            const SizedBox(height: AppConst.spacing),
            Text(task.description ?? ''),
            const SizedBox(height: AppConst.spacing),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => {
                    if (token != null)
                      {
                        if (task.taskProgress != null &&
                            task.taskProgress?.taskStatusId == 1)
                          {
                            ref
                                .read(taskApiProvider)
                                .completeTask(task, token)
                                .then(
                                  (res) => {
                                    // load tasks again
                                    ref
                                        .read(tasksProvider.notifier)
                                        .loadTasks(),
                                    // load user
                                    ref.read(userProvider.notifier).fetch(),
                                  },
                                ),
                          }
                        else if (task.taskProgress == null)
                          {
                            ref
                                .read(taskApiProvider)
                                .selectTask(task, token)
                                .then(
                                  (res) => {
                                    // set res to task
                                    ref
                                        .read(tasksProvider.notifier)
                                        .loadTasks(),
                                  },
                                ),
                          },
                      },
                  },
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: task.taskProgress?.taskStatusId == 2
                        ? AppConst.secondaryTextColor
                        : AppConst.primaryColor,
                  ),
                  label: Text(
                    task.taskProgress == null
                        ? 'Select'
                        : task.taskProgress?.taskStatusId == 1
                        ? 'Complete'
                        : 'Completed',
                    style: TextStyle(
                      color: task.taskProgress?.taskStatusId == 2
                          ? AppConst.secondaryTextColor
                          : AppConst.primaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: task.taskProgress?.taskStatusId == 2
                        ? AppConst.disableColor
                        : null,
                  ),
                ),
                const SizedBox(width: AppConst.spacing),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                ),
                const SizedBox(width: AppConst.spacing),
                TagWidget(textLabel: task.type),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
