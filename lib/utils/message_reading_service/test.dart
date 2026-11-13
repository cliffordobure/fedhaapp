// import 'dart:io';
// import 'dart:convert';

// import 'package:fedha/data/models/multiple_result/multiple_result.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart' as wm;

// import 'package:fedha/constants/constants.dart';
// import 'package:fedha/data/models/bank/bank.dart';
// import 'package:fedha/data/models/remote_message/transaction_messages.dart';
// import 'package:fedha/data/models/transactions/transactions.dart';
// import 'package:fedha/localization/app_prefs.dart';
// import 'package:fedha/utils/notifications/floating_notifications.dart';
// import 'package:fedha/utils/message_reading/parser.dart';
// import 'package:fedha/utils/utils.dart';
// import 'package:fedha/data/services/service.dart';

// const String MESSAGE_READING_TASK = 'readMessages';
// const Duration MESSAGE_READING_FREQUENCY = Duration(minutes: 15);
// const Duration MESSAGE_READING_INITIAL_DELAY = Duration(minutes: 0);

// void initializeDependencies() {
//   setUpService();
// }

// Future<void> initializeServices() async {
//   try {
//     initializeDependencies();
//     await Workmanager().initialize(callbackDispatcher);
//     await NotificationService.initialize();

//     final appPrefs = service<AppPreferences>();
//     logger.info("auth data is : ${await appPrefs.getAuthData()}");
//     if (!await appPrefs.hasInstallationDate()) {
//       final now = DateTime.now();
//       await appPrefs.setInstallationDate(now.millisecondsSinceEpoch);
//     }
//   } catch (e) {
//     logger.severe('Failed to initialize services: $e');
//     // Consider showing a user-facing error message here
//   }
// }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     initializeDependencies();
//     logger.info("Background task started: $task at ${DateTime.now()}");
//     try {
//       switch (task) {
//         case MESSAGE_READING_TASK:
//           await performMessageReading(inputData);
//           break;
//         default:
//           logger.warning('Unknown task: $task');
//           return Future.value(false);
//       }
//       logger.info("Task completed successfully at ${DateTime.now()}");
//       return Future.value(true);
//     } catch (e, stackTrace) {
//       logger.severe('Task failed: $task', e, stackTrace);
//       // Consider reporting this error to a logging service
//       return Future.value(false);
//     }
//   });
// }

// Future<void> performMessageReading(Map<String, dynamic>? inputData) async {
//   logger.info("Starting readMessages");
//   int newTimestamp = await readMessages(inputData);
//   logger.info("readMessages completed, new timestamp: $newTimestamp");
//   await _updateLastReadTimestamp(newTimestamp);
//   logger.info("Timestamp updated");
// }

// Future<void> _updateLastReadTimestamp(int timestamp) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setInt('lastReadTimestamp', timestamp);
//   logger.info("Updated lastReadTimestamp: $timestamp");
// }

// Future<int> readMessages(Map<String, dynamic>? inputData) async {
//   final appPrefs = service<AppPreferences>();
//   logger.info("readMessages function called");
//   logger.info("auth data is : ${await appPrefs.getAuthData()}");
//   final Telephony telephony = Telephony.instance;
//   final prefs = await SharedPreferences.getInstance();

//   int installationDate = await appPrefs.getInstallationDate() ?? 0;
//   int lastReadTimestamp = prefs.getInt('lastReadTimestamp') ?? installationDate;

//   DateTime startDateTime =
//       _getStartDateTime(installationDate, lastReadTimestamp);
//   int startTimestamp = startDateTime.millisecondsSinceEpoch;

//   List<SmsMessage> messages = await _fetchMessages(telephony, startTimestamp);
//   List<SmsMessage> filteredMessages = _filterMessages(messages);

//   TransactionMessageList transactionsList =
//       await _processMessages(filteredMessages);

//   int latestMessageTimestamp =
//       _getLatestMessageTimestamp(filteredMessages, lastReadTimestamp);

//   if (transactionsList.transactions.isNotEmpty) {
//     await _handleNewTransactions(transactionsList, inputData);
//   } else {
//     logger.info("No new transactions to process");
//   }

//   return latestMessageTimestamp;
// }

// DateTime _getStartDateTime(int installationDate, int lastReadTimestamp) {
//   if (lastReadTimestamp == installationDate) {
//     return DateTime.fromMillisecondsSinceEpoch(installationDate)
//         .subtract(const Duration(days: 7));
//   } else {
//     return DateTime.fromMillisecondsSinceEpoch(lastReadTimestamp);
//   }
// }

// Future<List<SmsMessage>> _fetchMessages(
//     Telephony telephony, int startTimestamp) async {
//   return await telephony.getInboxSms(
//     columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//     sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
//     filter: SmsFilter.where(SmsColumn.DATE)
//         .greaterThanOrEqualTo(startTimestamp.toString()),
//   );
// }

// List<SmsMessage> _filterMessages(List<SmsMessage> messages) {
//   return messages.where((message) {
//     return message.address != null && supportedBanks.contains(message.address);
//   }).toList();
// }

// Future<TransactionMessageList> _processMessages(
//     List<SmsMessage> messages) async {
//   TransactionMessageList transactionsList =
//       const TransactionMessageList(transactions: []);

//   for (SmsMessage message in messages) {
//     Map<String, dynamic> details =
//         await TransactionExtractor.extractTransactionDetails(message, service);

//     if (details.isNotEmpty) {
//       details["type"] = classifyTransactionType(details);
//       logger.info("Transaction type is : ${details['type']}");
//       details["to"] = isFulizaTransfer(details)
//           ? "Fuliza"
//           : details.containsKey("to")
//               ? details["to"]
//               : details.containsKey("recipient_or_sender")
//                   ? details["recipient_or_sender"]
//                   : "N/A";
//       TransactionMessage transaction = TransactionMessage.fromJson(details);

//       transactionsList = addTransaction(transactionsList, transaction);
//     }
//   }

//   return transactionsList;
// }

// int _getLatestMessageTimestamp(
//     List<SmsMessage> messages, int lastReadTimestamp) {
//   return messages.fold(lastReadTimestamp, (maxTimestamp, message) {
//     return message.date != null && message.date! > maxTimestamp
//         ? message.date!
//         : maxTimestamp;
//   });
// }

// Future<void> _handleNewTransactions(TransactionMessageList transactionsList,
//     Map<String, dynamic>? inputData) async {
//   await writeTransactionsToFile(transactionsList);

//   await NotificationService.showImmediateNotification("New Transactions",
//       "${transactionsList.transactions.length} new transactions obtained");

//   List<TransactionData> transactionData =
//       await _convertToTransactionData(transactionsList);

//   logger
//       .info("The number of items to be uploaded is: ${transactionData.length}");
//   await uploadMessages(transactionData);
// }

// Future<List<TransactionData>> _convertToTransactionData(
//     TransactionMessageList transactionsList) async {
//   double parseDouble(dynamic value) {
//     if (value is int) {
//       return value.toDouble();
//     } else if (value is String) {
//       return double.tryParse(value) ?? 0.0;
//     } else {
//       return 0.0;
//     }
//   }

//   final walletService = service<BanksService>();
//   MultipleResult<List<Bank>> result = await walletService.fetchBanks();

//   List<Bank> wallets = result.when(
//     onSuccess: (data) => data,
//     onError: (error) {
//       logger.severe('Failed to fetch banks: $error');
//       return []; // Return an empty list or handle the error as appropriate
//     },
//   );

//   logger.info(wallets);

//   return transactionsList.transactions.map((transaction) {
//     return TransactionData(
//       name: transaction.to ?? transaction.from ?? "Account Transfer",
//       wallet: wallets
//           .firstWhere(
//             (element) => element.name == transaction.account,
//             orElse: () => const Bank(
//                 id: 14,
//                 name: 'Unknown',
//                 shortname: 'mpesa',
//                 img: '',
//                 status: 400,
//                 createdAt: '',
//                 updatedAt: ''),
//           )
//           .id,
//       amount: parseDouble(transaction.amount ?? 0.0),
//       charges: parseDouble(transaction.cost ?? 0),
//       datetime: transaction.datetime,
//       code: transaction.reference ?? '',
//       type: transaction.type ?? '',
//     );
//   }).toList();
// }

// TransactionMessageList addTransaction(
//     TransactionMessageList transactionsList, TransactionMessage transaction) {
//   if (transaction.amount == null || transaction.type == "Unknown") {
//     return transactionsList;
//   }

//   bool isDuplicate = transactionsList.transactions.any(
//     (t) =>
//         t.reference == transaction.reference &&
//         t.account == transaction.account,
//   );

//   if (!isDuplicate) {
//     return transactionsList.copyWith(
//       transactions: List.of(transactionsList.transactions)..add(transaction),
//     );
//   }
//   return transactionsList;
// }

// Future<void> uploadMessages(List<TransactionData> transactionsData) async {
//   try {
//     final transactionService = service<TransactionsService>();
//     await transactionService.saveMultipleTransactions(transactionsData);

//     logger
//         .info('Successfully uploaded ${transactionsData.length} transactions');
//   } catch (e) {
//     logger.severe('Failed to upload transactions: $e');
//     // Consider implementing retry logic here
//   }
// }

// Future<void> writeTransactionsToFile(
//     TransactionMessageList transactionsList) async {
//   Directory? directory = await _getAppropriateDirectory();
//   if (directory == null) {
//     throw Exception('Unable to get directory');
//   }

//   final String timestamp = DateTime.now().toIso8601String();
//   final file = File('${directory.path}/transactions_$timestamp.json');

//   try {
//     await file.create(recursive: true);
//     await file.writeAsString(jsonEncode(transactionsList.toJson()));
//     logger.info('Transactions written to file successfully: ${file.path}');
//   } catch (e) {
//     logger.severe('An error occurred while writing to file: $e');
//     rethrow;
//   }
// }

// Future<Directory?> _getAppropriateDirectory() async {
//   if (Platform.isAndroid) {
//     return await getExternalStorageDirectory();
//   } else {
//     return await getApplicationDocumentsDirectory();
//   }
// }

// Future<void> scheduleMessageReading() async {
//   try {
//     final appPrefs = service<AppPreferences>();
//     final prefs = await SharedPreferences.getInstance();
//     final now = DateTime.now();

//     if (!await appPrefs.hasInstallationDate()) {
//       await appPrefs.setInstallationDate(now.millisecondsSinceEpoch);
//     }

//     final installationDate = await appPrefs.getInstallationDate();
//     final lastReadTimestamp =
//         prefs.getInt('lastReadTimestamp') ?? installationDate;

//     logger.info("Installation date: $installationDate");
//     logger.info("Last read timestamp: $lastReadTimestamp");

//     await Workmanager().registerPeriodicTask(
//       MESSAGE_READING_TASK,
//       MESSAGE_READING_TASK,
//       frequency: MESSAGE_READING_FREQUENCY,
//       initialDelay: MESSAGE_READING_INITIAL_DELAY,
//       inputData: {
//         'installationDate': installationDate.toString(),
//         'lastReadTimestamp': lastReadTimestamp.toString(),
//       },
//       constraints: Constraints(
//         networkType: wm.NetworkType.connected,
//         requiresBatteryNotLow: true,
//       ),
//     );

//     logger.info("Message reading task has been scheduled successfully");
//   } catch (e) {
//     logger.severe('Failed to schedule message reading task: $e');
//     // Consider showing a user-facing error message here
//   }
// }

import 'package:intl/intl.dart';

Map<String, dynamic> extractMpesaDetails(String message) {
  final details = <String, dynamic>{
    'account': 'MPESA',
    'cost': '0.00',
  };

  final regexPatterns = {
    'reference': r'\b([A-Z0-9]{10})\b',
    'amount': r'Ksh([,\d]+\.\d{2})',
    'datetime': r'on (\d{1,2}/\d{1,2}/\d{2}) at (\d{1,2}:\d{2} (?:AM|PM))',
    'transactionCost': r'Transaction cost,?\s*Ksh\.?\s*([,\d]+\.\d{2})',
    'newBalance': r'New M-PESA balance is Ksh([,\d]+\.\d{2})',
    'fromTo':
        r'(paid to|received from|sent to|from|to) ([A-Za-z\s-]+(?:\s+\d+)?|\+?\d+)',
  };

  void extractMatch(String key, String pattern, [String? valueKey]) {
    final match = RegExp(pattern).firstMatch(message);
    if (match != null) {
      details[valueKey ?? key] = match.group(1);
    }
  }

  extractMatch('reference', regexPatterns['reference']!);
  extractMatch('amount', regexPatterns['amount']!);
  extractMatch('cost', regexPatterns['transactionCost']!);
  extractMatch('balance', regexPatterns['newBalance']!);

  // Extract datetime
  final datetimeMatch = RegExp(regexPatterns['datetime']!).firstMatch(message);
  if (datetimeMatch != null) {
    final dateTimeString =
        '${datetimeMatch.group(1)} ${datetimeMatch.group(2)}';
    try {
      details['datetime'] =
          DateFormat('dd/MM/yy hh:mm a').parse(dateTimeString);
    } catch (e) {
      details['datetime'] = null;
    }
  }

  // Determine transaction type and set from/to
  if (message.contains('Fuliza')) {
    details['type'] = message.contains('partially pay')
        ? 'Fuliza Partial Payment'
        : 'Fuliza Repayment';
    details['from'] =
        message.contains('partially pay') ? 'Fuliza' : 'M-PESA to Fuliza';
    details['to'] =
        message.contains('partially pay') ? 'Fuliza to M-PESA' : 'Fuliza';
  } else if (message.contains('transferred')) {
    details['type'] = 'Transfer';
    if (message.contains('from M-Shwari')) {
      details['from'] = 'M-Shwari';
      details['to'] = 'M-Shwari to M-PESA';
    } else if (message.contains('to M-Shwari')) {
      details['from'] = 'M-PESA to M-Shwari';
      details['to'] = 'M-Shwari';
    } else if (message.contains('from your KCB M-PESA')) {
      details['from'] = 'KCB M-PESA';
      details['to'] = 'M-PESA to KCB M-PESA';
    } else if (message.contains('to KCB M-PESA')) {
      details['from'] = 'M-PESA to KCB M-PESA';
      details['to'] = 'KCB M-PESA';
    }
  } else {
    final fromToMatch = RegExp(regexPatterns['fromTo']!).firstMatch(message);
    if (fromToMatch != null) {
      final action = fromToMatch.group(1)!.toLowerCase();
      final party = fromToMatch.group(2)!.trim();

      if (action.contains('paid to') ||
          action.contains('sent to') ||
          action == 'to') {
        details['from'] = 'M-PESA to $party';
        details['to'] = party;
      } else {
        details['from'] = party;
        details['to'] = '$party to M-PESA';
      }
    } else {
      details['from'] = 'Unknown';
      details['to'] = 'Unknown';
    }
  }

  return details;
}

void main() {
  // Example usage with the provided messages
  List<String> messages = [
    'SIL1DNXGND Confirmed. Ksh150.00 sent to KPLC PREPAID for account 46201026609 on 21/9/24 at 4:16 PM New M-PESA balance is Ksh0.00. Transaction cost, Ksh5.00.Amount you can transact within the day is 499,800.00. Download new M-PESA app on http://bit.ly/mpesappsm & get 500MB FREE data.',
    "SIM2HG0G6W Confirmed. Ksh130.00 paid to REGMA HOTEL. on 22/9/24 at 3:46 PM.New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.",
    "SCF33L3UWT Confirmed.You have received Ksh100.00 from CO-OP BANK 149444 on 15/3/24 at 11:03 AM New M-PESA balance is Ksh100.00.",
    "SBR2CP1JQ4 Confirmed.You have received Ksh25,000.00 from WAMBUI KARANJA 0722260712 on 27/2/24 at 5:40 PM New M-PESA balance is Ksh25,000.00.",
    "SIM4GJ6WXI Confirmed. Fuliza M-PESA amount is Ksh 257.00. Interest charged Ksh 2.57.",
    "SIM4GJ3Q82 Confirmed.Ksh500.00 transferred from M-Shwari account on 22/9/24 at 11:28 AM. M-Shwari balance is Ksh517.85.",
    'SIL2EHTLXS Confirmed. Ksh200.00 sent to mary  wanjiku +254719177614 on 21/9/24 at 7:03 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh7.00. Amount you can transact within the day is 499,600.00. Buy airtime from 1 bob via M-PESA today & keep that conversation going!',
    "SIM3GAHPR3 Confirmed.You have received Ksh100.00 from Pascaline  Arusei 0728896722 on 22/9/24 at 10:09 AM  New M-PESA balance is Ksh100.00. Sign up for Lipa Na M-PESA Till online https://m-pesaforbusiness.co.ke",
    "SIJ75YIXZH Confirmed. Ksh10.00 sent to Safaricom Offers for account Tunukiwa on 19/9/24 at 5:44 PM New M-PESA balance is Ksh0.00. Transaction cost, Ksh0.00.Amount you can transact within the day is 499,910.00. Download new M-PESA app on http://bit.ly/mpesappsm & get 500MB FREE data.",
    "SIM2HAD444 Confirmed. Ksh5.00 transfered to KCB M-PESA account on 22/9/24 at 3:04 PM. New M-PESA balance is Ksh90.13, new KCB M-PESA Saving account balance is Ksh5.96.",
    "SIM3HALUFZ Confirmed.Ksh45.00 transferred to M-Shwari account on 22/9/24 at 3:06 PM. M-PESA balance is Ksh50.13 .New M-Shwari saving account balance is Ksh62.85. Transaction cost Ksh.0.00"
    // Add more message samples...
  ];

  for (var message in messages) {
    var extractedDetails = extractMpesaDetails(message);
    print(extractedDetails.toString());
  }
}
