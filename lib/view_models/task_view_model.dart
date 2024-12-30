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

  Future<void> addTask(TaskModel task) async {
    var newTask = await _repository.addTask(task);

    if (newTask != null) {
      print("fksdjfhkdjsfhkjs");
      print(newTask?.completionAt);

      if (newTask?.isComplete == false) {
        NotificationService().scheduleTaskReminder(
          taskId: newTask!.id!.toString(),
          taskTitle: newTask?.title! ?? "",
          scheduleTime: newTask!.completionAt!,
        );
      }
    }
    await fetchTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    var newTask = await _repository.updateTask(task);
    if (newTask != null) {
      print("fksdjfhkdjsfhkjsupdate");
      print(newTask?.completionAt);
      await NotificationService().cancelTaskReminder(newTask!.id!.toString());
      if (newTask?.isComplete == false) {
        NotificationService().scheduleTaskReminder(
          taskId: newTask!.id!.toString(),
          taskTitle: newTask?.title! ?? "",
          scheduleTime: newTask!.completionAt!,
        );
      }
    }
    await fetchTasks();
  }

  Future<void> deleteTask(TaskModel? task) async {
    await _repository.deleteTask(task);
    await NotificationService().cancelTaskReminder(task!.id!.toString());
    await fetchTasks();
  }
}

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskViewModel(repository);
});
