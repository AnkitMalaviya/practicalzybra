import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zybrapracticaltask/view/widgets/task_item_widget.dart';

import '../../core/responsive/responsive.dart';
import '../../providers/single_task_provider.dart';
import '../../providers/task_provider.dart';
import '../../view_models/task_view_model.dart';
import '../screens/view_task_screen.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksProvider);

    return tasksAsyncValue.when(
      data: (tasks) {
        if (tasks.isNotEmpty && ref.read(selectedTaskIdProvider) == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedTaskIdProvider.notifier).state = tasks.first.id;
          });
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: ValueKey(task.id),
              background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
              onDismissed: (direction) {
                ref.read(taskViewModelProvider.notifier).deleteTask(task);
              },
              child: TaskItemWidget(
                task: task,
                onComplete: (value) {
                  if (value != null) {
                    final updatedTask = task.copyWith(isComplete: value);
                    ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
                    ref.invalidate(tasksProvider);
                    ref.invalidate(singleTaskProvider);
                  }
                },
                onTap: () {
                  ref.read(selectedTaskIdProvider.notifier).state = task.id;
                  if (Responsive.isMobile(context)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewTaskScreen()),
                    );
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
