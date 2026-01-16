import 'package:flutter/material.dart';

// Splash
import '../features/splash/splash_page.dart';

// Auth
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';
import '../features/auth/forgot_password_page.dart';
import '../features/auth/reset_password_page.dart';

// Main App
import '../features/category/category_page.dart';
import '../features/dashboard/dashboard_page.dart';

// Tasks
import '../features/models/create_task_model.dart';
import '../features/models/edit_task_model.dart';
import '../features/models/task_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  static const String dashboard = '/dashboard';
  static const String category = '/category';

  static const String createTask = '/create-task';
  static const String editTask = '/edit-task';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // Splash
      case splash:
        return _page(const SplashPage());

      // Auth
      case register:
        return _page(const RegisterPage());

      case login:
        return _page(const LoginPage());

      case forgotPassword:
        return _page(const ForgotPasswordPage());

      case resetPassword:
        final email = settings.arguments as String;
        return _page(ResetPasswordPage(email: email));

      // Dashboard
      case dashboard:
        return _page(const DashboardPage());

      // Category
      case category:
        final args = settings.arguments as Map<String, dynamic>;
        return _page(
          CategoryPage(
            categoryId: args['id'],
            categoryName: args['name'],
          ),
        );

      // Create Task (🔥 FIXED)
      case createTask:
        final categoryId = settings.arguments as String;
        return _dialog(
          CreateTaskModal(categoryId: categoryId),
        );

      // Edit Task
      case editTask:
        final task = settings.arguments as Task;
        return _dialog(EditTaskModal(task: task));

      default:
        return _page(
          Scaffold(
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
    }
  }

  static PageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  static PageRoute _dialog(Widget child) {
    return PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
