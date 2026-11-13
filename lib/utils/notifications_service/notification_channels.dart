import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  //--------------------------------------
  // Common Android notification details
  //--------------------------------------
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'FedhaTrac', // Unique channel ID
    'FedhaTrac Notifications', // Channel name
    channelDescription: 'Channel for FedhaTrac notifications',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  // Common iOS (Darwin) notification details
  static const DarwinNotificationDetails _darwinNotificationDetails =
      DarwinNotificationDetails(
    threadIdentifier: 'com.fedha.fedhatrac', // Unique thread identifier
    categoryIdentifier:
        'FedhaTrac', // Category identifier for grouping notifications
  );

  // Platform-specific notification details for common notifications
  static const NotificationDetails platformNotificationDetails =
      NotificationDetails(
          android: _androidNotificationDetails,
          iOS: _darwinNotificationDetails);

  // Android notification channel setup
  static const AndroidNotificationChannel androidChannel =
      AndroidNotificationChannel(
    'FedhaTrac',
    'FedhaTrac Notifications',
    description: 'Channel for FedhaTrac notifications',
    importance: Importance.high,
  );

  //--------------------------------------
  // PlannedPayments Android notification details
  //--------------------------------------

  /// Android notification details for planned payments with action buttons
  static final AndroidNotificationDetails _androidDetailsPlannedPayments =
      AndroidNotificationDetails(
    androidChannel.id,
    androidChannel.name,
    channelDescription: androidChannel.description,
    importance: Importance.max,
    priority: Priority.max,
    actions: <AndroidNotificationAction>[
      const AndroidNotificationAction(
        'mark_paid',
        'Mark as Paid', // Label for the button
      ),
      const AndroidNotificationAction(
        'pay',
        'Pay', // Label for the button
      ),
    ],
  );

  /// Platform-specific notification details for planned payments
  static final NotificationDetails platformNotificationDetailsPlannedPayments =
      NotificationDetails(
          android: _androidDetailsPlannedPayments,
          iOS: _darwinNotificationDetails);
}
