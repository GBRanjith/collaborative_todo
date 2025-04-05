
// viewmodels/sharing_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/models/user.dart';
import 'package:collaborative_todo/services/task_service.dart';
import 'package:collaborative_todo/services/auth_service.dart';
import 'package:share_plus/share_plus.dart';

class SharingViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _error;
  List<AppUser> _sharedUsers = [];
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AppUser> get sharedUsers => _sharedUsers;

  // Load users that a task is shared with
  Future<void> loadSharedUsers(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _sharedUsers = [];
      
      for (String userId in task.sharedWith) {
        AppUser? user = await _authService.getUserData(userId);
        if (user != null) {
          _sharedUsers.add(user);
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Share a task with a user by email
  Future<void> shareTaskWithUser(String taskId, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _taskService.shareTask(taskId, email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
  
  // Unshare a task with a user
  Future<void> unshareTaskWithUser(String taskId, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _taskService.unshareTask(taskId, userId);
      
      // Remove user from local list
      _sharedUsers.removeWhere((user) => user.id == userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
  
  // Share task via platform share sheet
  Future<void> shareTaskExternally(Task task) async {
    final String shareText = 'Task: ${task.title}\n'
        'Description: ${task.description}\n'
        'Due Date: ${task.dueDate.toString().split(' ')[0]}\n\n'
        'View this task in the Collaborative TODO app.';
        
    await Share.share(shareText, subject: 'Shared Task: ${task.title}');
  }
  
  // Generate a unique link to share a task (this would require backend support)
  Future<String> generateShareLink(String taskId) async {
    // In a real app, this would call a backend API to generate a secure, unique sharing link
    // For this example, we're just creating a placeholder URL
    return 'https://todo-app.example.com/tasks/$taskId';
  }
}
