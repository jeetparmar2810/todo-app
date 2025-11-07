import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../services/share_service.dart';
import '../models/task_model.dart';
import '../core/utils/helpers.dart';
import '../core/constants/app_strings.dart'; // Import AppStrings

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

  void _listen() {
    _db.getTasks(user!.uid).listen((data) {
      tasks = data;
      notifyListeners();
    });
  }

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
      sharedWith: [user!.uid],
      completed: false,
      createdAt: Timestamp.now(),
    );

    try {
      await _db.addTask(task);
      showSnack(context, AppStrings.taskAdded);
    } catch (e) {
      showSnack(context, '${AppStrings.taskAddFailed}: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(BuildContext context, TaskModel task) async {
    try {
      await _db.updateTask(task);
      showSnack(context, AppStrings.taskUpdated);
    } catch (e) {
      showSnack(context, '${AppStrings.taskUpdateFailed}: $e');
    }
  }

  Future<void> deleteTask(BuildContext context, String id) async {
    try {
      await _db.deleteTask(id);
      showSnack(context, AppStrings.taskDeleted);
    } catch (e) {
      showSnack(context, '${AppStrings.taskDeleteFailed}: $e');
    }
  }

  Future<void> toggleComplete(
      BuildContext context,
      String taskId,
      bool newStatus,
      ) async {
    try {
      await _db.toggleTaskComplete(taskId, newStatus);
      showSnack(
        context,
        newStatus ? AppStrings.taskMarkedComplete : AppStrings.taskMarkedIncomplete,
      );
    } catch (e) {
      showSnack(context, '${AppStrings.taskToggleFailed}: $e');
    }
  }

  Future<void> shareTaskWithEmail(
      BuildContext context,
      String taskId,
      String email,
      ) async {
    try {
      await _db.shareTask(taskId, email);
      showSnack(context, AppStrings.taskShared);
    } catch (e) {
      showSnack(context, '${AppStrings.taskShareFailed}: $e');
    }
  }

  Future<void> shareExternally(TaskModel task) async {
    await ShareService.shareTask(task);
  }
}