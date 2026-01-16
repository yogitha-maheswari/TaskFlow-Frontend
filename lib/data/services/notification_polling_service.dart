import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'notification_event.dart';
import 'notification_service.dart';

class NotificationPollingService {
  Timer? _timer;
  final Set<String> _shownNotifications = {};

  // 🔔 Stream for in-app alerts (Windows)
  final StreamController<NotificationEvent> _controller =
      StreamController.broadcast();

  Stream<NotificationEvent> get stream => _controller.stream;

  void start({
    required String baseUrl,
    required String authToken,
  }) {
    debugPrint('⏱️ NotificationPollingService started');
    
    stop();

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) async {
        debugPrint('🔄 Polling tick');
        try {
          final response = await http.get(
            Uri.parse('$baseUrl/api/notifications/pending'),
            headers: {
              'Authorization': 'Bearer $authToken',
            },
          ).timeout(const Duration(seconds: 5));

          // 🔍 DEBUG LOGS (ADD HERE)
          print('📡 Status: ${response.statusCode}');
          print('📦 Body: ${response.body}');


          if (response.statusCode != 200) return;

          final data = jsonDecode(response.body);
          if (data['success'] != true) return;

          final List notifications = data['notifications'] ?? [];

          print('🔔 Notifications received: ${notifications.length}');

          final now = DateTime.now();

          for (final n in notifications) {
            final hourKey =
                '${now.year}-${now.month}-${now.day}-${now.hour}';
            final id =
                '${n['taskId']}_${n['hoursLeft']}_$hourKey';

            if (_shownNotifications.contains(id)) continue;
            _shownNotifications.add(id);

            // 🪟 WINDOWS → IN-APP ALERT
            if (Platform.isWindows) {
              // 🪟 Windows SYSTEM notification
              await NotificationService.showNotification(
                title: n['title'],
                body: n['message'],
              );

              // 🪟 Optional: also show in-app snackbar
              _controller.add(
                NotificationEvent(
                  title: n['title'],
                  message: n['message'],
                ),
              );
            }
          }
        }
        catch (e, s) {
          print('❌ Polling error: $e');
          print(s);
        }

      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _shownNotifications.clear();
  }

  void dispose() {
    _controller.close();
  }
}
