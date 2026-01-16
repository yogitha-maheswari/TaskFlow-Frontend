import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings;

    if (Platform.isWindows) {
      const windowsInit = WindowsInitializationSettings(
        appName: 'TaskFlow',
        appUserModelId: 'com.taskflow.app',
        guid: 'D6A1B6F1-9F4C-4A73-9B9A-1C0A1A5F8B12',
      );

      settings = const InitializationSettings(
        windows: windowsInit,
      );
    } else {
      settings = const InitializationSettings(
        android: androidInit,
      );
    }

    // 🔑 Initialize plugin
    await _plugin.initialize(settings);

    // ✅ ANDROID 13+ — request notification permission
    if (!Platform.isWindows) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final NotificationDetails details;

    if (Platform.isWindows) {
      const windowsDetails = WindowsNotificationDetails();
      details = const NotificationDetails(windows: windowsDetails);
    } else {
      const androidDetails = AndroidNotificationDetails(
        'task_reminders',
        'Task Reminders',
        channelDescription: 'Hourly task reminders',
        importance: Importance.max,
        priority: Priority.high,
      );
      details = const NotificationDetails(android: androidDetails);
    }

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
