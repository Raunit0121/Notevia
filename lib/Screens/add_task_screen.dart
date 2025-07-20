import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  IconData? _selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.favorite, 'color': Colors.orange},
    {'icon': Icons.star, 'color': Colors.amber},
    {'icon': Icons.access_time, 'color': Colors.lightBlue},
    {'icon': Icons.home, 'color': Colors.blueGrey},
  ];

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) return;

    final taskModel = Provider.of<TaskModel>(context, listen: false);

    DateTime? deadline;
    if (_selectedDate != null) {
      deadline = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime?.hour ?? 0,
        _selectedTime?.minute ?? 0,
      );
    }

    final newTask = Task(
      id: '', // Firestore will auto-assign this
      title: _titleController.text.trim(),
      createdAt: DateTime.now(),
      deadline: deadline,
      category: _selectedCategory,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      isDone: false,
    );

    await taskModel.addTask(newTask);

    // 🔔 Schedule Notification if deadline is valid
    if (deadline != null && deadline.isAfter(DateTime.now())) {
      try {
        await NotificationService.scheduleNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: "Task Reminder",
          body: newTask.title,
          scheduledTime: deadline,
        );
      } catch (e) {
        print("🔴 Notification scheduling error: $e");
      }
    }

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDA6A00),
        title: const Text("Add New Task"),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Task Title", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _buildTextField(_titleController, "Enter task title"),

            const SizedBox(height: 24),
            const Text("Category", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _buildCategorySelector(),

            const SizedBox(height: 24),
            _buildDateTimePickers(),

            const SizedBox(height: 24),
            const Text("Note", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _buildTextField(_noteController, "Task note", maxLines: 3),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDA6A00),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0D7D1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0D7D1)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((item) {
        return GestureDetector(
          onTap: () {
            setState(() => _selectedCategory = item['icon']);
          },
          child: CircleAvatar(
            radius: 26,
            backgroundColor: _selectedCategory == item['icon']
                ? item['color']
                : Colors.grey.shade300,
            child: Icon(
              item['icon'],
              color: _selectedCategory == item['icon']
                  ? Colors.white
                  : Colors.black54,
              size: 26,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimePickers() {
    return Row(
      children: [
        Expanded(
          child: _buildPickerCard(
            label: "Date",
            icon: Icons.calendar_today,
            value: _selectedDate != null
                ? DateFormat('MMM d, yyyy').format(_selectedDate!)
                : "Select Date",
            onTap: _pickDate,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildPickerCard(
            label: "Time",
            icon: Icons.access_time,
            value: _selectedTime != null
                ? _selectedTime!.format(context)
                : "Select Time",
            onTap: _pickTime,
          ),
        ),
      ],
    );
  }

  Widget _buildPickerCard({
    required String label,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Material(
            elevation: 2,
            shadowColor: Colors.black12,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0D7D1)),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
