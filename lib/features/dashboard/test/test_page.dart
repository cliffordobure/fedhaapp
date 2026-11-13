// import 'package:fedha/utils/transactions_utils.dart';
// import 'package:flutter/material.dart';

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   List<TransactionModel> transactions = [];

//   @override
//   void initState() {
//     super.initState();
//     //   // Request permission to read SMS on app launch
//     //   requestSmsPermission();
//     //   // Load transactions on app launch
//     loadTransactions();
//   }

//   Future<void> loadTransactions() async {
//     // transactions = await processMessages();
//     var result;
//     List<AirtelTransactionMessage> txn = await extractAirtelTransactionInfo();
//     for (var tx in txn) {
//       result.add(tx.toJson());
//     }
//     print(result.toString());
//     setState(() {}); // Update UI after data is loaded
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Extracted Transactions"),
//       ),
//       body: ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             TransactionModel transaction = transactions[index];
//             print(transaction.toJson());
//             return ListTile(
//               title: Text(
//                   "${transaction.transactionType} - Ksh ${transaction.amount}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                       "${transaction.transactionType} ${transaction.senderRecipientPhone}"),
//                   Text(
//                       "${transaction.transactionType} ${transaction.senderRecipientName}"),
//                   Text("Balance Ksh ${transaction.balance}"),
//                   Text("Cost ${transaction.cost}"),
//                   Text("Id ${transaction.id}"),
//                   Text("Date ${transaction.dateTime}"),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }
