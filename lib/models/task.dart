
// models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;
  final String ownerId;
  final List<String> sharedWith;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    required this.ownerId,
    this.sharedWith = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      ownerId: data['ownerId'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? ownerId,
    List<String>? sharedWith,
    DateTime? updatedAt,
  }) {
    return Task(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
