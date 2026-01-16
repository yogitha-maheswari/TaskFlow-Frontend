import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../features/models/task_model.dart';
import '../config/app_config.dart';
import 'secure_storage_service.dart';

class TaskService {
  // --------------------------------------------------
  // TOKEN
  // --------------------------------------------------
  static Future<String> _token() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception('Unauthorized');
    }
    return token;
  }

  // --------------------------------------------------
  // FETCH TASKS BY CATEGORY
  // --------------------------------------------------
  static Future<Map<String, dynamic>> fetchTasksByCategory({
    required String categoryId,
    String search = '',
  }) async {
    final token = await _token();

    final uri = Uri.parse(
      '${AppConfig.baseUrl}/api/tasks/category/$categoryId?search=$search',
    );

    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    return jsonDecode(res.body);
  }

  // --------------------------------------------------
  // CREATE TASK (🔥 MULTIPART — FIXED)
  // --------------------------------------------------
  static Future<void> createTask({
    required String categoryId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
    bool notify = false,

    // ✅ NEW
    List<File> images = const [],
    List<File> documents = const [],
    List<String> links = const [],
  }) async {
    final token = await _token();

    final uri = Uri.parse('${AppConfig.baseUrl}/api/tasks');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    // ------------------------------
    // FIELDS
    // ------------------------------
    request.fields.addAll({
      'categoryId': categoryId,
      'title': title,
      'description': description ?? '',
      'deadline': deadline?.toIso8601String() ?? '',
      'isImportant': isImportant.toString(),
      'notify': notify.toString(),
      'links': jsonEncode(links),
    });

    // ------------------------------
    // IMAGES
    // ------------------------------
    for (final img in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          img.path,
        ),
      );
    }

    // ------------------------------
    // DOCUMENTS
    // ------------------------------
    for (final doc in documents) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'documents',
          doc.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      final body = await response.stream.bytesToString();
      throw Exception(body);
    }
  }

  // --------------------------------------------------
  // UPDATE TASK (MULTIPART – FOR EDIT WITH FILES)
  // --------------------------------------------------
  static Future<void> updateTaskMultipart({
    required String taskId,
    required String title,
    String? description,
    DateTime? deadline,
    bool isImportant = false,
    bool notify = false,

    // attachments
    List<File> images = const [],
    List<File> documents = const [],
    List<String> links = const [],
  }) async {
    final token = await _token();

    final uri = Uri.parse('${AppConfig.baseUrl}/api/tasks/$taskId');
    final request = http.MultipartRequest('PUT', uri);

    request.headers['Authorization'] = 'Bearer $token';

  // ------------------------------
  // FIELDS
  // ------------------------------
  request.fields.addAll({
    'title': title,
    'description': description ?? '',
    'deadline': deadline?.toIso8601String() ?? '',
    'isImportant': isImportant.toString(),
    'notify': notify.toString(),
    'links': jsonEncode(links),
  });

  // ------------------------------
  // NEW IMAGES
  // ------------------------------
  for (final img in images) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        img.path,
      ),
    );
  }

  // ------------------------------
  // NEW DOCUMENTS
  // ------------------------------
  for (final doc in documents) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'documents',
        doc.path,
      ),
    );
  }

  final response = await request.send();

  if (response.statusCode != 200) {
    final body = await response.stream.bytesToString();
    throw Exception(body);
  }
}


  // --------------------------------------------------
  // TOGGLE COMPLETE
  // --------------------------------------------------
  static Future<void> toggleComplete(String taskId) async {
    final token = await _token();

    final res = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/api/tasks/$taskId/complete'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  // --------------------------------------------------
  // TOGGLE PRIORITY
  // --------------------------------------------------
  static Future<void> togglePriority(String taskId) async {
    final token = await _token();

    final res = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/api/tasks/$taskId/priority'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  // --------------------------------------------------
  // DELETE TASK
  // --------------------------------------------------
  static Future<void> deleteTask(String taskId) async {
    final token = await _token();

    debugPrint('DELETE TOKEN => $token');

    if (token.isEmpty) {
      throw Exception('Auth token missing');
    }

    final res = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/api/tasks/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  // --------------------------------------------------
  // FETCH TASK BY ID
  // --------------------------------------------------
  static Future<Task> fetchTaskById(String taskId) async {
    final token = await _token();

    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/tasks/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    return Task.fromJson(jsonDecode(res.body));
  }
}
