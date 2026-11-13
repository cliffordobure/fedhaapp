import 'package:app_settings/app_settings.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'recurrence_type.dart';

class NotificationUtils {
  static tz.TZDateTime getNextInstanceOfTime(
    RecurrenceType recurrenceType,
    TimeOfDay time, {
    int? dayOfMonth,
    int? month,
    int? dayOfWeek,
    int? minute,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      recurrenceType == RecurrenceType.yearly ? month ?? now.month : now.month,
      recurrenceType == RecurrenceType.monthly ||
              recurrenceType == RecurrenceType.yearly
          ? dayOfMonth ?? now.day
          : now.day,
      recurrenceType == RecurrenceType.hourly ? now.hour : time.hour,
      recurrenceType == RecurrenceType.minutely
          ? (minute ?? now.minute)
          : time.minute,
    );

    if (recurrenceType == RecurrenceType.weekly && dayOfWeek != null) {
      while (scheduledDate.weekday != dayOfWeek) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    if (scheduledDate.isBefore(now)) {
      switch (recurrenceType) {
        case RecurrenceType.minutely:
          scheduledDate = scheduledDate.add(const Duration(minutes: 1));
          break;
        case RecurrenceType.hourly:
          scheduledDate = scheduledDate.add(const Duration(hours: 1));
          break;
        case RecurrenceType.daily:
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          break;
        case RecurrenceType.weekly:
          scheduledDate = scheduledDate.add(const Duration(days: 7));
          break;
        case RecurrenceType.monthly:
          scheduledDate = tz.TZDateTime(
              tz.local,
              scheduledDate.year,
              scheduledDate.month + 1,
              dayOfMonth ?? scheduledDate.day,
              time.hour,
              time.minute);
          break;
        case RecurrenceType.yearly:
          scheduledDate = tz.TZDateTime(
              tz.local,
              scheduledDate.year + 1,
              month ?? scheduledDate.month,
              dayOfMonth ?? scheduledDate.day,
              time.hour,
              time.minute);
          break;
      }
    }

    return scheduledDate;
  }

  static DateTimeComponents? getDateTimeComponents(
      RecurrenceType recurrenceType) {
    switch (recurrenceType) {
      case RecurrenceType.minutely:
        return null; // No specific component for minutely
      case RecurrenceType.hourly:
        return DateTimeComponents.time;
      case RecurrenceType.daily:
        return DateTimeComponents.time;
      case RecurrenceType.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case RecurrenceType.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case RecurrenceType.yearly:
        return DateTimeComponents.dateAndTime;
    }
  }

  static void markPlannnedPaymentasPaid(Payment payment) {
    PlannedPaymentBloc().add(
      PlannedPaymentEvent.paymentHistoryAdded(
        id: payment.id,
        request: PaymentHistory(
          plannedPaymentsId: payment.id ?? 0,
          amount: payment.amount.toString(),
          paidAt: DateTime.now().toIso8601String(),
          userId: payment.userId,
        ),
      ),
    );
  }

  static Future<void> showNotificationSettingsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Enable Notifications"),
        content: const Text(
            "Notifications are disabled. Please enable them in your app settings."),
        actions: [
          TextButton(
            child: const Text("Go to Settings"),
            onPressed: () {
              Navigator.pop(context);
              _openAppSettings();
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Method to open app settings
  static Future<void> _openAppSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
    // Launch the app sett
  }
}

class Payment {
  final dynamic _id;
  final String _name;
  final double _amount;
  final int _userId;

  // Constructor
  Payment({
    required dynamic id,
    required String name,
    required double amount,
    required int userId,
  })  : _id = id,
        _name = name,
        _amount = amount,
        _userId = userId;

  // Getters for each property
  dynamic get id => _id;
  String get name => _name;
  double get amount => _amount;
  int get userId => _userId;
}
