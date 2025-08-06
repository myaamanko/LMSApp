import 'package:flutter/material.dart';
import 'package:lsm/fees/fees_screen.dart';
import 'package:lsm/views/chats/chats_details.dart';
import 'package:lsm/views/dashboard/educator_dashboard.dart';
import 'package:lsm/views/auth/sign_in_screen.dart'; // ✅ Fixed filename
import 'package:lsm/views/auth/role_selection_screen.dart';
import 'package:lsm/views/auth/sign_up_screen.dart';
import 'package:lsm/views/dashboard/student/student_dashboard.dart';
import 'package:lsm/views/onboarding/onboarding_screen.dart';
import 'package:lsm/views/splash/splash_screen.dart';



import '../student/students_screen.dart';
import '../teachers/teachers_screen.dart';
import '../views/auth/sign_in_screen.dart';
import '../views/chats/chat_list_screen.dart';
import '../views/dashboard/student/timetable_screen.dart';

class AppRoutes {
  // ✅ Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role_selection';

  static const String studentDashboard = '/student_dashboard';
  static const String lecturerDashboard = '/lecturer_dashboard';
static const String timetable='/timetable';
  static const String chats = '/chats';
  static const String classes = '/classes';
  static const String assignments = '/assignments';
  static const String settings = '/settings';
  static const String fees = '/fees';
  static const String teachers = '/teachers';
  static const String students = '/students';

  // ✅ Route mappings
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
  timetable: (context) => const TimeTableScreen(),
    studentDashboard: (context) => const StudentDashboard(),
    lecturerDashboard: (context) => const EducatorDashboard(),
    fees: (context) => const FeeScreen(),
    chats: (context) => const ChatListScreen(),
    teachers: (context) => const TeachersScreen(),
    students: (context) => const StudentsScreen(),
    // classes: (context) => const ClassesScreen(), // ✅ New
    // assignments: (context) => const AssignmentsScreen(), // ✅ New
    // settings: (context) => const SettingsScreen(), // ✅ New
  };
}
