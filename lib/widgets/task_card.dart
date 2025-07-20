import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskModel = Provider.of<TaskModel>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isDone ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟠 Category icon
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              task.category ?? Icons.task_alt,
              color: task.isDone ? Colors.green : Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 12),

          // 📋 Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration:
                    task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone ? Colors.grey : Colors.black,
                  ),
                ),
                if (task.deadline != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      DateFormat('hh:mm a').format(task.deadline!),
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                if (task.note != null && task.note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      task.note!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ✅ Checkbox
          Checkbox(
            value: task.isDone,
            onChanged: (val) {
              taskModel.toggleTask(task);
            },
            activeColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
