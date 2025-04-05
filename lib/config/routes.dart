// routes.dart
import 'package:flutter/material.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/views/auth/login_screen.dart';
import 'package:collaborative_todo/views/auth/register_screen.dart';
import 'package:collaborative_todo/views/tasks/task_list_screen.dart';
import 'package:collaborative_todo/views/tasks/task_detail_screen.dart';
import 'package:collaborative_todo/views/tasks/create_task_screen.dart';
import 'package:collaborative_todo/views/sharing/share_task_screen.dart';
import 'package:collaborative_todo/views/sharing/shared_with_me_screen.dart';

import '../views/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String taskList = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String createTask = '/create-task';
  static const String editTask = '/edit-task';
  static const String shareTask = '/share-task';
  static const String sharedWithMe = '/shared-with-me';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      
      case taskList:
        return MaterialPageRoute(builder: (_) => TaskListScreen());
      
      case taskDetail:
        final String taskId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(taskId: taskId),
        );
      
      case createTask:
        return MaterialPageRoute(builder: (_) => CreateTaskScreen());
      
      case editTask:
        final task = settings.arguments as Task;
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(task: task),
        );
      
      case shareTask:
        final task = settings.arguments as Task;
        return MaterialPageRoute(
          builder: (_) => ShareTaskScreen(task: task),
        );
      
      case sharedWithMe:
        return MaterialPageRoute(builder: (_) => SharedWithMeScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}