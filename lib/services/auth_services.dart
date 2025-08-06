import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Register new user with optional profile image
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? imageUrl, // 👈 new optional field
  }) async {
    try {
      // 🔍 Check if email is already in use with a different role
      QuerySnapshot existingUsers = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        final existingRole = existingUsers.docs.first['role'];
        if (existingRole != role) {
          throw FirebaseAuthException(
            code: 'role-mismatch',
            message: 'This email is already registered as a $existingRole.',
          );
        }
      }

      // ✅ Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // 💾 Save user data in Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': role,
        'profileImage': imageUrl, // ✅ can be null at this point
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // 🔐 Login existing user
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

  // 🔍 Fetch role of a user by UID
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc['role'] as String;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // 🔓 Logout current user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 📤 Upload profile image later (e.g. after sign-up)
  Future<void> saveUserProfileImage(String uid, String? imageUrl) async {
    if (imageUrl == null) return;

    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }
}
