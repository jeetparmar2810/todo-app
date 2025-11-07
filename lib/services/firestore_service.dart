import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';
import '../services/retry_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasks(String userId) {
    return _db
        .collection('tasks')
        .where('sharedWith', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TaskModel.fromDoc(doc)).toList());
  }


  Future<void> addTask(TaskModel task) async {
    final ref = _db.collection('tasks').doc(task.id);

    try {
      await ref.set(task.toMap());
    } catch (e) {
      RetryService.instance.enqueue(() => ref.set(task.toMap()));
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final ref = _db.collection('tasks').doc(task.id);

    try {
      await ref.update(task.toMap());
    } catch (e) {
      RetryService.instance.enqueue(() => ref.update(task.toMap()));
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    final ref = _db.collection('tasks').doc(id);

    try {
      await ref.delete();
    } catch (e) {
      RetryService.instance.enqueue(() => ref.delete());
      rethrow;
    }
  }

  Future<void> toggleTaskComplete(String taskId, bool status) async {
    final ref = _db.collection('tasks').doc(taskId);

    try {
      await ref.update({"completed": status});
    } catch (e) {
      RetryService.instance.enqueue(() => ref.update({"completed": status}));
      rethrow;
    }
  }

  Future<void> shareTask(String taskId, String email) async {
    try {
      final users = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (users.docs.isEmpty) {
        throw Exception("User with email '$email' not found");
      }

      final userId = users.docs.first.id;

      await _db.collection('tasks').doc(taskId).update({
        "sharedWith": FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      RetryService.instance.enqueue(() async {
        final users = await _db
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (users.docs.isNotEmpty) {
          final userId = users.docs.first.id;

          await _db.collection('tasks').doc(taskId).update({
            "sharedWith": FieldValue.arrayUnion([userId]),
          });
        }
      });
      rethrow;
    }
  }
}