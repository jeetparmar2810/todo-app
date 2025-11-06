import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final List<String> sharedWith;
  final bool completed;
  final Timestamp createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.sharedWith,
    required this.completed,
    required this.createdAt,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    List<String>? sharedWith,
    bool? completed,
    Timestamp? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'completed': completed,
      'createdAt': createdAt,
    };
  }

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['ownerId'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      completed: data['completed'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}