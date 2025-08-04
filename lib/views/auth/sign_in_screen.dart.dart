import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Only for signup

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.height * 0.03;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isLogin = false),
                    child: Column(
                      children: [
                        Text(
                          "Sign-up",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: !isLogin ? Colors.white : Colors.white38,
                          ),
                        ),
                        if (!isLogin)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 60,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = true),
                    child: Column(
                      children: [
                        Text(
                          "Log-in",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isLogin ? Colors.white : Colors.white38,
                          ),
                        ),
                        if (isLogin)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 60,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),

              // Fields
              if (!isLogin) ...[
                _buildInput("Username", Icons.person, _usernameController),
                const SizedBox(height: 20),
              ],
              _buildInput("Email address", Icons.email, _emailController),
              const SizedBox(height: 20),
              _buildInput("Password", Icons.lock, _passwordController, isPassword: true),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _handleSubmit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin ? "Log in" : "Sign up",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Social login
              Center(
                child: Text(
                  isLogin ? "log in with" : "sign up with",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/google.png', height: 36), // Add your Google logo
                  const SizedBox(width: 20),
                  Image.asset('assets/images/facebook.png', height: 36), // Add your FB logo
                ],
              ),

              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate as guest
                    Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: "Enter as Guest",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleSubmit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (isLogin) {
      await auth.login(_emailController.text.trim(), _passwordController.text.trim());
    } else {
      await auth.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        auth.role ?? 'student',
      );
    }

    if (auth.role == 'lecturer') {
      Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
    }
  }
}
