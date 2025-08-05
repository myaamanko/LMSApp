import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;

  void _handleRegister() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      auth.role ?? 'student',
    );

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign Up', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Create an account to begin your Learning Journey'),
            const SizedBox(height: 30),
            _buildInput('Your Name Here', nameController),
            const SizedBox(height: 16),
            _buildInput('Your Email Here', emailController),
            const SizedBox(height: 16),
            _buildPassword('Password', passwordController, true),
            const SizedBox(height: 16),
            _buildPassword('Confirm Password', confirmPasswordController, false),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _handleRegister,
                child: const Text('SIGN UP', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
            _buildDivider('Or Sign up with'),
            const SizedBox(height: 16),
            _buildSocialButton('Sign Up with Facebook', 'facebook.png', Colors.blue),
            const SizedBox(height: 12),
            _buildSocialButton('Sign Up with Google', 'google.png', Colors.white),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign in Here",
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

  Widget _buildInput(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPassword(String hint, TextEditingController controller, bool isMain) {
    final show = isMain ? showPassword : showConfirmPassword;
    return TextField(
      controller: controller,
      obscureText: !show,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          icon: Icon(show ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() {
            if (isMain) {
              showPassword = !showPassword;
            } else {
              showConfirmPassword = !showConfirmPassword;
            }
          }),
        ),
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
