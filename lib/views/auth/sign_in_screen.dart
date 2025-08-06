import 'dart:ui';
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
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur
          Image.asset('assets/images/bg.jpeg', fit: BoxFit.cover),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // Login content
          auth.isLoading
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'GAF Login',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Enter your credentials to continue',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      const SizedBox(height: 30),
                                      _buildEmailField(),
                                      const SizedBox(height: 20),
                                      _buildPasswordField(),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle forgot password
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      _buildSignInButton(),
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
                                      _buildSignUpButton(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isEmailFocused = hasFocus),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: _isEmailFocused ? Colors.white : Colors.white70,
          ),
          prefixIcon: Icon(
            Icons.email,
            color: _isEmailFocused ? Colors.white : Colors.white70,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Focus(
      onFocusChange:
          (hasFocus) => setState(() => _isPasswordFocused = hasFocus),
      child: TextField(
        controller: passwordController,
        obscureText: !showPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: _isPasswordFocused ? Colors.white : Colors.white70,
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: _isPasswordFocused ? Colors.white : Colors.white70,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text, style: const TextStyle(color: Colors.white70)),
        ),
        Expanded(
          child: Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String text, String iconAsset, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/images/$iconAsset', height: 20),
        label: Text(
          text,
          style: TextStyle(
            color: color == Colors.white ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withOpacity(color == Colors.white ? 0.9 : 0.7),
          side: BorderSide(
            color:
                color == Colors.white
                    ? Colors.grey.shade300
                    : color.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF00205B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: _handleLogin,
        child: const Text(
          'SIGN IN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap:
              () => Navigator.pushReplacementNamed(context, AppRoutes.signup),
          child: const Text(
            "Sign up Here",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
