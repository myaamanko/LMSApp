import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, String role) {
    final auth = Provider.of<AuthManager>(context, listen: false);
    auth.setRole(role);

    final roleDisplay = role == 'lecturer' ? 'Educator' : 'Student';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You selected: $roleDisplay')),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: isSmallScreen ? 20 : 40),
              SizedBox(
                height: isSmallScreen ? size.height * 0.25 : size.height * 0.35,
                child: Image.asset('assets/images/onboard_5.png', fit: BoxFit.contain),
              ),
              SizedBox(height: isSmallScreen ? 20 : 40),
              const Text(
                'You are a . . .',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Text('👩‍🎓'),
                      label: const Text('Student'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _selectRole(context, 'student'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Text('👨‍🏫'),
                      label: const Text('Educator'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _selectRole(context, 'lecturer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
