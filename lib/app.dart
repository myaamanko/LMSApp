import 'package:flutter/material.dart';
import 'package:lsm/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';

class LSMApp extends StatelessWidget {
  const LSMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthManager>(create: (_) => AuthManager()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // Add more providers as you create them
      ],
      child: MaterialApp(
        title: 'LSM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
