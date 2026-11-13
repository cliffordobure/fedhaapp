import 'dart:io' show Platform; // Import Platform to check the OS
import 'package:another_telephony/telephony.dart'
    if (dart.library.html) 'dummy.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/home/widgets/sms_dialog.dart';
// import 'package:fedha/services/sms_services.dart';
import 'package:fedha/utils/message_reading_service/scheduller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showSmsDialog(BuildContext context) async {
  Telephony? telephony;

  // Initialize Telephony instance conditionally
  if (Platform.isAndroid) {
    telephony = Telephony.instance;
  }

  var prefs = await SharedPreferences.getInstance();
  var messagingEnabled = prefs.getBool("MessageEnabled") ?? false;

  if (!messagingEnabled) {
    if (!context.mounted) return;

    final allowed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const SmsPermissionDialog();
      },
    );
    if (allowed == true) {
      // User allowed access to SMS messages
      prefs.setBool("MessageEnabled", true);

      // Check if telephony is initialized before requesting permissions
      bool permissionGranted = false;
      if (telephony != null) {
        permissionGranted = await telephony.requestSmsPermissions ?? false;
      }

      if (!context.mounted) return;
      if (!permissionGranted) {
        logger.warning("SMS read permission not granted");
        prefs.setBool("MessageEnabled", false);
        return;
      }

      // First-time connect: only ingest SMS from this moment forward.
      await ensureConnectedTimestamp(forceNow: true);
      // Link existing wallets → SUPPORTED_BANKS so filters do not drop SMS.
      await ensureSmsBanksForUserWallets();
      scheduleMessageReading();
      await startRealtimeSmsListening();
    } else {
      logger.info("User  rejected SMS permissions.");
      prefs.setBool("MessageEnabled", false);
    }
  } else {
    if (context.mounted) {
      await ensureSmsBanksForUserWallets();
      scheduleMessageReading();
      await startRealtimeSmsListening();
    }
  }
}
