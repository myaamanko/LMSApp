import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lsm/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  File? profileImage;
  bool _isNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (profileImage == null) return null;

    final storageRef = FirebaseStorage.instance.ref().child(
      'profile_images/$uid.jpg',
    );
    await storageRef.putFile(profileImage!);
    return await storageRef.getDownloadURL();
  }

  void _handleRegister() async {
    final auth = Provider.of<AuthManager>(context, listen: false);

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      await auth.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        auth.role ?? 'student',
      );

      if (auth.user != null) {
        final uid = auth.user!.uid;
        final imageUrl = await _uploadProfileImage(uid);

        // ✅ Save full profile data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': auth.role ?? 'student',
          'imageUrl': imageUrl ?? '',
          'attendance': 0,
          'taskCompleted': 0,
          'taskInProgress': 0,
          'rewardPoints': 0,
          'createdAt': Timestamp.now(),
        });

        // ✅ Optional: set display name
        await auth.user!.updateDisplayName(nameController.text.trim());
      }

      if (auth.role == 'lecturer') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'role-mismatch') {
        message = e.message ?? message;
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
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // Content
          auth.isLoading
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Create Account',
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Join GAF Training Portal',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Profile Image Picker
                                  Center(
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: CircleAvatar(
                                        radius: 50,
                                        // ignore: deprecated_member_use
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        child:
                                            profileImage != null
                                                ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.file(
                                                    profileImage!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                : Icon(
                                                  Icons.add_a_photo,
                                                  size: 30,
                                                  // ignore: deprecated_member_use
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  _buildNameField(),
                                  const SizedBox(height: 16),
                                  _buildEmailField(),
                                  const SizedBox(height: 16),
                                  _buildPasswordField(),
                                  const SizedBox(height: 16),
                                  _buildConfirmPasswordField(),
                                  const SizedBox(height: 30),

                                  _buildSignUpButton(),
                                  const SizedBox(height: 24),
                                  _buildDivider('Or Sign up with'),
                                  const SizedBox(height: 16),
                                  _buildSocialButton(
                                    'Sign Up with Facebook',
                                    'facebook.png',
                                    Colors.blue,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildSocialButton(
                                    'Sign Up with Google',
                                    'google.png',
                                    Colors.white,
                                  ),
                                  const SizedBox(height: 24),
                                  _buildSignInButton(),
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
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isNameFocused = hasFocus),
      child: TextField(
        controller: nameController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle: TextStyle(
            color: _isNameFocused ? Colors.white : Colors.white70,
          ),
          prefixIcon: Icon(
            Icons.person,
            color: _isNameFocused ? Colors.white : Colors.white70,
          ),
          filled: true,
          // ignore: deprecated_member_use
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
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
          // ignore: deprecated_member_use
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
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
          // ignore: deprecated_member_use
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
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

  Widget _buildConfirmPasswordField() {
    return Focus(
      onFocusChange:
          (hasFocus) => setState(() => _isConfirmPasswordFocused = hasFocus),
      child: TextField(
        controller: confirmPasswordController,
        obscureText: !showConfirmPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: TextStyle(
            color: _isConfirmPasswordFocused ? Colors.white : Colors.white70,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: _isConfirmPasswordFocused ? Colors.white : Colors.white70,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              showConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed:
                () =>
                    setState(() => showConfirmPassword = !showConfirmPassword),
          ),
          filled: true,
          // ignore: deprecated_member_use
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
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
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(color == Colors.white ? 0.9 : 0.7),
          side: BorderSide(
            color:
                color == Colors.white
                    ? Colors.grey.shade300
                    // ignore: deprecated_member_use
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

  Widget _buildSignUpButton() {
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
        onPressed: _handleRegister,
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
          child: const Text(
            "Sign in Here",
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
