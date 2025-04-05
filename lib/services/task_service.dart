
// services/task_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo/models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all tasks owned by the user or shared with them
  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where(Filter.or(
          Filter('ownerId', isEqualTo: userId),
          Filter('sharedWith', arrayContains: userId),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Get a specific task by ID
  Stream<Task?> getTaskById(String taskId) {
    return _firestore
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .map((doc) => doc.exists ? Task.fromFirestore(doc) : null);
  }

  // Add a new task
  Future<String> addTask(Task task) async {
    DocumentReference docRef = await _firestore.collection('tasks').add(task.toMap());
    return docRef.id;
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  // Share a task with another user
  Future<void> shareTask(String taskId, String userEmail) async {
    // First get the user ID from the email
    QuerySnapshot userQuery = await _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception('User not found');
    }

    String userId = userQuery.docs.first.id;

    // Add the user to the sharedWith array
    await _firestore.collection('tasks').doc(taskId).update({
      'sharedWith': FieldValue.arrayUnion([userId]),
    });
  }

  // Unshare a task with a user
  Future<void> unshareTask(String taskId, String userId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'sharedWith': FieldValue.arrayRemove([userId]),
    });
  }
}

