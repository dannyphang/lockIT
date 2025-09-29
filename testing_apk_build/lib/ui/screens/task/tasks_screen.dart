import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/task_card.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Earn points')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConst.spacing),
        itemCount: tasks.value?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(height: AppConst.spacing),
        itemBuilder: (_, i) => TaskCard(task: tasks.value?[i]),
      ),
    );
  }
}
