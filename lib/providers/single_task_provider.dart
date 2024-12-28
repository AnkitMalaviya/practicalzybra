import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task_model.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});



final singleTaskProvider = FutureProvider.family<TaskModel?, int?>((ref, id) async {
  final repository = ref.read(taskRepositoryProvider);
  return repository.getTaskById(id);
});