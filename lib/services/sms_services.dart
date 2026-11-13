import 'package:flutter/services.dart';

/// Legacy MethodChannel bridge. Real SMS ingest uses [scheduller.dart]
/// (`processIncomingSmsMessage` / Workmanager). Do not show notifications here —
/// every inbox SMS would fire, including non-transaction messages.
class SmsService {
  static final SmsService _instance = SmsService._internal();

  factory SmsService() {
    return _instance;
  }

  SmsService._internal();

  final MethodChannel _platform = const MethodChannel('com.example.fedha/sms');

  void initialize() {
    _platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'readMessage':
        return readMessage(
          Map<String, dynamic>.from(call.arguments as Map? ?? {}),
        );
      default:
        print('Unknown method ${call.method}');
    }
  }

  Future<void> readMessage(Map<String, dynamic> messageData) async {
    // Intentionally silent: transaction notifications are owned by scheduller
    // after a successful parse of a bank/M-Pesa SMS into a new local row.
    print(
      'Received SMS (no notify): ${messageData['body']} from ${messageData['sender']}',
    );
  }
}
