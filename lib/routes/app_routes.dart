import 'package:flutter/material.dart';
import '../views/auth/sign_in_screen.dart.dart';
import '../views/auth/role_selection_screen.dart';
import '../views/auth/sign_up_screen.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/splash/splash_screen.dart';

// import '../views/auth/register_screen.dart';
// import '../views/dashboard/student_dashboard.dart';
// import '../views/dashboard/lecturer_dashboard.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  static const String register = '/register';
  static const String studentDashboard = '/student_dashboard';
  static const String lecturerDashboard = '/lecturer_dashboard';
  static const String roleSelection = '/role_selection';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    login: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    // register: (context) => const RegisterScreen(),
    // studentDashboard: (context) => const StudentDashboard(),
    // lecturerDashboard: (context) => const LecturerDashboard(),
  };
}
