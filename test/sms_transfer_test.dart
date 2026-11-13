import 'package:fedha/data/models/remote_message/transaction_messages.dart';
import 'package:fedha/utils/message_reading_service/internal_transfer_linker.dart';
import 'package:fedha/utils/message_reading_service/parser.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:fedha/utils/message_reading_service/sms_sample_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SMS nature + transfer detection', () {
    test('catalog bank→M-Pesa samples are detected as debit transfers', () {
      for (final sample in kSmsSampleCatalog
          .where((s) => s.expectedKind == 'bank_to_mpesa' && s.sender != 'MPESA')) {
        expect(
          isOwnWalletBankToMpesaMove(sample.body),
          isTrue,
          reason: sample.id,
        );
        expect(
          TransactionExtractor.classifySmsNature(sample.body),
          'debit',
          reason: sample.id,
        );
      }
    });

    test('catalog expense samples are debit and not own-wallet', () {
      for (final sample
          in kSmsSampleCatalog.where((s) => s.expectedKind == 'expense')) {
        expect(
          TransactionExtractor.classifySmsNature(sample.body),
          'debit',
          reason: sample.id,
        );
        expect(
          isOwnWalletBankToMpesaMove(sample.body),
          isFalse,
          reason: '${sample.id} must not be own-wallet',
        );
        expect(
          looksLikeThirdPartySend(sample.body) ||
              sample.body.toLowerCase().contains('paid to') ||
              sample.body.toLowerCase().contains('sent to') ||
              sample.body.toLowerCase().contains('transfer of') ||
              sample.body.toLowerCase().contains('debited'),
          isTrue,
          reason: sample.id,
        );
      }
    });

    test('catalog income samples are credit', () {
      for (final sample
          in kSmsSampleCatalog.where((s) => s.expectedKind == 'income')) {
        expect(
          TransactionExtractor.classifySmsNature(sample.body),
          'credit',
          reason: sample.id,
        );
        expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
      }
    });

    test('normal send-to-person is expense, not internal transfer', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'mpesa_send_person');
      expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
      expect(TransactionExtractor.classifySmsNature(sample.body), 'debit');
      expect(narrationIsInternalTransfer(sample.body), isFalse);
    });

    test('148k transfer-of wording is expense not income', () {
      final sample = kSmsSampleCatalog
          .firstWhere((s) => s.id == 'equity_transfer_of_to_person');
      expect(TransactionExtractor.classifySmsNature(sample.body), 'debit');
      expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
    });

    test('bank send to phone/M-Pesa of someone else is expense', () {
      final sample = kSmsSampleCatalog
          .firstWhere((s) => s.id == 'equity_send_to_phone_mpesa');
      expect(looksLikeThirdPartySend(sample.body), isTrue);
      expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
      expect(TransactionExtractor.classifySmsNature(sample.body), 'debit');
    });

    test('M-Pesa receive from EQUITY BANK is internal transfer credit', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'mpesa_from_equity_1');
      expect(detectLinkedBankName(sample.body), 'Equity Bank');
      expect(isMpesaCreditFromOwnBank(sample.body, 'EQUITY BANK'), isTrue);
      expect(
        TransactionExtractor.classifySmsNature(sample.body),
        'credit',
      );
    });

    test('M-Pesa receive from person is income, not bank transfer', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'mpesa_receive_person');
      expect(
        isMpesaCreditFromOwnBank(sample.body, 'Pascaline Arusei 0728896722'),
        isFalse,
      );
    });

    test('equity payment to person stays expense', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'equity_pay_person');
      expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
      expect(TransactionExtractor.classifySmsNature(sample.body), 'debit');
    });

    test('I&M → NCBA own-wallet transfer is detected on both legs', () {
      final debit =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'im_to_ncba_debit');
      final credit =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'ncba_from_im_credit');

      expect(isOwnWalletBankToBankDebit(debit.body, 'I&M Bank'), isTrue);
      expect(detectOtherBankName(debit.body, 'I&M Bank'), 'NCBA Bank');
      expect(TransactionExtractor.classifySmsNature(debit.body), 'debit');

      expect(isOwnWalletBankToBankCredit(credit.body, 'NCBA Bank'), isTrue);
      expect(detectOtherBankName(credit.body, 'NCBA Bank'), 'I&M Bank');
      expect(TransactionExtractor.classifySmsNature(credit.body), 'credit');
    });
  });

  group('InternalTransferLinker', () {
    test('pairs I&M debit with NCBA credit of same amount', () {
      final im = TransactionMessage(
        reference: 'IMNCBA1',
        amount: '15000.00',
        datetime: DateTime(2026, 8, 25, 10, 15),
        type: 'debit',
        from: 'I&M Bank',
        to: buildBankToBankTransferLabel('I&M Bank', 'NCBA Bank'),
        account: 'I&M Bank',
      );
      final ncba = TransactionMessage(
        reference: 'NCBIM1',
        amount: '15000.00',
        datetime: DateTime(2026, 8, 25, 10, 16),
        type: 'credit',
        from: buildBankToBankTransferLabel('I&M Bank', 'NCBA Bank'),
        to: 'NCBA Bank',
        account: 'NCBA Bank',
      );

      final linked = InternalTransferLinker().link(
        TransactionMessageList(transactions: [im, ncba]),
      );

      expect(linked.transactions.length, 2);
      expect(narrationIsInternalTransfer(linked.transactions[0].to), isTrue);
      expect(narrationIsInternalTransfer(linked.transactions[1].to), isTrue);
    });
    test('pairs Equity debit with M-Pesa credit of same amount', () {
      final bank = TransactionMessage(
        reference: 'EQX91AB2',
        amount: '2500.00',
        datetime: DateTime(2026, 8, 16, 14, 22),
        type: 'debit',
        from: 'Equity Bank',
        to: buildBankToMpesaTransferLabel('Equity Bank'),
        account: 'Equity Bank',
      );
      final mpesa = TransactionMessage(
        reference: 'EQX91AB2',
        amount: '2500.00',
        datetime: DateTime(2026, 8, 16, 14, 23),
        type: 'credit',
        from: buildMpesaFromBankTransferLabel('Equity Bank'),
        to: buildMpesaFromBankTransferLabel('Equity Bank'),
        account: 'MPESA',
      );

      final linked = InternalTransferLinker().link(
        TransactionMessageList(transactions: [bank, mpesa]),
      );

      expect(linked.transactions.length, 2);
      expect(
        narrationIsInternalTransfer(linked.transactions[0].to),
        isTrue,
      );
      expect(
        narrationIsInternalTransfer(linked.transactions[1].to),
        isTrue,
      );
      expect(linked.transactions[0].to!.contains('[xfer:'), isTrue);
      expect(linked.transactions[1].to!.contains('[xfer:'), isTrue);
      // Same link id on both legs.
      final id0 = RegExp(r'\[xfer:[^\]]+\]')
          .firstMatch(linked.transactions[0].to!)!
          .group(0);
      final id1 = RegExp(r'\[xfer:[^\]]+\]')
          .firstMatch(linked.transactions[1].to!)!
          .group(0);
      expect(id0, id1);
    });

    test('does not pair expense debit with unrelated M-Pesa income', () {
      final bank = TransactionMessage(
        reference: 'A1',
        amount: '148000.00',
        datetime: DateTime(2026, 8, 16, 10),
        type: 'debit',
        account: 'Equity Bank',
        to: 'JANE WANJIKU',
        from: 'Equity Bank',
      );
      final mpesa = TransactionMessage(
        reference: 'B1',
        amount: '148000.00',
        datetime: DateTime(2026, 8, 16, 10, 1),
        type: 'credit',
        account: 'MPESA',
        from: 'Someone Else to M-pesa',
        to: 'Someone Else to M-pesa',
      );

      final linked = InternalTransferLinker().link(
        TransactionMessageList(transactions: [bank, mpesa]),
      );
      expect(linked.transactions[0].to!.contains('[xfer:'), isFalse);
      expect(linked.transactions[1].to?.contains('[xfer:') ?? false, isFalse);
      expect(linked.transactions[0].to, 'JANE WANJIKU');
      expect(
        narrationIsInternalTransfer(buildBankToMpesaTransferLabel('Equity')),
        isTrue,
      );
    });

    test('does not pair different amounts', () {
      final bank = TransactionMessage(
        reference: 'A1',
        amount: '1000.00',
        datetime: DateTime(2026, 8, 16, 10),
        type: 'debit',
        account: 'Equity Bank',
        to: buildBankToMpesaTransferLabel('Equity Bank'),
      );
      final mpesa = TransactionMessage(
        reference: 'B1',
        amount: '900.00',
        datetime: DateTime(2026, 8, 16, 10, 1),
        type: 'credit',
        account: 'MPESA',
        from: buildMpesaFromBankTransferLabel('Equity Bank'),
      );

      final linked = InternalTransferLinker().link(
        TransactionMessageList(transactions: [bank, mpesa]),
      );
      expect(linked.transactions[0].to!.contains('[xfer:'), isFalse);
      expect(linked.transactions[1].to?.contains('[xfer:') ?? false, isFalse);
    });
  });

  group('narration helpers', () {
    test('Transfer labels are excluded from income/expense', () {
      expect(
        narrationIsInternalTransfer(
          buildBankToMpesaTransferLabel('Equity Bank'),
        ),
        isTrue,
      );
      expect(
        narrationIsInternalTransfer(
          buildMpesaFromBankTransferLabel('I&M Bank'),
        ),
        isTrue,
      );
      expect(narrationIsInternalTransfer('mary wanjiku +2547'), isFalse);
    });
  });

  group('USD / dollar account SMS', () {
    test('detects USD currency from dollar-account wording', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'equity_usd_credit');
      expect(detectSmsCurrency(sample.body), 'USD');
      final money = extractSmsAmountAndCurrency(sample.body);
      expect(money.currency, 'USD');
      expect(money.amount, '1250.00');
      expect(TransactionExtractor.classifySmsNature(sample.body), 'credit');
    });

    test('USD send to person is expense debit', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'equity_usd_send_person');
      expect(detectSmsCurrency(sample.body), 'USD');
      expect(TransactionExtractor.classifySmsNature(sample.body), 'debit');
      expect(isOwnWalletBankToMpesaMove(sample.body), isFalse);
    });

    test('KES samples stay KES', () {
      final sample =
          kSmsSampleCatalog.firstWhere((s) => s.id == 'equity_pay_person');
      expect(detectSmsCurrency(sample.body), 'KES');
      expect(extractSmsAmountAndCurrency(sample.body).currency, 'KES');
    });
  });
}
