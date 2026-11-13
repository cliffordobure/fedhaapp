// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // factory translator

// import 'package:another_telephony/telephony.dart';
// import 'package:flutter/material.dart';

// import 'package:permission_handler/permission_handler.dart';

// import 'package:fedha/data/models/transactions/transactions.dart';

// Transaction parseMessage(String message) {
//   RegExp transactionIdRegex = RegExp(r'Ref (\w+).');
//   RegExp amountRegex = RegExp(r'(\d+\.\d+)');
//   RegExp balanceRegex = RegExp(r'New M-PESA balance is (\w+\d+\.\d+).');
//   RegExp costRegex = RegExp(r'Transaction cost, Ksh(\d+\.\d+).');
//   RegExp dateRegex = RegExp(r'on (\d+/\d+/\d+ at \d+:\d+ [APMapm]+)');
//   RegExp incomingRegex = RegExp(r'has transfered KES (\d+\.\d+) to your MPESA');
//   RegExp outgoingRegex = RegExp(
//       r'sent to DTB Account for account \d+ on (\d+/\d+/\d+ at \d+:\d+ [APMapm]+)');

//   String transactionId = transactionIdRegex.firstMatch(message)?.group(1) ?? '';
//   double amount =
//       double.parse(amountRegex.firstMatch(message)?.group(1) ?? '0');
//   double? cost = double.parse(costRegex.firstMatch(message)?.group(1) ?? '0');
//   double? balance =
//       double.parse(balanceRegex.firstMatch(message)?.group(1) ?? '0');
//   String dateStr = dateRegex.firstMatch(message)?.group(1) ?? '';
//   DateTime date = DateTime.parse(dateStr.replaceAllMapped(
//       RegExp(r'(\d+)/(\d+)/(\d+) at (\d+:\d+ [APMapm]+)'),
//       (match) =>
//           '${match.group(3)}-${match.group(1)}-${match.group(2)} ${match.group(4)}'));
//   String currency = 'KES';

//   TransactionType type = TransactionType.credit;
//   if (incomingRegex.hasMatch(message)) {
//     type = TransactionType.credit;
//   } else if (outgoingRegex.hasMatch(message)) {
//     type = TransactionType.debit;
//   }

//   return Transaction(
//       transactionId: transactionId,
//       type: type,
//       amount: amount,
//       charges: cost,
//       narration: message,
//       date: date,
//       balance: balance,
//       currency: currency,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now());
// }

// class TransactionModel {
//   String? transactionType;
//   String? amount;
//   String? id;
//   String? senderRecipientName;
//   String? senderRecipientPhone;
//   String? dateTime;
//   String? balance;
//   String? cost;
//   String? otherInfo;

//   TransactionModel(
//       {this.transactionType,
//       this.amount,
//       this.senderRecipientName,
//       this.senderRecipientPhone,
//       this.dateTime,
//       this.balance,
//       this.cost,
//       this.id,
//       this.otherInfo});

//   Map<String, dynamic> toJson() {
//     return {
//       'transactionType': transactionType,
//       'amount': amount,
//       'senderRecipientName': senderRecipientName,
//       'senderRecipientPhone': senderRecipientPhone,
//       'dateTime': dateTime,
//       'balance': balance,
//       'cost': cost,
//       'id': id,
//       'otherInfo': otherInfo,
//     };
//   }

//   TransactionModel copyWith({
//     String? transactionType,
//     String? amount,
//     String? id,
//     String? senderRecipientName,
//     String? senderRecipientPhone,
//     String? dateTime,
//     String? balance,
//     String? cost,
//     String? otherInfo,
//   }) {
//     return TransactionModel(
//       transactionType: transactionType ?? this.transactionType,
//       amount: amount ?? this.amount,
//       id: id ?? this.id,
//       senderRecipientName: senderRecipientName ?? this.senderRecipientName,
//       senderRecipientPhone: senderRecipientPhone ?? this.senderRecipientPhone,
//       dateTime: dateTime ?? this.dateTime,
//       balance: balance ?? this.balance,
//       cost: cost ?? this.cost,
//       otherInfo: otherInfo ?? this.otherInfo,
//     );
//   }
// }

// Future<void> requestSmsPermission() async {
//   var permission = await Permission.sms.status;
//   if (!permission.isGranted) {
//     await Permission.sms.request();
//   } else {
//     List<TransactionModel> transactions = await processMessages();
//     debugPrint(transactions.toString());
//   }
// }

// Future<List<TransactionModel>> processMessages() async {
//   final Telephony telephony = Telephony.instance;

//   List<TransactionModel> transactions = [];
//   await telephony.requestSmsPermissions;
//   bool? permissionGranted = await telephony.requestSmsPermissions;
//   if (permissionGranted != null || permissionGranted != false) {
//     List<SmsMessage> messages = await telephony.getInboxSms(
//         columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//         filter: SmsFilter.where(SmsColumn.ADDRESS).equals("MPESA"),
//         sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)]);

//     // Filter for messages containing "paid","sent" and "received" (customizable)
//     for (SmsMessage message in messages) {
//       if (message.body!.contains("received") ||
//           message.body!.contains("sent") ||
//           message.body!.contains("Give") ||
//           message.body!.contains("bought") ||
//           message.body!.contains("paid")) {
//         TransactionModel transaction = TransactionModel();

//         // Extract transaction type (sent/received)
//         if (message.body!.contains("sent") ||
//             message.body!.contains("paid") ||
//             message.body!.contains("Give")) {
//           transaction.transactionType = "Sent";

//           RegExp nameRegex = RegExp(r"(?<=to\s)\b\w+(?:\s+\w+){1,2}\b");
//           Match? nameMatch = nameRegex.firstMatch(message.body!);
//           if (nameMatch != null) {
//             if (nameMatch.group(0)!.contains("at")) {
//               transaction.senderRecipientName =
//                   nameMatch.group(0)!.replaceAll("at", "");
//             } else {
//               transaction.senderRecipientName = nameMatch.group(0)!;
//             }
//           }
//         } else if (message.body!.contains("Give")) {
//           transaction.transactionType = "Received";

//           RegExp nameRegex = RegExp(r"(?<=to\s)\b\w+(?:\s+\w+){1,2}\b");
//           Match? nameMatch = nameRegex.firstMatch(message.body!);
//           if (nameMatch != null) {
//             if (nameMatch.group(0)!.contains("on")) {
//               transaction.senderRecipientName =
//                   nameMatch.group(0)!.replaceAll("on", "");
//             } else {
//               transaction.senderRecipientName = nameMatch.group(0)!;
//             }
//           }
//         } else if (message.body!.contains("received")) {
//           transaction.transactionType = "Received";

//           RegExp nameRegex =
//               RegExp(r"(?<=from\s)(?!from\s)[A-z\s-]+(?=\s\d{10}|)");
//           Match? nameMatch = nameRegex.firstMatch(message.body!);
//           debugPrint(nameMatch.toString());
//           if (nameMatch != null) {
//             if (nameMatch.group(0)!.contains("on")) {
//               transaction.senderRecipientName =
//                   nameMatch.group(0)!.replaceAll("on", "");
//             } else {
//               transaction.senderRecipientName = nameMatch.group(0)!;
//             }
//           }
//         } else if (message.body!.contains("bought")) {}

//         // Extract amount (using same regex from previous explanation)
//         RegExp amountRegex = RegExp(r"(?<=Ksh)\d+(,\d+)?\.\d+");
//         Match? amountMatch = amountRegex.firstMatch(message.body!);
//         if (amountMatch != null) {
//           transaction.amount = amountMatch.group(0)!;
//         }

//         // Extract sender/recipient phone (using same regex)
//         RegExp phoneRegex = RegExp(r"\d{10}");
//         Match? phoneMatch = phoneRegex.firstMatch(message.body!);
//         if (phoneMatch != null) {
//           transaction.senderRecipientPhone = phoneMatch.group(0)!;
//         }

//         // Extract date and time
//         RegExp dateTimeRegex =
//             RegExp(r"\b\d{1,2}/\d{1,2}/\d{1,2}\s+at\s+\d{1,2}:\d{2}\b");
//         Match? dateTimeMatch = dateTimeRegex.firstMatch(message.body!);
//         if (dateTimeMatch != null) {
//           String dateTimeString = dateTimeMatch.group(0)!;
//           transaction.dateTime = dateTimeString;
//         }

//         RegExp balanceRegex = RegExp(r'New M-PESA balance is (\w+\d+\.\d+).');
//         Match? balanceMatch = balanceRegex.firstMatch(message.body!);
//         if (balanceMatch != null) {
//           String balance = balanceMatch.group(1) ?? '0';
//           if (balance.contains("Ksh")) {
//             transaction.balance = balance.split("Ksh")[1];
//           } else {
//             transaction.balance = balance;
//           }
//         }

//         RegExp costRegex = RegExp(r'Transaction cost, Ksh(\d+\.\d+).');
//         Match? costMatch = costRegex.firstMatch(message.body!);
//         if (costMatch != null) {
//           String cost = costMatch.group(1) ?? '0';
//           transaction.cost = cost.toString();
//         }

//         RegExp transactionIdRegex = RegExp(r'([^\s]+)');
//         Match? idMatch = transactionIdRegex.firstMatch(message.body!);
//         if (idMatch != null) {
//           String id = idMatch.group(1) ?? '0';
//           transaction.id = id.toString();
//         }

//         transactions.add(transaction);
//       }
//     }
//   }

//   return transactions;
// }

// ///Airtel message extraction
// class AirtelTransactionMessage {
//   String? transactionId;
//   String? amount;
//   String? balance;
//   String? charges;
//   String? date;
//   String? type;
//   String? senderOrReceiverName;

//   AirtelTransactionMessage({
//     this.transactionId,
//     this.amount,
//     this.balance,
//     this.charges,
//     this.date,
//     this.type,
//     this.senderOrReceiverName,
//   });

//   Map<String, dynamic> toJson() {
//     return <String, dynamic>{
//       'transactionId': transactionId,
//       'amount': amount,
//       'balance': balance,
//       'charges': charges,
//       'date': date,
//       'type': type,
//       'senderOrReceiverName': senderOrReceiverName,
//     };
//   }

//   factory AirtelTransactionMessage.fromJson(Map<String, dynamic> map) {
//     return AirtelTransactionMessage(
//       transactionId:
//           map['transactionId'] != null ? map['transactionId'] as String : null,
//       amount: map['amount'] != null ? map['amount'] as String : null,
//       balance: map['balance'] != null ? map['balance'] as String : null,
//       charges: map['charges'] != null ? map['charges'] as String : null,
//       date: map['date'] != null ? map['date'] as String : null,
//       type: map['type'] != null ? map['type'] as String : null,
//       senderOrReceiverName: map['senderOrReceiverName'] != null
//           ? map['senderOrReceiverName'] as String
//           : null,
//     );
//   }
// }

// Future<List<AirtelTransactionMessage>> extractAirtelTransactionInfo() async {
//   final Telephony telephony = Telephony.instance;
//   List<AirtelTransactionMessage> extractedMessages = [];

//   await telephony.requestSmsPermissions;
//   bool? permissionGranted = await telephony.requestSmsPermissions;
//   if (permissionGranted != null || permissionGranted != false) {
//     List<SmsMessage> messages = await telephony.getInboxSms(
//         columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//         filter: SmsFilter.where(SmsColumn.ADDRESS).equals("MPESA"),
//         sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)]);

//     // Regular expressions for extracting transaction information
//     RegExp transactionIdRegex = RegExp(r'Txn\sID:\s(\d+)');
//     RegExp amountRegex = RegExp(r'(?:paid\sto|received)\s(Ksh\s[\d.]+)');
//     RegExp balanceRegex = RegExp(r'Bal:\s(Ksh\s[\d.]+)');
//     RegExp chargesRegex = RegExp(r'fee:\s(Ksh\s[\d.]+)');
//     RegExp dateRegex = RegExp(r'on\s(\d+/\d+/\d+\sat\s\d+:\d+\s(?:AM|PM))');
//     RegExp typeRegex = RegExp(r'(?:successfully\s)?(paid|received)');

//     for (SmsMessage message in messages) {
//       if (message.body!.contains("paid to") ||
//           message.body!.contains("received from")) {
//         AirtelTransactionMessage extractedMessage = AirtelTransactionMessage();

//         // Extracting information from the message
//         Match? transactionIdMatch =
//             transactionIdRegex.firstMatch(message.body ?? "");
//         Match? amountMatch = amountRegex.firstMatch(message.body ?? "");
//         Match? balanceMatch = balanceRegex.firstMatch(message.body ?? "");
//         Match? chargesMatch = chargesRegex.firstMatch(message.body ?? "");
//         Match? dateMatch = dateRegex.firstMatch(message.body ?? "");
//         Match? typeMatch = typeRegex.firstMatch(message.body ?? "");

//         extractedMessage.transactionId = transactionIdMatch?.group(1);
//         extractedMessage.amount = amountMatch?.group(1);
//         extractedMessage.balance = balanceMatch?.group(1);
//         extractedMessage.charges = chargesMatch?.group(1);
//         extractedMessage.date = dateMatch?.group(1);
//         extractedMessage.type = typeMatch?.group(1);

//         // Extracting sender or receiver name
//         if (message.body!.contains("paid to")) {
//           extractedMessage.senderOrReceiverName =
//               message.body!.split("paid to")[1].split("on")[0].trim();
//         } else if (message.body!.contains("received from")) {
//           extractedMessage.senderOrReceiverName =
//               message.body!.split("received from")[1].split("Txn ID")[0].trim();
//         }

//         extractedMessages.add(extractedMessage);
//       }
//     }
//   }

//   return extractedMessages;
// }

// List<MessageInfo> extractStanbicMessageInfo(List<String> messages) {
//   final extractedInfo = <MessageInfo>[];

//   for (final message in messages) {
//     MessageInfo info = MessageInfo(type: "", amount: null, date: null);

//     // Identify income messages using keywords (adjust if needed)
//     if (message.toLowerCase().contains("transferred") ||
//         message.toLowerCase().contains("deposited")) {
//       info.type = "income";
//     } else {
//       info.type = "expense";
//     }

//     // Extract amount using regular expression (adjust if needed)
//     final amountMatch = RegExp(r"KES\s+([\d,]+(?:\.\d+)?)").firstMatch(message);
//     if (amountMatch != null) {
//       info.amount = double.tryParse(amountMatch.group(1)!.replaceAll(",", ""));
//     }

//     // Extract date using regular expression (adjust if needed)
//     final dateMatch = RegExp(r"\d{4}-\d{2}-\d{2}").firstMatch(message);
//     if (dateMatch != null) {
//       info.date = DateTime.parse(dateMatch.group(0)!);
//     }

//     extractedInfo.add(info);
//   }

//   return extractedInfo;
// }

// class MessageInfo {
//   String type;
//   double? amount;
//   DateTime? date;

//   MessageInfo({required this.type, this.amount, this.date});
// }
// //https://testflight.apple.com/join/ARY0NUyP


