
// helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // Format date to readable format
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
 
  // Format time to readable format
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
 
  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
 
  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }
 
  // Get relative date string (Today, Tomorrow, or formatted date)
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDate(date);
    }
  }
 
  // Show a snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
 
  // Create an email subject for sharing
  static String createShareEmailSubject(String taskTitle) {
    return 'Shared Task: $taskTitle';
  }
 
  // Create an email body for sharing
  static String createShareEmailBody(String taskTitle, String taskDescription, DateTime dueDate) {
    return '''
I've shared a task with you:

Task: $taskTitle
Description: $taskDescription
Due Date: ${formatDate(dueDate)}

You can view and edit this task in the Collaborative TODO app.
''';
  }
}
