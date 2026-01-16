import 'package:flutter/material.dart';
import '../services/notification_polling_service.dart';
import '../services/notification_event.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationPollingService _pollingService =
      NotificationPollingService();

  bool _started = false;

  Stream<NotificationEvent> get stream =>
      _pollingService.stream;

  void start({
    required String baseUrl,
    required String userId,
    required String authToken,
  }) {
    debugPrint('🔔 NotificationProvider.start() called');
    
    if (_started) {
      debugPrint('⚠️ Polling already started');
      return;
    }

    _pollingService.start(
      baseUrl: baseUrl,
      authToken: authToken,
    );

    _started = true;
  }

  void stop() {
    _pollingService.stop();
    _started = false;
  }
}
