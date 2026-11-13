import 'dart:math';

import 'package:fedha/data/models/graphs/chart_data.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

// Loaders
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showSnackBar(BuildContext context,
    {required String content, Color? bgColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(content),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
    ),
  );
}

showError(String? message) => EasyLoading.showError(
      message ?? "An error occured!",
    );
showSuccess(String? message) =>
    EasyLoading.showSuccess(message ?? "Action successful");
showInfo(String message) => EasyLoading.showInfo(message);
showLoading(String? message) => EasyLoading.show(
      status: (message != null && message.trim().isNotEmpty)
          ? message
          : "Please wait...",
      dismissOnTap: false,
    );
showToast(String message) => EasyLoading.showToast(message,
    toastPosition: EasyLoadingToastPosition.bottom);

List months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

// Add commas betweed double values
String formatAmount(double? amount) {
  if (amount == null) {
    return "0.0";
  }
  // Convert the double to a string and split it into the whole and decimal parts
  String amountStr = amount.toString();
  List<String> parts = amountStr.split('.');

  // Format the whole part with commas
  String wholePart = parts[0];
  String formattedAmount = '';
  int count = 0;
  for (int i = wholePart.length - 1; i >= 0; i--) {
    count++;
    formattedAmount = wholePart[i] + formattedAmount;
    if (count == 3 && i > 0) {
      formattedAmount = ',$formattedAmount';
      count = 0;
    }
  }

  // Add back the decimal part if it exists
  if (parts.length > 1) {
    formattedAmount += '.${parts[1]}';
  }

  return formattedAmount;
}

// Capitalize the first letter of the text
String capitalize(String text) {
  return text.substring(0, 1).toUpperCase() +
      text.substring(
        1,
      );
}

// Categorize transactions monthly
Map<String, List<Widget>> categorise(List<Transaction> transactions) {
  Map<String, List<Widget>> categories = {};

  for (var transaction in transactions.reversed) {
    if (!categories.containsKey(months[transaction.createdAt!.month - 1])) {
      categories[months[transaction.createdAt!.month - 1]] = [
        TransactionTile(transaction: transaction)
      ];
    } else {
      categories[months[transaction.createdAt!.month - 1]]!
          .add(TransactionTile(transaction: transaction));
    }
  }

  return categories;
}

// Formart date to readable string
String formatDate(DateTime dateTime) {
  String month = months[dateTime.month - 1];
  String date = "${dateTime.day}-$month-${dateTime.year}";
  return date;
}

// Green color variance generator
Color generateRandomColor() {
  Random random = Random();
  int greenValue =
      random.nextInt(256); // generate a random green value between 0 and 255
  return Color.fromARGB(255, 0, greenValue,
      0); // return a color with the randomly generated green value
}

// Get max transaction
int maxTransaction(List<ChartData> transactionsData) {
  int max = 1000;

  for (var element in transactionsData) {
    if (element.expense > max) {
      max = element.expense.toInt();
    }

    if (element.income > max) {
      max = element.income.toInt();
    }
  }

  for (var d in transactionsData) {
    print("${d.label}: ${d.income}:${d.expense}");
  }
  print("Max determined is: $max");
  return max;
}

double nextTensOrHundreds(int x) {
  int nextValue;
  if (x < 10) {
    nextValue = 10;
  } else if (x < 100) {
    nextValue = 100;
  } else {
    int magnitude = (x.toString().length - 1);
    int factor = (magnitude == 1) ? 10 : 100;
    int topDigit = x ~/ (factor);
    nextValue = (topDigit + 1) * factor;
  }
  return nextValue.toDouble();
}

/// Calculates date difference
String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays >= 7) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    return 'just now';
  }
}

// Convert time to mins
int timeToMins(String timeString) {
  List<String> timeParts = timeString.split(":");
  int minutes = int.parse(timeParts[0]) * 60 + int.parse(timeParts[1]);
  return minutes;
}

String classifyTransactionType(Map<String, dynamic> transactionDetails) {
  String? type = transactionDetails['type']?.toLowerCase();
  String? from = transactionDetails['from']?.toLowerCase() ??
      transactionDetails["recipient_or_sender"]?.toLowerCase();
  String? to = transactionDetails['to']?.toLowerCase() ??
      transactionDetails["recipient_or_sender"]?.toLowerCase();

  logger.info("Transaction type is: ${type ?? 'null'}");

  if (type == null) {
    return 'Unknown';
  }

  // Transactions that are typically debits
  if (type.contains('sent') ||
      type.contains('paid') ||
      type.contains('withdrawal') ||
      type.contains('airtime purchase') ||
      type.contains('fuliza payment') ||
      type.contains('debit') ||
      type == 'm-pesa to m-shwari' ||
      type == 'm-pesa to kcb m-pesa') {
    return 'debit';
  }

  // Transactions that are typically credits
  if (type.contains('received') ||
      type.contains('deposit') ||
      type.contains('credit') ||
      type == 'm-shwari to m-pesa' ||
      type == 'kcb m-pesa to m-pesa') {
    return 'credit';
  }

  // Special case for Fuliza transactions
  if (type == 'fuliza') {
    // If there's a 'fulizaAmount', it's a credit (loan taken)
    // Otherwise, it's likely a debit (loan repayment)
    return transactionDetails.containsKey('fulizaAmount') ? 'credit' : 'debit';
  }

  // For ambiguous cases, we can check the 'from' and 'to' fields
  if (from == 'your account' ||
      from == 'your card' ||
      from == 'm-pesa' ||
      from == 'kcb m-pesa') {
    return 'debit';
  }
  if (to == 'your account' || to == 'your mpesa account' || to == 'm-pesa') {
    return 'credit';
  }

  // Prefer debit when still unsure — never invent income from a vague SMS.
  if (to != null &&
      to != 'n/a' &&
      to.isNotEmpty &&
      !to.contains('your') &&
      to != 'm-pesa') {
    return 'debit';
  }
  if (from != null && from != 'n/a' && from.isNotEmpty && from != 'unknown') {
    // "from Your Account / bank" is outbound; bare counterparty names on
    // unknown rows are still treated as debit unless clearly inbound above.
    return 'debit';
  }

  // If we can't determine, return debit (safer for spending alerts).
  return 'debit';
}

// String? findLatestTransactionDateTime(TransactionMessageList transactionList) {
//   if (transactionList.transactions.isEmpty) {
//     return null;
//   }

//   DateFormat format = DateFormat("d/M/yy h:mm a");

//   DateTime latestDateTime = transactionList.transactions
//       .map((t) => t.datetime)
//       .where((datetime) => datetime != null)
//       .map((datetime) => format.parse(datetime!))
//       .reduce((a, b) => a.isAfter(b) ? a : b);

//   return format.format(latestDateTime);
// }

bool isFulizaTransfer(Map<String, dynamic> transactionDetails) {
  String? type = transactionDetails['type']?.toLowerCase();

  String? to = transactionDetails['to']?.toLowerCase();

  // Check if the transaction type or description contains 'fuliza'
  bool containsFuliza = (type != null && type.contains('fuliza payment')) ||
      (to != null && to.contains('fuliza payment'));

  // It's a Fuliza transfer if it both contains 'fuliza' and is a transfer
  return containsFuliza;
}
