
import '../core/db/database_helper.dart';
import '../model/task_model.dart';

class TaskRepository {
  Future<List<TaskModel>> getTasks() async {
    final tasks = await DatabaseHelper.fetchTasks();
    print(tasks);
    return tasks.map((e) => TaskModel.fromMap(e)).toList();
  }
  Future<TaskModel?> getTaskById(int? id) async {
    final db = await DatabaseHelper.initDB();
    final task =await DatabaseHelper.getSingleTaskById(id);

    if (task.isNotEmpty) {
      return TaskModel.fromMap(task.first);
    } else {
      return null;
    }
  }
  Future<void> addTask(TaskModel task) async {
    await DatabaseHelper.insertTask(task.toMap());
  }
  Future<void> updateTask(TaskModel task) async {
    await DatabaseHelper.updateTask(task.toMap());
  }
  Future<void> deleteTask(TaskModel? task) async {
    await DatabaseHelper.deleteTask(task?.id!);
  }

}
