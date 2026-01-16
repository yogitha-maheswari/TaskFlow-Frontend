import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app.dart';
import 'data/providers/notification_provider.dart';
import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔴 REQUIRED for Windows desktop plugins
  if (Platform.isWindows) {
    DartPluginRegistrant.ensureInitialized();
  }

  // 🔔 Local notifications (ALL platforms)
  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const TaskFlowApp(),
    ),
  );
}
