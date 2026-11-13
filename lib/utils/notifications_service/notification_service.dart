import 'dart:convert';

import 'package:fedha/data/models/notifications/notification_payload.dart';
import 'package:fedha/utils/notifications_service/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'notification_channels.dart';
import 'notification_settings.dart';
import 'recurrence_type.dart';
import 'notification_utils.dart';

/// This class is a service that manages local notifications in a Flutter app using the flutter_local_notifications package.
/// It handles initializing the notification system, scheduling notifications, managing permissions, and handling user interaction with notifications.

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android 12+ may deny exact alarms — fall back to inexact so saves never crash.
  static Future<void> _zonedScheduleSafe({
    required int id,
    required String? title,
    required String? body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    Future<void> schedule(AndroidScheduleMode mode) {
      return flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchDateTimeComponents,
        payload: payload,
      );
    }

    try {
      await schedule(AndroidScheduleMode.exactAllowWhileIdle);
    } on PlatformException catch (e) {
      if (e.code == 'exact_alarms_not_permitted') {
        debugPrint(
            'Exact alarms not permitted — using inexact schedule for #$id');
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
      } else {
        rethrow;
      }
    }
  }

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      NotificationSettings.initializationSettings,
      onDidReceiveNotificationResponse:
          NotificationHandler.onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          NotificationHandler.onNotificationTapped,
    );

    await _requestIOSPermissions();
    await _createAndroidNotificationChannel();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> _requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> checkNotificationPermissions(BuildContext context) async {
    bool? isPermissionGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    if (isPermissionGranted == false) {
      if (!context.mounted) return;
      await NotificationUtils.showNotificationSettingsDialog(context);
    }
  }

  static Future<void> _createAndroidNotificationChannel() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannels.androidChannel);
  }

  static Future<void> showImmediateNotification(
    String title,
    String body, {
    NotificationDetails? notificationDetails,
    NotificationPayload? payload,
  }) async {
    debugPrint("Immediate notification has been called");

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails ?? NotificationChannels.platformNotificationDetails,
      payload: jsonEncode(payload?.toJson()),
    );
  }

  ///This method schedules recurring notifications based on the given recurrence type (e.g., daily, weekly, monthly).
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required RecurrenceType recurrenceType,
    required TimeOfDay time,
    int? dayOfMonth,
    int? month,
    int? dayOfWeek,
    int? minute,
    NotificationDetails? notificationDetails,
    NotificationPayload? payload,
  }) async {
    debugPrint("Recurring notification has been scheduled");
    tz.TZDateTime scheduledDate = NotificationUtils.getNextInstanceOfTime(
      recurrenceType,
      time,
      dayOfMonth: dayOfMonth,
      month: month,
      dayOfWeek: dayOfWeek,
      minute: minute,
    );
    if (recurrenceType == RecurrenceType.minutely) {
      _scheduleMinutelyNotification(id, title, body, scheduledDate);
    }
    await _zonedScheduleSafe(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails:
          notificationDetails ?? NotificationChannels.platformNotificationDetails,
      matchDateTimeComponents:
          NotificationUtils.getDateTimeComponents(recurrenceType),
      payload: jsonEncode(payload?.toJson()),
    );
  }

  ///This private method is used specifically for scheduling notifications that recur every minute.
  static Future<void> _scheduleMinutelyNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime initialTime, {
    NotificationDetails? notificationDetails,
    NotificationPayload? payload,
  }) async {
    // Schedule the first notification
    await _zonedScheduleSafe(
      id: id,
      title: title,
      body: body,
      scheduledDate: initialTime,
      notificationDetails:
          notificationDetails ?? NotificationChannels.platformNotificationDetails,
      payload: jsonEncode(payload?.toJson()),
    );

    // Schedule the next 59 notifications (for a total of 60 minutes)
    for (int i = 1; i < 60; i++) {
      await _zonedScheduleSafe(
        id: id + i,
        title: title,
        body: body,
        scheduledDate: initialTime.add(Duration(minutes: i)),
        notificationDetails: notificationDetails ??
            NotificationChannels.platformNotificationDetails,
        payload: jsonEncode(payload?.toJson()),
      );
    }
  }

  ///This method schedules a one-time notification to be triggered at a specific future time (`scheduledDateTime`).
  static Future<void> scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    NotificationDetails? notificationDetails,
    NotificationPayload? payload,
  }) async {
    debugPrint("One-time notification has been scheduled");
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _zonedScheduleSafe(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails:
          notificationDetails ?? NotificationChannels.platformNotificationDetails,
      payload: jsonEncode(payload?.toJson()),
    );
  }

  ///This method:
  ///- Parses the payment date.
  ///- Determines the recurrence type based on the frequency.
  ///- Schedules either a recurring notification or a one-time notification based on the frequency.
  static Future<void> schedulePlannedPaymentNotification(
      {required dynamic id,
      required String name,
      required String amount,
      required String paymentDate,
      required String frequency,
      required int userid}) async {
    try {
      final DateTime parsedDate = DateTime.parse(paymentDate);
      final TimeOfDay time =
          TimeOfDay(hour: parsedDate.hour, minute: parsedDate.minute);

      RecurrenceType recurrenceType;

      switch (frequency.toLowerCase()) {
        case 'daily':
          recurrenceType = RecurrenceType.daily;
          break;
        case 'weekly':
          recurrenceType = RecurrenceType.weekly;
          break;
        case 'monthly':
          recurrenceType = RecurrenceType.monthly;
          break;
        case 'yearly':
          recurrenceType = RecurrenceType.yearly;
          break;
        default:
          await scheduleOneTimeNotification(
            id: id is int ? id : int.tryParse('$id') ?? 0,
            title: '$name is Due',
            body: "$name of KES $amount is due for payment today",
            scheduledDateTime: parsedDate,
          );
          return;
      }

      await scheduleNotification(
        id: id is int ? id : int.tryParse('$id') ?? 0,
        title: '$name is Due',
        body: "$name of KES $amount is due for payment today",
        recurrenceType: recurrenceType,
        time: time,
        dayOfMonth: parsedDate.day,
        month: parsedDate.month,
        dayOfWeek: parsedDate.weekday,
        notificationDetails:
            NotificationChannels.platformNotificationDetailsPlannedPayments,
        payload: NotificationPayload(
          type: "planned_payment",
          data: {
            'id': id,
            'name': name,
            'amount': double.tryParse(amount) ?? 0,
            'userId': userid
          },
        ),
      );
    } catch (e, st) {
      // Never fail payment save because reminders could not be scheduled.
      debugPrint('Planned payment reminder skipped: $e\n$st');
    }
  }

  static Future<List<PendingNotificationRequest>>
      getScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  /// This function cancells a specific schedulled notifications identified by `id`
  static Future<void> cancelNotification(dynamic id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  ///This function cancells  all scheduled notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
