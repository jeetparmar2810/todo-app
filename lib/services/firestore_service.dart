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
        .map(
          (snapshot) => snapshot.docs.map((d) => TaskModel.fromDoc(d)).toList(),
    );
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _db.collection('tasks').doc(task.id).set(task.toMap());
    } catch (e) {
      RetryService.instance.enqueue(() async {
        await _db.collection('tasks').doc(task.id).set(task.toMap());
      });
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      RetryService.instance.enqueue(() async {
        await _db.collection('tasks').doc(task.id).update(task.toMap());
      });
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _db.collection('tasks').doc(id).delete();
    } catch (e) {
      RetryService.instance.enqueue(() async {
        await _db.collection('tasks').doc(id).delete();
      });
      rethrow;
    }
  }

  Future<void> shareTask(String taskId, String email) async {
    try {
      final users = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (users.docs.isEmpty) {
        throw Exception('User not found');
      }

      final userId = users.docs.first.id;

      await _db.collection('tasks').doc(taskId).update({
        'sharedWith': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      RetryService.instance.enqueue(() async {
        final users = await _db
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (users.docs.isNotEmpty) {
          final userId = users.docs.first.id;

          await _db.collection('tasks').doc(taskId).update({
            'sharedWith': FieldValue.arrayUnion([userId]),
          });
        }
      });
      rethrow;
    }
  }
}