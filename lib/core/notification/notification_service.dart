import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  /// Initialize the notification service
  void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'task_reminders',
          channelName: 'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );
  }

  /// Request permission to send notifications
  Future<void> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Schedule a task reminder
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime scheduleTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: int.parse(taskId), // Unique ID for the notification
        channelKey: 'task_reminders',
        title: 'Reminder: $taskTitle',
        body: 'You have a task due soon!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduleTime.year,
        month: scheduleTime.month,
        day: scheduleTime.day,
        hour: scheduleTime.hour,
        minute: scheduleTime.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );
  }

  /// Cancel a specific task reminder
  Future<void> cancelTaskReminder(String taskId) async {
    await AwesomeNotifications().cancel(int.parse(taskId));
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  /// Get a list of scheduled notifications
  Future<List<NotificationModel>> getScheduledNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }

  /// Handle notification taps
  void listenToNotificationTaps() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        print("fsdfsdjfjsdofosonActionReceivedMethod");
        print(receivedAction.actionType);
      },
      onNotificationCreatedMethod: (ReceivedNotification receivedNotification) async {
        print("fsdfsdjfjsdofosonNotificationCreatedMethod");
        print(receivedNotification.actionType);
      },
      onNotificationDisplayedMethod: (ReceivedNotification receivedNotification) async {
        print("fsdfsdjfjsdofosonNotificationDisplayedMethod");
        print(receivedNotification.actionType);
      },
      onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
        print("fsdfsdjfjsdofosonDismissActionReceivedMethod");
        print(receivedAction.actionType);
      },
    );
  }
}
