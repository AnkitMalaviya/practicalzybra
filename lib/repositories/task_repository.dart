import '../core/db/database_helper.dart';
import '../model/task_model.dart';

class TaskRepository {
  Future<List<TaskModel>> getTasks() async {
    final tasks = await DatabaseHelper.fetchTasks();
    print(tasks);
    return tasks.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<TaskModel?> getTaskById(int? id) async {
    final task = await DatabaseHelper.getSingleTaskById(id);

    if (task.isNotEmpty) {
      return TaskModel.fromMap(task.first);
    } else {
      return null;
    }
  }

  Future<TaskModel?> addTask(TaskModel task) async {
    final taskId = await DatabaseHelper.insertTask(task.toMap());
    final newtask = await DatabaseHelper.getSingleTaskById(taskId);

    if (newtask.isNotEmpty) {
      return TaskModel.fromMap(newtask.first);
    } else {
      return null;
    }
  }

  Future<TaskModel?> updateTask(TaskModel task) async {
    print("fsdkjfhdskfjshd");
    print(task.id);
    await DatabaseHelper.updateTask(task.toMap());
    final newtask = await DatabaseHelper.getSingleTaskById(task.id);
    print("fsdfgdskjfhsdkfjshd");
    print(newtask);
    if (newtask.isNotEmpty) {
      return TaskModel.fromMap(newtask.first);
    } else {
      return null;
    }
  }

  Future<void> deleteTask(TaskModel? task) async {
    await DatabaseHelper.deleteTask(task?.id!);
  }
}
