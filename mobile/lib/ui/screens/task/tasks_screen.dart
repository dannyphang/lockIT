import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/task_card.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Earn points')),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConst.spacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Failed to load apps:\n$err', textAlign: TextAlign.center),
                const SizedBox(height: AppConst.spacing),
                FilledButton(
                  onPressed: () => ref
                      .read(appsProvider.notifier)
                      .loadFromDevice(includeSystemApps: false),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(tasksProvider.notifier).loadTasks();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppConst.spacing),
              itemCount: tasks.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppConst.spacing),
              itemBuilder: (_, i) => TaskCard(task: tasks[i]),
            ),
          );
        },
      ),
    );
  }
}
