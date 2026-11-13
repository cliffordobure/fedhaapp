// import 'package:another_telephony/telephony.dart';
// import 'package:fedha/data/error/failure.dart';
// import 'package:fedha/data/models/multiple_result/multiple_result.dart';
// import 'package:fedha/data/models/transactions/transactions.dart';
// import 'package:fedha/data/services/service.dart';

// // TODO! transform and emit sms messages
// class SmsTransformer {
//   HttpResult<dynamic> handle(SmsMessage message) async {
//     try {
//       return Http.post(
//         "register_sms",
//         parseMessage(message)!.toJson(),
//         deserializer: (data) => data,
//       );
//     } catch (e) {
//       return MultipleResult.onError(
//           error: Failure(
//               error: "Error transforming sms message: ${e.toString()} "));
//     }
//   }
// }

// // Util converter
// Transaction? parseMessage(SmsMessage message) {
//   // Handle based on sender
//   switch (message.address?.toUpperCase()) {
//     case 'MPESA':
//       return mpesaTransaction(message);
//     case "KCB":
//       return kcbTransaction(message);
//     case "ABSABANK":
//       return absaTransaction(message);
//     case "DTB":
//       return dtbTransaction(message);
//     case "EQUITY":
//       return equityTransaction(message);
//     default:
//       return mpesaTransaction(message);
//   }
// }

// Transaction? absaTransaction(SmsMessage data) {
//   return null;
// }

// Transaction? dtbTransaction(SmsMessage data) {
//   return null;
// }

// Transaction? equityTransaction(SmsMessage data) {
//   return null;
// }

// Transaction? kcbTransaction(SmsMessage data) {
//   return null;
// }

// Transaction? mpesaTransaction(SmsMessage data) {
//   final message = data.body ?? "";
//   RegExp transactionIdRegex = RegExp(r'Ref (\w+).');
//   RegExp amountRegex = RegExp(r'(\d+\.\d+)');
//   RegExp balanceRegex = RegExp(r'New M-PESA balance is (\w+\d+\.\d+).');
//   RegExp costRegex = RegExp(r'Transaction cost, Ksh(\d+\.\d+).');
//   RegExp dateRegex = RegExp(r'on (\d+/\d+/\d+ at \d+:\d+ [APMapm]+)');
//   RegExp incomingRegex = RegExp(r'has transfered KES (\d+\.\d+) to your MPESA');
//   RegExp outgoingRegex =
//       RegExp(r'for account \d+ on (\d+/\d+/\d+ at \d+:\d+ [APMapm]+)');

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
//       cost: cost,
//       narration: message,
//       date: date,
//       balance: balance,
//       currency: currency,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now());
// }
