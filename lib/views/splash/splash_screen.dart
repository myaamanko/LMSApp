import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // 👀 Splash delay

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        final doc = await _firestore.collection('users').doc(currentUser.uid).get();

        if (doc.exists) {
          final role = doc['role'];

          if (role == 'lecturer') {
            Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
          }
          return;
        }
      } catch (e) {
        // ⛔ If error, fall back to login
        debugPrint("Error fetching role: $e");
      }
    }

    // 👋 Default route for new/unauthed users
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00205B), // 🇬🇭 GAF Navy Blue
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🎖 GAF Logo
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/gaf_logo.png'),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 20),

            Text(
              'GAF Training School',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Learning Support Module',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 30),

            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
