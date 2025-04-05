
// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create a user document
    await _firestore.collection('users').doc(result.user!.uid).set({
      'email': email,
      'displayName': displayName,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update display name
    await result.user!.updateDisplayName(displayName);

    return result;
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Get user data from Firestore
  Future<AppUser?> getUserData(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }
}