
// viewmodels/task_list_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/services/task_service.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter states
  bool _showCompleted = true;
  String _searchQuery = '';

  bool get showCompleted => _showCompleted;
  String get searchQuery => _searchQuery;

  // Filtered tasks based on current filters
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      // Apply completed filter
      if (!_showCompleted && task.isCompleted) {
        return false;
      }
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      
      return true;
    }).toList();
  }

  // Initialize tasks for the current user
  void initTasks(String userId) {
    _isLoading = true;
    notifyListeners();

    _taskService.getTasks(userId).listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
      }
    );
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    try {
      await _taskService.addTask(task);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      Task updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _taskService.updateTask(updatedTask);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Set show completed filter
  void setShowCompleted(bool value) {
    _showCompleted = value;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _showCompleted = true;
    _searchQuery = '';
    notifyListeners();
  }
}
