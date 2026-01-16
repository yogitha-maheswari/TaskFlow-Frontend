import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'secure_storage_service.dart';
import 'http_exceptions.dart';

class DashboardService {
  static Future<Map<String, dynamic>> fetchDashboard({
    String search = '',
  }) async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final uri = Uri.parse(
      '${AppConfig.baseUrl}/api/dashboard'
      '${search.isNotEmpty ? '?search=$search' : ''}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    return jsonDecode(response.body);
  }
}
