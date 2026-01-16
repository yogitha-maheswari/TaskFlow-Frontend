import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'secure_storage_service.dart';

class CategoryService {
  static Future<String?> _token() async {
    return SecureStorage.getToken();
  }

  // ------------------------------
  // CREATE CATEGORY (FIXED)
  // ------------------------------
  static Future<Map<String, dynamic>> createCategory({
    required String name,
    required String icon,
  }) async {
    final token = await _token();

    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'icon': icon, // ✅ CORRECTLY SENT
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Failed to create category');
    }

    // ✅ RETURN CREATED CATEGORY
    return jsonDecode(res.body);
  }

  // ------------------------------
  // UPDATE CATEGORY (FIXED)
  // ------------------------------
  static Future<Map<String, dynamic>> updateCategory({
    required String id,
    required String name,
    required String icon,
  }) async {
    final token = await _token();

    final res = await http.put(
      Uri.parse('${AppConfig.baseUrl}/api/categories/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'icon': icon,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update category');
    }

    return jsonDecode(res.body);
  }

  // ------------------------------
  // DELETE CATEGORY (FIXED)
  // ------------------------------
  static Future<void> deleteCategory(String id) async {
    final token = await _token();

    final res = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/api/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
