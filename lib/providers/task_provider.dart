import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task_model.dart';
import '../repositories/task_repository.dart';
import '../view_models/sort_viewmodel.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final tasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final preferences = ref.watch(preferencesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final filterPriority = ref.watch(filterPriorityProvider);
  final tasks = await repository.getTasks();

  if (preferences.sortOrder == 'date') {
    tasks.sort((a, b) => a.completionAt!.compareTo(b.completionAt!)); // Sort by date (ascending order)
  }

   if (preferences.sortOrder == 'priority') {
    tasks.sort((a, b) {
      return priorityValue(b.priority!).compareTo(priorityValue(a.priority!));
    });
  }
  final filteredTasks = tasks.where((task) {
    final matchesQuery = task.title?.toLowerCase().contains(searchQuery.toLowerCase())??false;
    final matchesPriority = filterPriority == null || task.priority == filterPriority;
    return matchesQuery && matchesPriority;
  }).toList();
  return filteredTasks;
});

final selectedTaskIdProvider = StateProvider<int?>((ref) => null);
final completeDateProvider = StateProvider<DateTime?>((ref) => null);
final priorityProvider = StateProvider<String>((ref) => 'Low');
final searchQueryProvider = StateProvider<String>((ref) => '');
final filterPriorityProvider = StateProvider<String?>((ref) => null);


int priorityValue(String priority) {
  switch (priority) {
    case "High":
      return 3;
    case "Medium":
      return 2;
    case "Low":
      return 1;
    default:
      return 0;
  }
}