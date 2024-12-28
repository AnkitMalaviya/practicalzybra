import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';

import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;

  TaskViewModel(this._repository) : super([]);

  Future<void> fetchTasks() async {
    state = await _repository.getTasks();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.updateTask(task);
    await fetchTasks();
  }
  Future<void> deleteTask(TaskModel? task) async {
    await _repository.deleteTask(task);
    await fetchTasks();
  }
}



final taskViewModelProvider =
StateNotifierProvider<TaskViewModel, List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskViewModel(repository);
});

