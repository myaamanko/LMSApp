import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsm/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final auth = Provider.of<AuthManager>(context, listen: false);

    try {
      await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (auth.role == 'lecturer') {
        Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else if (e.code == 'role-mismatch') {
        message = e.message!;
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthManager>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ GAF background
          Image.asset(
            'assets/images/gaf_bg.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),

          // 🔲 Glass container (login form)
          auth.isLoading
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'GAF Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00205B), // GAF Blue
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Enter your email and password to sign in.',
                          ),
                          const SizedBox(height: 30),
                          _buildInput('Email', emailController, false),
                          const SizedBox(height: 16),
                          _buildInput('Password', passwordController, true),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF00205B,
                                ), // GAF Blue
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _handleLogin,
                              child: const Text('SIGN IN'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildDivider('Or Sign in with'),
                          const SizedBox(height: 16),
                          _buildSocialButton(
                            'Sign In with Facebook',
                            'facebook.png',
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildSocialButton(
                            'Sign In with Google',
                            'google.png',
                            Colors.white,
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.signup,
                                ),
                            child: const Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                children: [
                                  TextSpan(
                                    text: "Sign up Here",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildInput(
    String hint,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => showPassword = !showPassword),
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
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
          side: BorderSide(
            color: color == Colors.white ? Colors.grey.shade300 : color,
          ),
        ),
      ),
    );
  }
}
