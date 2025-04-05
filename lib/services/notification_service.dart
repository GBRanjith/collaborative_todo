// services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
 
  factory NotificationService() {
    return _instance;
  }
 
  NotificationService._internal();
 
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
 
  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
   
    // Initialize Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
   
    // Initialize iOS settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
   
    // Initialize settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
   
    // Initialize notifications plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }
 
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tapped
    final String? payload = response.payload;
    if (payload != null) {
      debugPrint('Notification payload: $payload');
      // Navigate to specific task or screen based on payload
      // Implementation depends on navigation setup
    }
  }
 
  // Schedule a task reminder notification
  Future<void> scheduleTaskReminder(int id, String title, String body, DateTime scheduledDate, {String? payload}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders_channel',
          'Task Reminders',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
 
  // Show an immediate notification
  Future<void> showNotification(int id, String title, String body, {String? payload}) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'general_notifications_channel',
          'General Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
 
  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
 
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
