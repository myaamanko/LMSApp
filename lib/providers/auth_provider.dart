import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? user;
  String? role;

  Future<void> register(String name, String email, String password, String role) async {
    user = await _authService.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    this.role = role;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    user = await _authService.login(email, password);

    if (user != null) {
      role = await _authService.getUserRole(user!.uid);
    }

    notifyListeners();
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
}
