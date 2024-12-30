import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/notification/notification_service.dart';
import '../model/task_model.dart';

import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;

  TaskViewModel(this._repository) : super([]);

  Future<void> fetchTasks() async {
    state = await _repository.getTasks();
  }
  final _notificationService = NotificationService();
  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    if (task.completionAt != null) {
      _notificationService.scheduleNotification(
        task.id.hashCode,
        'Task Reminder',
        'Don\'t forget to complete: ${task.title}',
        task.completionAt!,
      );
    }
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

