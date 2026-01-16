import 'package:flutter/material.dart';
import '../../features/auth/login_page.dart';
import '../services/secure_storage_service.dart';


class ApiGuard {
  static Future<void> handle401(BuildContext context) async {
    await SecureStorage.clearSession();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}
