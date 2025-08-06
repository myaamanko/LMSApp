import 'package:flutter/material.dart';
import 'package:lsm/views/chats/chat_screen.dart';
import 'package:lsm/views/dashboard/educator_dashboard.dart';
import 'package:lsm/views/dashboard/student/student_dashboard.dart';
import 'package:lsm/views/auth/sign_in_screen.dart';
import 'package:lsm/views/auth/sign_up_screen.dart';
import 'package:lsm/views/auth/role_selection_screen.dart';
import 'package:lsm/views/onboarding/onboarding_screen.dart';
import 'package:lsm/views/splash/splash_screen.dart';

// Drawer-related screens
// import 'package:lsm/views/student/teachers_screen.dart';
// import 'package:lsm/views/student/students_screen.dart';
// import 'package:lsm/views/student/fees_screen.dart';
// import 'package:lsm/views/student/calendar_screen.dart';
// import 'package:lsm/views/student/timetable_screen.dart';
// import 'package:lsm/views/student/messages_screen.dart';
// import 'package:lsm/views/student/settings_screen.dart';

class AppRoutes {
  // ✅ Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role_selection';

  static const String studentDashboard = '/student_dashboard';
  static const String lecturerDashboard = '/lecturer_dashboard';

  static const String chats = '/chats';
  static const String teachers = '/teachers';
  static const String students = '/students';
  static const String fees = '/fees';
  static const String calendar = '/calendar';
  static const String timetable = '/timetable';
  static const String messages = '/messages';
  static const String settings = '/settings';

  // ✅ Route mappings
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),

    studentDashboard: (context) => const StudentDashboard(),
    lecturerDashboard: (context) => const EducatorDashboard(),

    chats: (context) => const ChatScreen(),
    // teachers: (context) => const TeachersScreen(),
    // students: (context) => const StudentsScreen(),
    // fees: (context) => const FeesScreen(),
    // calendar: (context) => const CalendarScreen(),
    // timetable: (context) => const TimeTableScreen(),
    // messages: (context) => const MessagesScreen(),
    // settings: (context) => const SettingsScreen(),
  };
}
