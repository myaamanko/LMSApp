import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  String? _role; // 'student' or 'lecturer'

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  String? get userId => _userId;
  String? get role => _role;

  /// Simulated login for now — replace with actual API logic later
  Future<void> login(String emailOrUsername, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call and token handling
      _token = 'mock_token';
      _userId = '123';
      _role = emailOrUsername.contains('lect') ? 'lecturer' : 'student';

      notifyListeners();
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  /// Simulated register
  Future<void> register(String name, String email, String password, String role) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      _role = role;
      // Optionally auto-login
    } catch (e) {
      throw Exception('Registration failed');
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _role = null;
    notifyListeners();
  }

  /// Set role manually (e.g., during onboarding)
  void setRole(String selectedRole) {
    _role = selectedRole;
    notifyListeners();
  }
}
