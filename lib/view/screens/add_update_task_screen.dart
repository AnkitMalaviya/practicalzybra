import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/responsive/responsive.dart';
import '../../model/task_model.dart';
import '../../providers/task_provider.dart';
import '../../view_models/task_view_model.dart';

class AddUpdateTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  const AddUpdateTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  ConsumerState<AddUpdateTaskScreen> createState() => _AddUpdateTaskScreenState();
}

class _AddUpdateTaskScreenState extends ConsumerState<AddUpdateTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with task data if available
    titleController = TextEditingController(text: widget.task?.title ?? "");
    descriptionController = TextEditingController(text: widget.task?.description ?? "");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(completeDateTimeProvider.notifier).state = widget.task?.completionAt;
    });
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completionAt = ref.watch(completeDateTimeProvider);
    String priority = ref.watch(priorityProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * 0.3,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(widget.task != null ? 'Update Task' : 'Add Task')),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: priority,
                  items: const [
                    DropdownMenuItem(child: Text('Low'), value: 'Low'),
                    DropdownMenuItem(child: Text('Medium'), value: 'Medium'),
                    DropdownMenuItem(child: Text('High'), value: 'High'),
                  ],
                  onChanged: (value) {
                    ref.read(priorityProvider.notifier).state = value ?? 'Low';
                  },
                  hint: const Text('Select Priority'),
                ),
                const SizedBox(height: 20),
                Text('Completion Date'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: completionAt ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          // Select time
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(completionAt ?? DateTime.now()),
                          );

                          if (selectedTime != null) {
                            // Combine selected date and time into a single DateTime
                            final combinedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            // Update the provider state
                            ref.read(completeDateTimeProvider.notifier).state = combinedDateTime;
                          }
                        }
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                    if (completionAt != null) Text(DateFormat('MM/dd/yyyy').format(completionAt!.toLocal())),
                    const SizedBox(width: 10),
                    if (completionAt != null) Text(DateFormat('hh:mm').format(completionAt!.toLocal())),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        _showErrorDialog('Please enter a title');
                        return;
                      }
                      if (descriptionController.text.isEmpty) {
                        _showErrorDialog('Please enter a description');
                        return;
                      }
                      if (priority.isEmpty) {
                        _showErrorDialog('Please select a priority');
                        return;
                      }
                      if (completionAt == null) {
                        _showErrorDialog('Please select a completion date');
                        return;
                      }
                      if (widget.task != null) {
                        final updatedTask = widget.task!.copyWith(
                          title: titleController.text,
                          description: descriptionController.text,
                          priority: priority,
                          completionAt: completionAt,
                          updatedAt: DateTime.now(),
                        );

                        ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
                        ref.invalidate(tasksProvider);
                        Navigator.pop(context);
                      } else {
                        final task = TaskModel(
                          title: titleController.text,
                          description: descriptionController.text,
                          isComplete: false,
                          priority: priority,
                          completionAt: completionAt,
                          createdAt: DateTime.now(),
                        );
                        ref.read(taskViewModelProvider.notifier).addTask(task);
                        ref.invalidate(tasksProvider);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.task != null ? 'Update Task' : 'Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
