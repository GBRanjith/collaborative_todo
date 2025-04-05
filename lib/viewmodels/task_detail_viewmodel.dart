

// task_detail_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
 
  Task? _task;
  bool _isLoading = false;
  String? _error;
 
  Task? get task => _task;
  bool get isLoading => _isLoading;
  String? get error => _error;
 
  // Load task details
  void loadTask(String taskId) {
    _isLoading = true;
    _error = null;
    notifyListeners();
   
    _taskService.getTaskById(taskId).listen(
      (task) {
        _task = task;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      }
    );
  }
 
  // Update task
  Future<void> updateTask(Task updatedTask) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
   
    try {
      await _taskService.updateTask(updatedTask);
      _task = updatedTask;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
 
  // Toggle task completion status
  Future<void> toggleTaskCompletion() async {
    if (_task == null) return;
   
    try {
      final updatedTask = _task!.copyWith(
        isCompleted: !_task!.isCompleted,
        updatedAt: DateTime.now(),
      );
     
      await updateTask(updatedTask);
    } catch (e) {
      // Error is handled in updateTask
      throw e;
    }
  }
 
  // Delete task
  Future<void> deleteTask() async {
    if (_task == null) return;
   
    _isLoading = true;
    _error = null;
    notifyListeners();
   
    try {
      await _taskService.deleteTask(_task!.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
 
  // Check if user is the owner of the task
  bool isTaskOwner(String userId) {
    return _task != null && _task!.ownerId == userId;
  }
 
  // Check if task is shared with the user
  bool isTaskSharedWithUser(String userId) {
    return _task != null && _task!.sharedWith.contains(userId);
  }
 
  // Check if task is overdue
  bool isTaskOverdue() {
    return _task != null && _task!.dueDate.isBefore(DateTime.now()) && !_task!.isCompleted;
  }
 
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

