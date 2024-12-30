import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zybrapracticaltask/core/responsive/responsive.dart';
import 'package:zybrapracticaltask/view/screens/add_update_task_screen.dart';
import 'package:zybrapracticaltask/view/screens/view_task_screen.dart';
import '../../model/task_model.dart';
import '../../providers/task_provider.dart';
import '../../view_models/sort_viewmodel.dart';
import '../../view_models/task_view_model.dart';
import '../../view_models/theme_viewmodel.dart';
import '../widgets/task_item_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksProvider);
    final themeMode = ref.watch(themeProvider);
    final selectedTaskId = ref.watch(selectedTaskIdProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final searchQuery = ref.watch(searchQueryProvider);
    final filterPriority = ref.watch(filterPriorityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [

          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ref.read(preferencesProvider.notifier).updateSortOrder(value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'date',
                  child: Text('Sort by Date'),
                ),
                const PopupMenuItem<String>(
                  value: 'priority',
                  child: Text('Sort by Priority'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                labelText: 'Search Tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Filter dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String?>(
              value: filterPriority,
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium Priority')),
                DropdownMenuItem(value: 'High', child: Text('High Priority')),
              ],
              onChanged: (value) {
                ref.read(filterPriorityProvider.notifier).state = value;
              },
              isExpanded: true,
              hint: const Text('Filter by Priority'),
            ),
          ),

          Expanded(
            child: tasksAsyncValue.when(
              data: (tasks) {
                print("dfajfhgsfd");

                if (Responsive.isTablet(context)) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: taskListView(tasks, ref),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        flex: 3,
                        child: ViewTaskScreen(taskId: selectedTaskId),
                      ),
                    ],
                  );
                }
                return taskListView(tasks, ref);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUpdateTaskScreen();
            },
          );

        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView taskListView(List<TaskModel> tasks, WidgetRef ref) {
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
                }
              },
              onTap: () {
                if (Responsive.isTablet(context)) {
                  ref.invalidate(selectedTaskIdProvider);
                  ref.read(selectedTaskIdProvider.notifier).state = task.id;
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewTaskScreen(
                        taskId: task.id,
                      ),
                    ),
                  );
                }
              }),
        );
      },
    );
  }
}
