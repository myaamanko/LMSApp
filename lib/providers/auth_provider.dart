import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_services.dart';

class AuthManager extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? user;
  String? role;

  Future<void> register(String name, String email, String password, String role) async {
    _setLoading(true);

    try {
      user = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      this.role = role;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      User? signedInUser = await _authService.login(email, password);

      if (signedInUser != null) {
        final fetchedRole = await _authService.getUserRole(signedInUser.uid);

        if (fetchedRole != role) {
          await _authService.logout();
          throw FirebaseAuthException(
            code: 'role-mismatch',
            message: 'This account is not registered as a $role.',
          );
        }

        user = signedInUser;
        this.role = fetchedRole;
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    role = null;
    notifyListeners();
  }

  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ✅ NEW: Save user profile image after signup
  Future<void> saveUserProfileImage(String uid, String? imageUrl) async {
    try {
      await _authService.saveUserProfileImage(uid, imageUrl);
    } catch (e) {
      rethrow;
    }
  }
}
