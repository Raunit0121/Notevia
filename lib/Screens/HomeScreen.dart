import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'notes_screen.dart'; // Make sure you have this screen

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DateTime selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskModel = Provider.of<TaskModel>(context);

    List<Task> filteredTasks = taskModel.tasks.where((task) {
      return task.deadline != null &&
          task.deadline!.year == selectedDate.year &&
          task.deadline!.month == selectedDate.month &&
          task.deadline!.day == selectedDate.day;
    }).toList();

    final pendingTasks = filteredTasks.where((t) => !t.isDone).toList();
    final completedTasks = filteredTasks.where((t) => t.isDone).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFDA6A00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Center(
                child: Text(
                  "📝 My Todo List",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Date Picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.deepOrange),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.edit_calendar, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Task List
            Expanded(
              child: taskModel.tasks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (pendingTasks.isNotEmpty)
                    ...pendingTasks.map((task) => TaskCard(task: task)).toList(),

                  if (completedTasks.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "✅ Completed",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...completedTasks.map((task) => TaskCard(task: task)).toList(),
                  ],

                  if (pendingTasks.isEmpty && completedTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          "🎉 No tasks for this day!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button to Add Task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        backgroundColor: const Color(0xFFDA6A00),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Two Buttons: To-Do List & Notes
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          height: 56, // Fixes height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFE65100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // To-Do List Button
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Homescreen()),
                    );
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "To-Do",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Divider
              Container(
                width: 1,
                height: 32,
                color: Colors.white38,
              ),

              // Notes Button
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const NotesScreen()),
                    );
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.note_alt_outlined, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "Notes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
