import 'dart:convert';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fedha/data/models/notifications/notification_payload.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_utils.dart';

class NotificationHandler {
  static void onNotificationTapped(NotificationResponse details) async {
    final String? payload = details.payload;
    if (payload == null) return;

    try {
      final NotificationPayload payloadData =
          NotificationPayload.fromJson(jsonDecode(payload));
      logger.info('Notification tapped with type: ${payloadData.type}');

      final String responseType = details.notificationResponseType.name;
      if (responseType == "selectedNotificationAction") {
        await _handleAction(details.actionId ?? "default", payloadData.data);
      } else if (responseType == "selectedNotification") {
        await _handlePayloadType(payloadData.type, payloadData.data);
      }
    } catch (e) {
      logger.severe('Error handling notification tap: $e');
    }
  }

  static Future<void> _handleAction(
      String actionId, Map<String, dynamic> paymentDetails) async {
    switch (actionId) {
      case 'mark_paid':
        await _markPaymentAsPaid(paymentDetails);
        break;
      case 'immediate':
        logger.info("Immediate action: $paymentDetails");
        await _navigateBasedOnLoginStatus('/analytics', paymentDetails);
        break;
      default:
        logger.warning('Unknown action: $actionId');
    }
  }

  static Future<void> _handlePayloadType(
      String payloadType, Map<String, dynamic> payloadData) async {
    switch (payloadType) {
      case 'immediate':
        logger.info("Immediate payload: $payloadData");
        await _navigateBasedOnLoginStatus(Routes.analytics, payloadData);
        break;
      default:
        logger.warning('Unknown payload type: $payloadType');
    }
  }

  static Future<void> _markPaymentAsPaid(
      Map<String, dynamic> paymentDetails) async {
    try {
      final Payment payment = Payment(
        id: paymentDetails['id'],
        name: paymentDetails['name'],
        amount: paymentDetails['amount'],
        userId: paymentDetails['userId'],
      );
      NotificationUtils.markPlannnedPaymentasPaid(payment);
      logger.info("Planned payment marked as paid: $paymentDetails");
    } catch (e) {
      logger.severe("Error marking payment as paid: $e");
    }
  }

  static Future<void> _navigateBasedOnLoginStatus(
      String route, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      router.pushNamed(route, extra: data);
    } else {
      // Store the intended destination and data
      await prefs.setString('pendingNavigation', route);
      await prefs.setString('pendingNavigationData', jsonEncode(data));
      router.pushNamed(Routes.login);
    }
  }
}
