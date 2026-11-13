// import 'package:fedha/utils/message_reading/parser.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:fedha/localization/app_prefs.dart';
// import 'package:get_it/get_it.dart';

// class MockGetIt extends Mock implements GetIt {}

// class MockAppPreferences extends Mock implements AppPreferences {}

// class MockSmsMessage extends Mock implements SmsMessage {}

// void main() {
//   group('TransactionExtractor Tests', () {
//     late MockGetIt mockGetIt;
//     late MockAppPreferences mockAppPreferences;

//     setUp(() {
//       mockGetIt = MockGetIt();
//       mockAppPreferences = MockAppPreferences();
//       when(() => mockGetIt<AppPreferences>()).thenReturn(mockAppPreferences);
//     });

//     Future<void> runTest(String address, String body,
//         Map<String, dynamic> expectedResult) async {
//       final mockSmsMessage = MockSmsMessage();
//       when(() => mockSmsMessage.address).thenReturn(address);
//       when(() => mockSmsMessage.body).thenReturn(body);
//       when(() => mockSmsMessage.date).thenReturn(
//           1632393600000); // Example timestamp: 2021-09-23 12:00:00 UTC

//       when(() => mockAppPreferences.getSupportedBanks())
//           .thenAnswer((_) async => [address]);

//       final result = await TransactionExtractor.extractTransactionDetails(
//           mockSmsMessage, mockGetIt);

//       expect(result, expectedResult);
//     }

//     test('MPESA Send Money Transaction', () async {
//       await runTest(
//         'MPESA',
//         'SIL2EHTLXS Confirmed. Ksh200.00 sent to mary wanjiku +254719177614 on 21/9/24 at 7:03 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh7.00.',
//         {
//           'account': 'MPESA',
//           'reference': 'SIL2EHTLXS',
//           'amount': '200.00',
//           'datetime': '2024-09-21 19:03:00.000',
//           'type': 'Payment',
//           'from': 'M-PESA',
//           'to': 'mary wanjiku +254719177614',
//           'cost': '7.00',
//           'balance': '0.00',
//         },
//       );
//     });

//     test('MPESA Receive Money Transaction', () async {
//       await runTest(
//         'MPESA',
//         'SIM3GAHPR3 Confirmed.You have received Ksh100.00 from Pascaline Arusei 0728896722 on 22/9/24 at 10:09 AM New M-PESA balance is Ksh100.00.',
//         {
//           'account': 'MPESA',
//           'reference': 'SIM3GAHPR3',
//           'amount': '100.00',
//           'datetime': '2024-09-22 10:09:00.000',
//           'type': 'Received',
//           'from': 'Pascaline Arusei 0728896722',
//           'to': 'M-PESA',
//           'cost': '0.00',
//           'balance': '100.00',
//         },
//       );
//     });

//     // Add more tests for other banks here
//     // ...
//   });
// }
