

// auth_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
 
  User? _user;
  bool _isLoading = false;
  String? _error;
 
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
 
  AuthViewModel() {
    _initAuthListener();
  }
 
  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
 
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
   
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
 
  Future<void> register(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
   
    try {
      await _authService.registerWithEmailAndPassword(email, password, displayName);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
 
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
   
    try {
      await _authService.signOut();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
 
  Future<AppUser> getUserInfo(String userId) async {
    AppUser? user = await _authService.getUserData(userId);
   
    if (user == null) {
      throw Exception('User not found');
    }
   
    return user;
  }
 
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
