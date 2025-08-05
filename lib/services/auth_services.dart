import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with email & password
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // Save additional user info (like role) to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Fetch user role
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();

      return userDoc['role'] as String?;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
