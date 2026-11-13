import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSettings {
  static const AndroidInitializationSettings _initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/notification_icon');

  static const DarwinInitializationSettings _initializationSettingsDarwin =
      DarwinInitializationSettings();

  static const InitializationSettings initializationSettings =
      InitializationSettings(
          android: _initializationSettingsAndroid,
          iOS: _initializationSettingsDarwin);
}
