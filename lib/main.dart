import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lsm/providers/fee_provider.dart';
import 'package:lsm/providers/student_provider.dart';
import 'package:lsm/providers/teacher_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/chat_provider.dart';
import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
      ],
      child: const LSMApp(),
    ),
  );
}

class LSMApp extends StatelessWidget {
  const LSMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LSM App',
      debugShowCheckedModeBanner: false,
      initialRoute:
          AppRoutes.splash, // or AppRoutes.main if you're skipping splash
      routes: AppRoutes.routes,
    );
  }
}
