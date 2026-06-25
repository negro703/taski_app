import 'package:flutter/material.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';

class TaskCardTile extends StatelessWidget {
  final Task task;
  final ValueChanged<TaskStatus> onStatusChanged;

  const TaskCardTile({
    super.key,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(task.description),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due: ${task.dueDate.toLocal().toShortDateString()}'),
                DropdownButton<TaskStatus>(
                  value: task.status,
                  onChanged: (TaskStatus? newStatus) {
                    if (newStatus != null) {
                      onStatusChanged(newStatus);
                    }
                  },
                  items: TaskStatus.values.map((TaskStatus status) {
                    return DropdownMenuItem<TaskStatus>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return "${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/${year.toString().substring(2, 4)}";
  }
}
