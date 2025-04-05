
// validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
   
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
   
    return null;
  }
 
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
   
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
   
    return null;
  }
 
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
   
    return null;
  }
 
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task title is required';
    }
   
    return null;
  }
}

