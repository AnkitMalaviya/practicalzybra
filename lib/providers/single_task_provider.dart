import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zybrapracticaltask/providers/task_provider.dart';

import '../model/task_model.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final singleTaskProvider = FutureProvider<TaskModel?>((ref) async {
  final repository = ref.read(taskRepositoryProvider);
  final selectedTaskId = ref.watch(selectedTaskIdProvider);
  return repository.getTaskById(selectedTaskId);
});
