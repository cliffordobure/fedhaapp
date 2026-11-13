import 'dart:async';

import 'package:fedha/fedhaapp.dart';
import 'package:fedha/services/links/deep_links.dart';
import 'package:fedha/utils/message_reading_service/scheduller.dart';
import 'package:fedha/utils/notifications_service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

// Define the method channel
const platform = MethodChannel('com.example.fedha/sms');

void main() async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  setUpService();

  WidgetsFlutterBinding.ensureInitialized();
  await AppLinksDeepLink.instance.initialize();

  tz.initializeTimeZones();

  await NotificationService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  void setupLogging() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        debugPrint('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
  }

  setupLogging();

  // Fire-and-forget service init; tracking floor is set inside initializeServices.
  unawaited(initializeServices());

  // Local-first: push/pull when connectivity returns.
  service<SyncEngine>().start();

  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(MyApp(navigatorKey: navigatorKey));
}
