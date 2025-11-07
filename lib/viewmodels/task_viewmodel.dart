import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../services/share_service.dart';
import '../models/task_model.dart';
import '../core/utils/helpers.dart';

final taskViewModelProvider = ChangeNotifierProvider<TaskViewModel>((ref) {
  return TaskViewModel();
});

class TaskViewModel extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

  bool loading = false;
  List<TaskModel> tasks = [];

  TaskViewModel() {
    if (user != null) _listen();
  }

  /// ✅ Real-time listener
  void _listen() {
    _db.getTasks(user!.uid).listen((data) {
      tasks = data;
      notifyListeners();
    });
  }

  /// ✅ Add Task
  Future<void> addTask(BuildContext context, String title, String desc) async {
    if (user == null) return;

    loading = true;
    notifyListeners();

    final id = const Uuid().v4();
    final task = TaskModel(
      id: id,
      title: title,
      description: desc,
      ownerId: user!.uid,
      sharedWith: [user!.uid], // owner always included
      completed: false,
      createdAt: Timestamp.now(),
    );

    try {
      await _db.addTask(task);
      showSnack(context, 'Task added');
    } catch (e) {
      showSnack(context, 'Add failed: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// ✅ Update task
  Future<void> updateTask(BuildContext context, TaskModel task) async {
    try {
      await _db.updateTask(task);
      showSnack(context, 'Task updated');
    } catch (e) {
      showSnack(context, 'Update failed: $e');
    }
  }

  /// ✅ Delete task
  Future<void> deleteTask(BuildContext context, String id) async {
    try {
      await _db.deleteTask(id);
      showSnack(context, 'Task deleted');
    } catch (e) {
      showSnack(context, 'Delete failed: $e');
    }
  }

  /// ✅ Toggle completed
  Future<void> toggleComplete(
      BuildContext context,
      String taskId,
      bool newStatus,
      ) async {
    try {
      await _db.toggleTaskComplete(taskId, newStatus);
      showSnack(
          context, newStatus ? "Marked as completed" : "Marked as incomplete");
    } catch (e) {
      showSnack(context, 'Failed to update: $e');
    }
  }

  /// ✅ Share task with another user via email
  Future<void> shareTaskWithEmail(
      BuildContext context, String taskId, String email) async {
    try {
      await _db.shareTask(taskId, email);
      showSnack(context, 'Shared successfully');
    } catch (e) {
      showSnack(context, 'Share failed: $e');
    }
  }

  /// ✅ External share (WhatsApp, etc.)
  Future<void> shareExternally(TaskModel task) async {
    await ShareService.shareTask(task);
  }
}