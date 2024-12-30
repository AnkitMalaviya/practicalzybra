import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/responsive/responsive.dart';
import '../../model/task_model.dart';
import '../screens/add_update_task_screen.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final Function onComplete;
  final Function onTap;

  const TaskItemWidget({Key? key, required this.task, required this.onComplete, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task?.title ?? ""),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task?.description ?? ""),
          Text("Priority: ${task?.priority ?? " "}"),
          Text("Completion Date: ${DateFormat('MM/dd/yyyy').format(task.completionAt!)}"),
        ],
      ),
      leading: Checkbox(
        value: task.isComplete,
        onChanged: (value) {
          onComplete(value);
        },
      ),
      trailing: !Responsive.isTablet(context)
          ? IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddUpdateTaskScreen(task: task);
            },
          );
        },
      )
          : SizedBox(),
      onTap: () {
        onTap();
      },
    );
  }
}
