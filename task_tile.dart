import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TaskTile({
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.redAccent;
      case "Low":
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(value: task.isDone, onChanged: onChanged),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            decoration: task.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: task.deadline != null
            ? Text(
                "Deadline: ${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}",
                style: TextStyle(color: Colors.grey.shade600),
              )
            : null,
        trailing: Wrap(
          spacing: 5,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                shape: BoxShape.circle,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
