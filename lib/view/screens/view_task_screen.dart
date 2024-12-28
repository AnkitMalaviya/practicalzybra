import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/responsive/responsive.dart';
import '../../model/task_model.dart';
import '../../providers/single_task_provider.dart';
import '../../providers/task_provider.dart';
import '../../view_models/task_view_model.dart';
import 'add_update_task_screen.dart';


class ViewTaskScreen extends ConsumerWidget {
  final int? taskId;

  const ViewTaskScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(singleTaskProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: Responsive.isTablet(context)?  Text(taskAsyncValue.value?.title??""):Text('View Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),

            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddUpdateTaskScreen(task: taskAsyncValue.value);
                },
              ).then((value){
                ref.invalidate(singleTaskProvider);
              });

            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),

            onPressed: () {
              ref.read(taskViewModelProvider.notifier).deleteTask(taskAsyncValue.value);
              ref.invalidate(tasksProvider);
              Navigator.of(context).pop();

            },
          )
        ],
      ),
      body: taskAsyncValue.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  task.title??"",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description??"",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Priority:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("${task?.priority ?? " "}"),
                const SizedBox(height: 16),
                const Text(
                  'Completion Date:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("${DateFormat('MM/dd/yyyy').format(task.completionAt!)}"),
                const SizedBox(height: 16),
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Checkbox(
                      value: task.isComplete,
                      onChanged: (value) {
                        if (value != null) {

                          final updatedTask = task.copyWith(isComplete: value);

                          ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
                          ref.invalidate(tasksProvider);
                          ref.invalidate(singleTaskProvider);
                        }
                      },
                    ),
                    Text(
                      task.isComplete ? 'Completed' : 'Pending',
                      style: TextStyle(
                        fontSize: 16,
                        color: task.isComplete ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
