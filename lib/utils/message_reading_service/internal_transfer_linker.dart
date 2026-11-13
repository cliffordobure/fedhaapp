import 'package:fedha/data/models/remote_message/transaction_messages.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';

/// Links bank ↔ M-Pesa and bank ↔ bank legs of the same own-wallet move
/// so income/expense totals can ignore both sides.
class InternalTransferLinker {
  InternalTransferLinker({
    this.maxGap = const Duration(minutes: 45),
    this.amountTolerance = 1.0,
  });

  final Duration maxGap;
  final double amountTolerance;

  /// Returns a new list with paired legs labeled consistently.
  TransactionMessageList link(TransactionMessageList input) {
    final items = List<TransactionMessage>.from(input.transactions);
    if (items.length < 2) return input;

    final used = <int>{};

    for (var i = 0; i < items.length; i++) {
      if (used.contains(i)) continue;
      final a = items[i];
      final aAmt = _amountOf(a);
      final aType = (a.type ?? '').toLowerCase();
      final aAccount = (a.account ?? '').toLowerCase();
      if (aAmt == null) continue;

      final aIsMpesa = _isMpesaAccount(aAccount);
      final aIsBank = !aIsMpesa && aAccount.isNotEmpty;
      final aIsDebit = aType.contains('debit');
      final aIsCredit = aType.contains('credit');

      for (var j = 0; j < items.length; j++) {
        if (i == j || used.contains(j)) continue;
        final b = items[j];
        final bAmt = _amountOf(b);
        if (bAmt == null) continue;
        if ((aAmt - bAmt).abs() > amountTolerance) continue;
        if (!_withinGap(a.datetime, b.datetime)) continue;

        final bAccount = (b.account ?? '').toLowerCase();
        final bType = (b.type ?? '').toLowerCase();
        final bIsMpesa = _isMpesaAccount(bAccount);
        final bIsBank = !bIsMpesa && bAccount.isNotEmpty;
        final bIsDebit = bType.contains('debit');
        final bIsCredit = bType.contains('credit');

        // Only pair when at least one leg already looks like an own-wallet
        // transfer — never pair unrelated txs just because amounts match.
        final aTransfer = narrationIsInternalTransfer(a.to) ||
            narrationIsInternalTransfer(a.from);
        final bTransfer = narrationIsInternalTransfer(b.to) ||
            narrationIsInternalTransfer(b.from);
        if (!(aTransfer || bTransfer)) continue;

        String? labelA;
        String? labelB;

        // bank debit ↔ M-Pesa credit
        if (aIsBank && aIsDebit && bIsMpesa && bIsCredit) {
          final bankName = _bankDisplayName(a.account);
          labelA = buildBankToMpesaTransferLabel(bankName);
          labelB = buildMpesaFromBankTransferLabel(bankName);
        } else if (bIsBank && bIsDebit && aIsMpesa && aIsCredit) {
          final bankName = _bankDisplayName(b.account);
          labelB = buildBankToMpesaTransferLabel(bankName);
          labelA = buildMpesaFromBankTransferLabel(bankName);
        }
        // M-Pesa debit ↔ bank credit
        else if (aIsMpesa && aIsDebit && bIsBank && bIsCredit) {
          final bankName = _bankDisplayName(b.account);
          labelA = buildMpesaToBankTransferLabel(bankName);
          labelB = buildMpesaToBankTransferLabel(bankName);
        } else if (bIsMpesa && bIsDebit && aIsBank && aIsCredit) {
          final bankName = _bankDisplayName(a.account);
          labelB = buildMpesaToBankTransferLabel(bankName);
          labelA = buildMpesaToBankTransferLabel(bankName);
        }
        // bank ↔ bank (e.g. I&M → NCBA)
        else if (aIsBank && bIsBank && aIsDebit && bIsCredit) {
          final fromBank = _bankDisplayName(a.account);
          final toBank = _bankDisplayName(b.account);
          if (walletNameMatchesSmsBank(fromBank, toBank)) continue;
          final label = buildBankToBankTransferLabel(fromBank, toBank);
          labelA = label;
          labelB = label;
        } else if (aIsBank && bIsBank && bIsDebit && aIsCredit) {
          final fromBank = _bankDisplayName(b.account);
          final toBank = _bankDisplayName(a.account);
          if (walletNameMatchesSmsBank(fromBank, toBank)) continue;
          final label = buildBankToBankTransferLabel(fromBank, toBank);
          labelA = label;
          labelB = label;
        } else {
          continue;
        }

        if (labelA == null || labelB == null) continue;

        final linkId = _linkId(aAmt, a.datetime ?? b.datetime);
        items[i] = a.copyWith(
          type: aIsDebit ? 'debit' : 'credit',
          from: '$labelA [$linkId]',
          to: '$labelA [$linkId]',
        );
        items[j] = b.copyWith(
          type: bIsDebit ? 'debit' : 'credit',
          from: '$labelB [$linkId]',
          to: '$labelB [$linkId]',
        );

        used.add(i);
        used.add(j);
        break;
      }
    }

    return TransactionMessageList(transactions: items);
  }

  bool _isMpesaAccount(String account) {
    final a = account.toLowerCase();
    return a.contains('mpesa') || a.contains('m-pesa') || a == 'mpesa';
  }

  String _bankDisplayName(String? account) {
    if (account == null || account.trim().isEmpty) return 'Bank';
    final key = normalizeSmsAddress(account) ?? account;
    return smsAddressToWalletName[key] ?? account;
  }

  double? _amountOf(TransactionMessage tx) {
    final raw = tx.amount?.toString().replaceAll(',', '') ?? '';
    return double.tryParse(raw);
  }

  bool _withinGap(DateTime? a, DateTime? b) {
    if (a == null || b == null) return true;
    return a.difference(b).abs() <= maxGap;
  }

  String _linkId(double amount, DateTime? when) {
    final stamp = when?.millisecondsSinceEpoch ?? 0;
    return 'xfer:${amount.toStringAsFixed(0)}:$stamp';
  }
}

final internalTransferLinker = InternalTransferLinker();
