

// constants.dart
class Constants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
 
  // Error messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorInvalidCredentials = 'Invalid email or password.';
  static const String errorEmailAlreadyInUse = 'This email is already registered.';
  static const String errorWeakPassword = 'Password is too weak. Use at least 6 characters.';
  static const String errorUserNotFound = 'User not found.';
 
  // Success messages
  static const String successTaskCreated = 'Task created successfully';
  static const String successTaskUpdated = 'Task updated successfully';
  static const String successTaskDeleted = 'Task deleted successfully';
  static const String successTaskShared = 'Task shared successfully';
 
  // App info
  static const String appName = 'Collaborative TODO';
  static const String appVersion = '1.0.0';
 
  // Action labels
  static const String actionCreate = 'CREATE';
  static const String actionUpdate = 'UPDATE';
  static const String actionDelete = 'DELETE';
  static const String actionShare = 'SHARE';
  static const String actionLogin = 'LOGIN';
  static const String actionRegister = 'REGISTER';
  static const String actionCancel = 'CANCEL';
}

