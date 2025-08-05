import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoPageTimer;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboard_1.png',
      'title': 'Welcome to GAF IT Group',
      'subtitle':
          'Where learning meets innovation!\nEmpowering your journey through cutting-edge IT education and expertise.',
    },
    {
      'image': 'assets/images/onboard_2.png',
      'title': 'Submit Assignments Easily',
      'subtitle': 'Track deadlines and manage your tasks seamlessly.',
    },
    {
      'image': 'assets/images/onboard_3.png',
      'title': 'Chat with Lecturers Instantly',
      'subtitle': 'Get real-time feedback and academic support.',
    },
  ];

  void _startAutoScroll() {
    _autoPageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < _pages.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _autoPageTimer?.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
      }
    });
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _autoPageTimer?.cancel();
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoPageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    key: ValueKey(index),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(
                          page['image']!,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page['title']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: () {
                  _autoPageTimer?.cancel();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text('SKIP'),
              ),
            ),
            // Dot indicators + Continue button
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 12 : 8,
                        height: _currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color:
                              _currentIndex == index
                                  ? Colors.indigo
                                  : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _nextPage,
                      child: const Text(
                        "CONTINUE",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
