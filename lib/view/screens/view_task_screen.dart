import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/responsive/responsive.dart';
import '../../providers/single_task_provider.dart';
import '../../providers/task_provider.dart';
import '../../view_models/task_view_model.dart';
import 'add_update_task_screen.dart';

class ViewTaskScreen extends ConsumerWidget {
  const ViewTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(singleTaskProvider);
    print("fjsdfgdssdf");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: taskAsyncValue.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found.'));
          }

          return Scaffold(
            appBar: Responsive.isMobile(context)
                ? AppBar(
              title: Text('Task View'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddUpdateTaskScreen(task: taskAsyncValue.value);
                      },
                    ).then((value) {
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
            )
                : null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (!Responsive.isMobile(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          taskAsyncValue.value?.title ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddUpdateTaskScreen(task: taskAsyncValue.value);
                                  },
                                ).then((value) {
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
                      ],
                    ),
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(seconds: 5),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: Padding(
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
                            task.title ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Description:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.description ?? "",
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
                          Row(
                            children: [
                              Text("${DateFormat('MM/dd/yyyy').format(task.completionAt!)}"),
                              const SizedBox(width: 8),
                              Text(DateFormat('hh:mm').format(task.completionAt!.toLocal())),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Status:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              key: ValueKey<bool>(task.isComplete),
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
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
