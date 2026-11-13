// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotifyHelper {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin(); //

//   Future<void> initializeNotification() async {
//     await _configureLocalTimeZone();

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("appicon");

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       iOS: initializationSettingsIOS,
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//   }

//   Future<void> onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (payload != null) {
//       debugPrint('notification payload test: $payload');
//     } else {
//       debugPrint('notification done');
//     }
//     // Add your navigation logic or any other actions you want to take on notification tap
//   }

//   Future onDidReceiveLocalNotification(BuildContext? context, int? id,
//       String? title, String? body, String? payload) async {
//     // Display a dialog with the notification details, tap ok to go to another page
//     showDialog(
//       context: context!,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(title!),
//         content: Text(body!),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: const Text('Ok'),
//             onPressed: () async {
//               Navigator.of(context, rootNavigator: true).pop();
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Container(),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> displayNotification(
//       {required String title, required String body}) async {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: "$title|$body",
//     );
//   }

//   Future<void> scheduledNotification(
//     int hour,
//     int minutes,
//     String body,
//   ) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       "A bill is due today",
//       body,
//       _convertTime(hour, minutes),
//       const NotificationDetails(
//           android: AndroidNotificationDetails(
//               'your_channel_id', 'your_channel_name',
//               channelDescription: 'your channel description')),
//       androidAllowWhileIdle: true,
//       payload: "${"task.title"}|$body|",
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }
//     return scheduleDate;
//   }

//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones();
//     final String timeZoneName = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName));
//   }
// }
