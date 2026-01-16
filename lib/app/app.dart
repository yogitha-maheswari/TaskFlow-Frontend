import 'package:flutter/material.dart';
import '../features/splash/splash_page.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      // 👇 keep your splash as-is
      home: const SplashPage(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
