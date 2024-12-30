import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduleDate) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    print("Gfsgljhfglkjhglkjdfsg");
    print(scheduleDate);
    final now = DateTime.now();
    final isToday = scheduleDate.year == now.year &&
        scheduleDate.month == now.month &&
        scheduleDate.day == now.day;
    if (isToday) {
      final adjustedTime = now.add(const Duration(minutes: 1));
      scheduleDate = DateTime(
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        adjustedTime.hour,
        adjustedTime.minute,
        adjustedTime.second,
      );
    }
    final tzDateTime = tz.TZDateTime.local(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      scheduleDate.hour,
      scheduleDate.minute,
      scheduleDate.second,
    );
print("Gfsgljhfglkjhglkjdfsg");
print(tzDateTime);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
