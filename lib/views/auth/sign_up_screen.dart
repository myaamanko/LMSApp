import 'dart:io';

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

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  File? profileImage; // 👤 Selected profile image

  final picker = ImagePicker();

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

    final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
    await storageRef.putFile(profileImage!);
    return await storageRef.getDownloadURL();
  }

  void _handleRegister() async {
    final auth = Provider.of<AuthManager>(context, listen: false);

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      await auth.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        auth.role ?? 'student',
      );

      // 📤 Upload profile image and update Firestore
      if (auth.user != null) {
        final uid = auth.user!.uid;
        final imageUrl = await _uploadProfileImage(uid);

        await auth.saveUserProfileImage(uid, imageUrl); // 🔧 Must exist in your AuthService
      }

      if (auth.role == 'lecturer') {
        Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'role-mismatch') {
        message = e.message!;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: auth.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GAF Training Portal',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your cadet account to get started',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),

                  // 👤 Profile Image Picker
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage:
                            profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                            : null,
                        backgroundColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildInput('Your Name', nameController),
                  const SizedBox(height: 16),
                  _buildInput('Your Email', emailController),
                  const SizedBox(height: 16),
                  _buildPassword('Password', passwordController, true),
                  const SizedBox(height: 16),
                  _buildPassword('Confirm Password', confirmPasswordController, false),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00205B), // GAF blue
                      ),
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
                            TextSpan(text: "Sign in Here", style: TextStyle(color: Colors.blue)),
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
