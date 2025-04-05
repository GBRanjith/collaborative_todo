

// extensions.dart
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;
 
  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
 
  // Check if device is tablet
  bool get isTablet => screenWidth >= 600;
 
  // Check if device is desktop
  bool get isDesktop => screenWidth >= 900;
 
  // Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
 
  // Get theme
  ThemeData get theme => Theme.of(this);
 
  // Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
 
  // Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
 
  // Get is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
 
  // Navigate to named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }
 
  // Navigate to named route and replace current route
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);
  }
 
  // Pop route
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}

