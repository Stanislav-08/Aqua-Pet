import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    await _plugin.initialize(settings: initSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id: 1, title: title, body: body, notificationDetails: details);
  }
}