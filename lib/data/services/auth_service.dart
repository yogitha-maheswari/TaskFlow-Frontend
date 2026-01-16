import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'http_exceptions.dart';

class AuthService {

  /* ---------------- REGISTER ---------------- */
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  /* ---------------- LOGIN ---------------- */
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    return jsonDecode(response.body);
  }

  /* ---------------- FORGOT PASSWORD ---------------- */
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/users/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    return jsonDecode(response.body);
  }

  /* ---------------- RESET PASSWORD ---------------- */
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/users/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    return jsonDecode(response.body);
  }
}
