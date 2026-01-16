import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_colors.dart';
import '../../data/config/app_config.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/services/api_guard.dart';
import '../auth/register_page.dart';
import '../dashboard/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // UX delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await SecureStorage.getToken();
    final userId = await SecureStorage.getUserId();

    // ❌ No session → go to Register/Login
    if (token == null || userId == null) {
      _goToRegister();
      return;
    }

    // 🔐 Validate token with backend
    final isValid = await _verifyToken(token);

    if (!isValid) {
      // ❌ Invalid / expired token → force logout
      await SecureStorage.clearSession();
      _goToRegister();
      return;
    }

    // ✅ Token valid → start notifications
    context.read<NotificationProvider>().start(
          baseUrl: AppConfig.baseUrl,
          userId: userId,
          authToken: token,
        );

    // ➡️ Auto-login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  // ---------------------------
  // TOKEN VERIFICATION
  // ---------------------------
  Future<bool> _verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) return true;

      if (response.statusCode == 401) {
        await ApiGuard.handle401(context);
        return false;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  void _goToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  // ---------------------------
  // UI
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/images/logo.svg',
                width: 120,
                height: 120,
                colorFilter: ColorFilter.mode(
                  AppColors.border,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'TaskFlow',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: 15),
              Text(
                'Organize your work effortlessly',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

