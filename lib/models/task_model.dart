import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  DateTime createdAt;
  DateTime? deadline;
  IconData? category;
  String? note;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.deadline,
    this.category,
    this.note,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'category': category?.codePoint,
      'note': note,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
      deadline: data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      category: data['category'] != null ? IconData(data['category'], fontFamily: 'MaterialIcons') : null,
      note: data['note'],
      isDone: data['isDone'] ?? false,
    );
  }
}

class TaskModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  final _firestore = FirebaseFirestore.instance;

  List<Task> get tasks => _tasks;

  TaskModel() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final snapshot = await _firestore.collection('tasks').get();
    _tasks.clear();
    for (var doc in snapshot.docs) {
      _tasks.add(Task.fromMap(doc.id, doc.data()));
    }
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final docRef = await FirebaseFirestore.instance.collection('tasks').add(task.toMap());
    task.id = docRef.id;
    _tasks.add(task);
    notifyListeners();
  }


  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    await _firestore.collection('tasks').doc(task.id).update({'isDone': task.isDone});
    notifyListeners();
  }

  Future<void> removeTask(Task task) async {
    _tasks.remove(task);
    await _firestore.collection('tasks').doc(task.id).delete();
    notifyListeners();
  }
}
