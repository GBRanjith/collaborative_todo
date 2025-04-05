

// views/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Simulate a delay for splash screen
    await Future.delayed(Duration(seconds: 2));
   
    if (!mounted) return;
   
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
   
    // Navigate based on authentication status
    if (authViewModel.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/tasks');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              'Collaborative TODO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

