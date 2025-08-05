import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.login(emailController.text.trim(), passwordController.text.trim());

    if (auth.role == 'lecturer') {
      Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign in', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Please Sign in with your account'),
            const SizedBox(height: 30),
            _buildInput('Email Here', emailController, false),
            const SizedBox(height: 16),
            _buildInput('Password', passwordController, true),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Forget Password?', style: TextStyle(color: Colors.grey.shade600)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _handleLogin,
                child: const Text('SIGN IN', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
            _buildDivider('Or Sign in with'),
            const SizedBox(height: 16),
            _buildSocialButton('Sign In with Facebook', 'facebook.png', Colors.blue),
            const SizedBox(height: 12),
            _buildSocialButton('Sign In with Google', 'google.png', Colors.white),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signup),
                child: const Text.rich(
                  TextSpan(
                    text: "Didn't have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign up Here",
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => showPassword = !showPassword),
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButton(String text, String iconAsset, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/images/$iconAsset', height: 20),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: color == Colors.white ? Colors.grey.shade300 : color),
        ),
      ),
    );
  }
}