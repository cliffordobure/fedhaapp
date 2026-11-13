import 'package:another_telephony/telephony.dart'
    if (dart.library.html) 'dummy.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class TransactionExtractor {
  static bool _hasBank(List supportedBanks, String name) {
    return supportedBanks.any((b) {
      final value = b.toString();
      return value.toLowerCase() == name.toLowerCase() ||
          walletNameMatchesSmsBank(value, name);
    });
  }

  static Future<Map<String, dynamic>> extractTransactionDetails(
      SmsMessage message, GetIt getIt) async {
    final prefs = getIt<AppPreferences>();
    List supportedBanks = await prefs.getSupportedBanks();
    Map<String, dynamic> details = {};
    final body = message.body ?? "";
    final address = resolveSmsAddress(
      address: message.address,
      body: body,
    );

    if (address == 'Equity Bank' && _hasBank(supportedBanks, "Equity Bank")) {
      details = _extractEquityTransaction(body);
    } else if (address == 'I&M Bank' && _hasBank(supportedBanks, "I&M Bank")) {
      details = _extractIMBankTransaction(body);
    } else if (address == 'CoopBank' &&
        _hasBank(supportedBanks, "Co-Operative Bank")) {
      details = _extractCoopTransaction(body);
    } else if (address == 'NCBA_BANK' &&
        _hasBank(supportedBanks, "NCBA Bank")) {
      details = _extractNCBATransaction(body);
    } else if (address == 'Stanbic' &&
        _hasBank(supportedBanks, "Stanbic Bank")) {
      details = _extractStanbicTransaction(body);
    } else if (address == 'StanChart' &&
        _hasBank(supportedBanks, "Standard Chartered Bank")) {
      details = _extractStandardCharteredTransaction(body);
    } else if (address == 'MPESA' && _hasBank(supportedBanks, "M-Pesa")) {
      details = _extractMPESATransaction(body);
    }

    // If datetime is not extracted, use message.date
    if (!details.containsKey('datetime') || details['datetime'] == null) {
      details['datetime'] = message.date != null
          ? DateTime.fromMillisecondsSinceEpoch(message.date!).toString()
          : null;
    }

    // Ensure a stable reference so convert/upload does not drop the row.
    if ((details['reference'] == null ||
            details['reference'].toString().trim().isEmpty) &&
        details['amount'] != null) {
      final stamp = message.date ?? DateTime.now().millisecondsSinceEpoch;
      details['reference'] =
          'SMS${stamp.toRadixString(16)}${details['amount']}'
              .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
              .toUpperCase();
      if (details['reference'].toString().length > 24) {
        details['reference'] =
            details['reference'].toString().substring(0, 24);
      }
    }

    return details;
  }

  /// Shared credit/debit detector for bank SMS.
  ///
  /// Clear outbound signals win first so "paid/sent/transferred to someone"
  /// is never treated as income when the SMS also says "credited" / "received".
  static String? classifySmsNature(String message) {
    final lower = message.toLowerCase();

    // Money leaving the user's account — check BEFORE loose credit wording.
    // Do NOT use phone-number presence alone (receive SMS also include phones).
    final clearDebit = lower.contains('you have been debited') ||
        lower.contains('your account has been debited') ||
        lower.contains('a/c has been debited') ||
        lower.contains('account has been debited') ||
        lower.contains('has been debited') ||
        lower.contains('was debited') ||
        lower.contains('you have transferred') ||
        lower.contains('you transferred') ||
        lower.contains('you have paid') ||
        lower.contains('you paid') ||
        lower.contains('you have sent') ||
        lower.contains('you sent') ||
        lower.contains('paid to') ||
        lower.contains('sent to') ||
        RegExp(
              r'(?:sent|transfer(?:red)?|paid)\s+(?:kes|ksh|usd|us\$|\$)\s*[,\d.]+\s+to\b',
              caseSensitive: false,
            ).hasMatch(message) ||
        lower.contains('successfully transferred') ||
        lower.contains('transfer of') ||
        lower.contains('funds transfer') ||
        lower.contains('transfer was successful') ||
        lower.contains('transfer successful') ||
        (lower.contains('was successful') &&
            (lower.contains('transfer') ||
                lower.contains('sent') ||
                lower.contains('payment') ||
                lower.contains('pesalink'))) ||
        // Pesalink alone is usually outbound — but not when clearly a credit alert.
        (lower.contains('pesalink') &&
            !(lower.contains('credited') ||
                lower.contains('you have received') ||
                lower.contains('have received') ||
                lower.contains('funds received') ||
                lower.contains('into your account'))) ||
        lower.contains('request to pay') ||
        lower.contains('withdrawn') ||
        lower.contains('withdrawal') ||
        lower.contains('purchase') ||
        lower.contains('bought airtime') ||
        RegExp(r'\byou\s+(?:have\s+)?(?:paid|sent|transfer(?:red)?)\b',
                caseSensitive: false)
            .hasMatch(message) ||
        // "Transfer of KES/USD 148,000 to JOHN was successful"
        RegExp(
              r'transfer\s+of\s+(?:kes|ksh|usd|us\$|\$)',
              caseSensitive: false,
            ).hasMatch(message) ||
        // Outbound Pesalink / "to the account of JOHN" (not *your* account).
        RegExp(
              r'transferred\b[\s\S]{0,80}\bto\s+the\s+(?:account|a/?c)\b',
              caseSensitive: false,
            ).hasMatch(message) ||
        RegExp(
              r'(?:credited|has been credited)\s+to\s+(?!your\b)',
              caseSensitive: false,
            ).hasMatch(message);

    if (clearDebit ||
        (lower.contains('debited') && !lower.contains('credited to your')) ||
        (lower.contains('deducted') && !lower.contains('to your'))) {
      return 'debit';
    }

    // Money arriving into the user's own account only.
    final inboundToYourAccount = RegExp(
          r'(?:has\s+)?transferred\b[\s\S]{0,80}\bto\s+your\s+(?:account|a/?c|wallet)\b',
          caseSensitive: false,
        ).hasMatch(message) ||
        lower.contains('transferred to your account') ||
        lower.contains('transfer to your account') ||
        lower.contains('sent to your account') ||
        lower.contains('into your account') ||
        lower.contains('credited to your account') ||
        lower.contains('credited to your a/c') ||
        lower.contains('credited to your wallet');

    final isCredit = lower.contains('you have been credited') ||
        lower.contains('your account has been credited') ||
        lower.contains('a/c has been credited') ||
        lower.contains('account has been credited') ||
        lower.contains('credited with') ||
        lower.contains('you have received') ||
        lower.contains('have received') ||
        lower.contains('funds received') ||
        lower.contains('payment received') ||
        lower.contains('received kes') ||
        lower.contains('received ksh') ||
        lower.contains('received from') ||
        lower.contains('has been deposited') ||
        lower.contains('was deposited') ||
        lower.contains('deposit of') ||
        lower.contains('inward') ||
        inboundToYourAccount ||
        // Own-ledger CR marker at start of an amount line, not "Ref CR:".
        RegExp(r'(?:^|[\s.])cr[:\s]+(?:kes|ksh|usd|us\$|\$)', caseSensitive: false)
            .hasMatch(message);

    if (isCredit) return 'credit';

    // Remaining softer debit signals (default spend, never invent income).
    if ((lower.contains('payment') && !lower.contains('payment received')) ||
        lower.contains('transferred') ||
        lower.contains('transfer') ||
        RegExp(r'\bdr[:\s]+(?:kes|ksh|usd|us\$|\$)', caseSensitive: false)
            .hasMatch(message)) {
      return 'debit';
    }
    return null;
  }

  static Map<String, dynamic> _extractEquityTransaction(String message) {
    // Equity alerts: KES / USD / Kshs / Amt: …
    final RegExp amountRegex = RegExp(
      r'(?:Amt[:\s]*|Amount[:\s]*)?(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp balanceRegex = RegExp(
      r'(?:New balance is|Available (?:Bal|Balance)|Bal(?:ance)?[:\s]*)\s*(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp dateTimeRegex = RegExp(
      r'(?:on|Date[:\s]*)\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})(?:\s+|T| at )?(\d{1,2}:\d{2}(?::\d{2})?)?',
      caseSensitive: false,
    );
    final RegExp refRegex = RegExp(
      r'(?:Ref(?:erence)?|Txn(?:\s*ID)?|Transaction\s*ID)[:.\s]+([A-Za-z0-9-]+)',
      caseSensitive: false,
    );

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> details = {
      'amount': money.amount ?? _extractAmount(amountRegex, message),
      'balance': _extractAmount(balanceRegex, message),
      'reference': _extractMatch(refRegex, message),
      'account': "Equity Bank",
      'currency': money.currency,
    };

    final dateMatch = dateTimeRegex.firstMatch(message);
    if (dateMatch != null) {
      details['datetime'] = _parseFlexibleDateTime(
        dateMatch.group(1),
        dateMatch.group(2),
      );
    }

    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      details['type'] = 'Transfer';
      details['from'] = 'Equity Bank';
      details['to'] = buildBankToMpesaTransferLabel('Equity Bank');
      details['nature'] = 'debit';
    } else if (nature == 'credit') {
      details['type'] = 'Received';
      details['from'] = _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          _extractBetween(message, 'by ', ' on') ??
          'Incoming';
      details['to'] = 'Equity Bank';
      details['nature'] = 'credit';
    } else if (nature == 'debit') {
      details['type'] = 'Payment';
      details['from'] = 'Equity Bank';
      details['to'] = _extractBetween(message, 'paid to ', ' on') ??
          _extractBetween(message, 'paid to ', '.') ??
          _extractBetween(message, 'to ', ' on') ??
          _extractBetween(message, 'to ', '.') ??
          'Outgoing';
      details['nature'] = 'debit';
    } else {
      details['type'] = 'Unknown';
      details['from'] = 'Unknown';
      details['to'] = 'Unknown';
      details['nature'] = 'unknown';
    }

    return details;
  }

  static Map<String, dynamic> _extractIMBankTransaction(String message) {
    // Kenyan alerts use KES / USD / Ksh / Kshs; amount may appear without a space.
    final RegExp amountRegex = RegExp(
      r'(?:Amt[:\s]*|Amount[:\s]*|with(?:\s+amount)?\s*)?(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp amountFallbackRegex = RegExp(
      r'(?:debited|deducted|paid|transferred|purchase|withdrawn)[^\d]{0,24}([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp balanceRegex = RegExp(
      r'(?:Available\s*(?:Bal|Balance)|New balance|Bal(?:ance)?[:\s]*)\s*(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp dateTimeRegex = RegExp(
      r'(?:on|Date[:\s]*)\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})(?:\s+|T| at )?(\d{1,2}:\d{2}(?::\d{2})?)?',
      caseSensitive: false,
    );
    final RegExp refRegex = RegExp(
      r'(?:Ref(?:erence)?|Txn(?:\s*ID)?|RRN|Transaction\s*ID)[:.\s]+([A-Za-z0-9-]+)',
      caseSensitive: false,
    );

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> details = {
      'amount': money.amount ??
          _extractAmount(amountRegex, message) ??
          _extractAmount(amountFallbackRegex, message),
      'balance': _extractAmount(balanceRegex, message),
      'reference': _extractMatch(refRegex, message),
      'account': "I&M Bank",
      'currency': money.currency,
    };

    final dateMatch = dateTimeRegex.firstMatch(message);
    if (dateMatch != null) {
      details['datetime'] = _parseFlexibleDateTime(
        dateMatch.group(1),
        dateMatch.group(2),
      );
    }

    // Only exclude own I&M → M-Pesa / I&M → other bank wallet moves.
    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      details['type'] = 'Transfer';
      details['from'] = 'I&M Bank';
      details['to'] = buildBankToMpesaTransferLabel('I&M Bank');
      details['nature'] = 'debit';
    } else if (isOwnWalletBankToBankDebit(message, 'I&M Bank')) {
      final other = detectOtherBankName(message, 'I&M Bank')!;
      details['type'] = 'Transfer';
      details['from'] = 'I&M Bank';
      details['to'] = buildBankToBankTransferLabel('I&M Bank', other);
      details['nature'] = 'debit';
    } else if (nature == 'credit' &&
        isOwnWalletBankToBankCredit(message, 'I&M Bank')) {
      final other = detectOtherBankName(message, 'I&M Bank')!;
      details['type'] = 'Transfer';
      details['from'] = buildBankToBankTransferLabel(other, 'I&M Bank');
      details['to'] = 'I&M Bank';
      details['nature'] = 'credit';
    } else if (nature == 'credit') {
      details['type'] = 'Received';
      details['from'] = _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          'Incoming';
      details['to'] = 'I&M Bank';
      details['nature'] = 'credit';
    } else if (nature == 'debit') {
      details['type'] = 'Payment';
      details['from'] = 'I&M Bank';
      details['to'] = _extractBetween(message, 'paid to ', ' on') ??
          _extractBetween(message, 'paid to ', '.') ??
          _extractBetween(message, 'sent to ', ' on') ??
          _extractBetween(message, 'transferred to ', ' on') ??
          _extractBetween(message, 'transferred to ', '.') ??
          _extractBetween(message, 'to ', ' on') ??
          _extractBetween(message, 'to ', '.') ??
          'Outgoing';
      details['nature'] = 'debit';
    } else {
      details['type'] = 'Unknown';
      details['from'] = 'Unknown';
      details['to'] = 'Unknown';
      details['nature'] = 'unknown';
    }

    return details;
  }

  static String? _parseFlexibleDateTime(String? date, String? time) {
    if (date == null) return null;
    final normalizedDate = date.replaceAll('-', '/');
    final normalizedTime = (time == null || time.trim().isEmpty)
        ? '00:00'
        : time.trim();
    for (final format in [
      'dd/MM/yyyy HH:mm:ss',
      'dd/MM/yyyy HH:mm',
      'dd/MM/yy HH:mm',
      'yyyy/MM/dd HH:mm:ss',
      'yyyy/MM/dd HH:mm',
    ]) {
      try {
        final parsed = DateFormat(format).parse('$normalizedDate $normalizedTime');
        return DateFormat('yyyy-MM-dd HH:mm:ss.000').format(parsed);
      } catch (_) {}
    }
    return null;
  }

  static Map<String, dynamic> _extractCoopTransaction(String message) {
    final RegExp amountRegex = RegExp(
      r'(?:USD|US\$|\$|KES|Ksh\.?)\s*([\d,]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp dateTimeRegex = RegExp(
        r'(?:on|at) (\d{2}[-/]\d{2}[-/]\d{4})(?:\s+|,\s*)(\d{2}:\d{2}(?::\d{2})?\s*(?:AM|PM)?)');
    final RegExp mpesaRefRegex = RegExp(r'MPESA Ref[.:]\s*(\w+)');
    final RegExp refRegex = RegExp(r'REF NO[:.]?\s*([A-Z0-9]+)');

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> result = {
      'amount': money.amount ?? _extractAmount(amountRegex, message),
      'datetime': _extractDateTime(dateTimeRegex, message),
      'account': "Coop Bank",
      'currency': money.currency,
    };

    result['reference'] = _extractMatch(mpesaRefRegex, message) ??
        _extractMatch(refRegex, message);

    final lower = message.toLowerCase();
    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      result['type'] = 'Transfer';
      result['from'] = 'Coop Bank';
      result['to'] = buildBankToMpesaTransferLabel('Co-Operative Bank');
      result['nature'] = 'debit';
    } else if (lower.contains('request to pay')) {
      result['type'] = 'Payment Request';
      result['from'] = 'Your Account';
      result['to'] = _extractBetween(message, 'to ', ' on');
      result['nature'] = 'debit';
    } else if (nature == 'credit') {
      result['type'] = 'Received';
      result['from'] = _extractBetween(message, 'from ', ' at') ??
          _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          'Incoming';
      result['to'] = 'Your Account';
      result['nature'] = 'credit';
    } else if (lower.contains('mpesa till payment') || nature == 'debit') {
      result['type'] = lower.contains('airtime')
          ? 'Airtime Purchase'
          : (lower.contains('mpesa till') ? 'Payment' : 'Transfer');
      result['from'] = 'Your Account';
      result['to'] = _extractBetween(message, 'to ', ' on') ??
          _extractBetween(message, 'to ', ' for') ??
          _extractBetween(message, 'to ', ' at') ??
          _extractBetween(
              message, 'of KES ${result['amount']} to ', ' was successful') ??
          'Outgoing';
      result['nature'] = 'debit';
    } else {
      result['type'] = 'Unknown';
      result['from'] = 'Unknown';
      result['to'] = 'Unknown';
      result['nature'] = 'unknown';
    }

    return result;
  }

  static Map<String, dynamic> _extractNCBATransaction(String message) {
    // Amounts may be KES / USD / Ksh.
    final RegExp amountRegex = RegExp(
      r'(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp balanceRegex = RegExp(
      r'(?:Available|New|Cleared)\s*(?:Bal|Balance)?[:\s]*\s*(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp dateTimeRegex = RegExp(
      r'on\s+(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\s*(?:at\s*)?(\d{1,2}:\d{2}(?:\s*[AP]M)?)?',
      caseSensitive: false,
    );
    final RegExp refRegex = RegExp(
      r'(?:Ref(?:erence)?|Txn(?:\s*ID)?|RRN)[:.\s]+([A-Za-z0-9-]+)',
      caseSensitive: false,
    );

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> details = {
      'amount': money.amount ?? _extractAmount(amountRegex, message),
      'balance': _extractAmount(balanceRegex, message),
      'reference': _extractMatch(refRegex, message),
      'account': "NCBA Bank",
      'currency': money.currency,
    };

    final dateMatch = dateTimeRegex.firstMatch(message);
    if (dateMatch != null) {
      details['datetime'] = _parseFlexibleDateTime(
        dateMatch.group(1),
        dateMatch.group(2),
      );
    }

    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      details['type'] = 'Transfer';
      details['from'] = 'NCBA Bank';
      details['to'] = buildBankToMpesaTransferLabel('NCBA Bank');
      details['nature'] = 'debit';
    } else if (isOwnWalletBankToBankDebit(message, 'NCBA Bank')) {
      final other = detectOtherBankName(message, 'NCBA Bank')!;
      details['type'] = 'Transfer';
      details['from'] = 'NCBA Bank';
      details['to'] = buildBankToBankTransferLabel('NCBA Bank', other);
      details['nature'] = 'debit';
    } else if (nature == 'credit' &&
        isOwnWalletBankToBankCredit(message, 'NCBA Bank')) {
      final other = detectOtherBankName(message, 'NCBA Bank')!;
      details['type'] = 'Transfer';
      details['from'] = buildBankToBankTransferLabel(other, 'NCBA Bank');
      details['to'] = 'NCBA Bank';
      details['nature'] = 'credit';
    } else if (nature == 'credit') {
      details['type'] = 'Received';
      details['from'] = _extractBetween(message, 'from ', ' was successful') ??
          _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          _extractBetween(message, 'by ', ' on') ??
          'Incoming';
      details['to'] = 'Your Account';
      details['nature'] = 'credit';
    } else if (nature == 'debit') {
      details['type'] = 'Payment';
      details['from'] = 'Your Account';
      details['to'] = _extractBetween(message, 'to ', ' was successful') ??
          _extractBetween(message, 'paid to ', ' was successful') ??
          _extractBetween(message, 'paid to ', ' on') ??
          _extractBetween(message, 'to ', ' on') ??
          _extractBetween(message, 'to ', '.') ??
          'Outgoing';
      details['nature'] = 'debit';
    } else {
      details['type'] = 'Unknown';
      details['from'] = 'Unknown';
      details['to'] = 'Unknown';
      details['nature'] = 'unknown';
    }

    return details;
  }

  static Map<String, dynamic> _extractStanbicTransaction(String message) {
    final RegExp amountRegex = RegExp(
      r'(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp refRegex = RegExp(
      r'(?:Ref(?:ID)?|Reference)[:.\s]+([A-Za-z0-9-]+)',
      caseSensitive: false,
    );
    final RegExp dateTimeRegex = RegExp(
      r'on\s+(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\s*(?:at\s*)?(\d{1,2}:\d{2})?',
      caseSensitive: false,
    );

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> result = {
      'amount': money.amount ?? _extractAmount(amountRegex, message),
      'reference': _extractMatch(refRegex, message),
      'account': "Stanbic Bank",
      'currency': money.currency,
    };

    final dateMatch = dateTimeRegex.firstMatch(message);
    if (dateMatch != null) {
      result['datetime'] = _parseFlexibleDateTime(
        dateMatch.group(1),
        dateMatch.group(2),
      );
    }

    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      result['type'] = 'Transfer';
      result['from'] = 'Stanbic Bank';
      result['to'] = buildBankToMpesaTransferLabel('Stanbic Bank');
      result['nature'] = 'debit';
    } else if (nature == 'credit') {
      result['type'] = 'Received';
      result['from'] = _extractBetween(message, 'from ', ' through') ??
          _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          'Incoming';
      result['to'] = 'Your Account';
      result['nature'] = 'credit';
    } else if (nature == 'debit') {
      result['type'] = 'Payment';
      result['from'] = 'Your Account';
      result['to'] = _extractBetween(message, 'to ', ' for') ??
          _extractBetween(message, 'paid ', ' for') ??
          _extractBetween(message, 'to ', '.') ??
          'Outgoing';
      result['nature'] = 'debit';
    } else {
      result['type'] = 'Unknown';
      result['from'] = 'Unknown';
      result['to'] = 'Unknown';
      result['nature'] = 'unknown';
    }

    return result;
  }

  static Map<String, dynamic> _extractStandardCharteredTransaction(
      String message) {
    final RegExp amountRegex = RegExp(
      r'(?:USD|US\$|\$|KES|Kshs?|KSH)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final RegExp dateRegex = RegExp(
      r'on\s+(\d{4}-\d{2}-\d{2}|\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
      caseSensitive: false,
    );
    final RegExp refRegex = RegExp(
      r'(?:ref|reference)[:\s]*([A-Za-z0-9-]+)',
      caseSensitive: false,
    );

    final money = extractSmsAmountAndCurrency(message);
    Map<String, dynamic> result = {
      'amount': money.amount ?? _extractAmount(amountRegex, message),
      'reference': _extractMatch(refRegex, message),
      'datetime': _extractMatch(dateRegex, message),
      'account': "Standard Chartered Bank",
      'currency': money.currency,
    };

    final lower = message.toLowerCase();
    final nature = classifySmsNature(message);
    if (isOwnWalletBankToMpesaMove(message)) {
      result['type'] = 'Transfer';
      result['from'] = 'Standard Chartered Bank';
      result['to'] = buildBankToMpesaTransferLabel('Standard Chartered Bank');
      result['nature'] = 'debit';
    } else if (nature == 'credit') {
      result['type'] = lower.contains('deposited') ? 'Deposit' : 'Received';
      result['from'] =
          _extractBetween(message, 'Good day, ', ' has transferred') ??
              _extractBetween(message, 'from ', ' on') ??
              'Incoming';
      result['to'] = 'Your Account';
      result['nature'] = 'credit';
    } else if (lower.contains('was made on card') || nature == 'debit') {
      result['type'] =
          lower.contains('card') ? 'Card Payment' : 'Transfer';
      result['from'] = lower.contains('card') ? 'Your Card' : 'Your Account';
      result['to'] = _extractBetween(message, 'at ', ' on') ??
          _extractBetween(message, 'to ', ' on') ??
          'Outgoing';
      result['nature'] = 'debit';
    } else {
      result['type'] = 'Unknown';
      result['from'] = 'Unknown';
      result['to'] = 'Unknown';
      result['nature'] = 'unknown';
    }

    return result;
  }

  static Map<String, dynamic> _extractMPESATransaction(String message) {
    final details = {
      'account': 'MPESA',
      'cost': '0.00',
      'currency': 'KES',
    };

    final regexPatterns = {
      'reference': r'\b([A-Z0-9]{10})\b',
      // Case-insensitive: SMS may say Ksh, KSh, or KES.
      'amount': r'(?:Ksh|KSh|KES|Kes)\s*([,\d]+(?:\.\d{1,2})?)',
      'datetime': r'on (\d{1,2}/\d{1,2}/\d{2,4}) at (\d{1,2}:\d{2} (?:AM|PM))',
      'transactionCost':
          r'Transaction cost,?\s*(?:Ksh|KSh|KES)\.?\s*([,\d]+(?:\.\d{1,2})?)',
      'newBalance':
          r'(?:New M-PESA balance is|Your M-PESA balance is) (?:Ksh|KSh|KES)([,\d]+(?:\.\d{1,2})?)',
      'fromTo':
          r"(paid to|received from|sent to|sent\s+(?:Ksh|KSh|KES)\s*[,\d.]+\s+to|from|to) ([A-Za-z\s.'\-]+(?:\s+\d+)?|\+?\d+)",
      'fulizaAmount':
          r'Fuliza M-PESA amount is (?:Ksh|KSh|KES) ([,\d]+(?:\.\d{1,2})?)',
      'fulizaOutstanding':
          r'Total Fuliza M-PESA outstanding amount is (?:Ksh|KSh|KES) ([,\d]+(?:\.\d{1,2})?)',
    };

    void extractMatch(String key, String pattern, [String? valueKey]) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(message);
      if (match != null) {
        details[valueKey ?? key] = match.group(1)!.replaceAll(',', '');
      }
    }

    extractMatch('reference', regexPatterns['reference']!);
    extractMatch('amount', regexPatterns['amount']!);
    extractMatch('cost', regexPatterns['transactionCost']!);
    extractMatch('balance', regexPatterns['newBalance']!);

    // Extract datetime
    final datetimeMatch =
        RegExp(regexPatterns['datetime']!).firstMatch(message);
    if (datetimeMatch != null) {
      final dateTimeString =
          '${datetimeMatch.group(1)} ${datetimeMatch.group(2)}';
      try {
        final date = DateFormat('dd/MM/yy hh:mm a').parse(dateTimeString);
        details['datetime'] =
            DateFormat('yyyy-MM-dd HH:mm:ss.000').format(date);
      } catch (e) {
        details['datetime'] = DateTime.now().toString();
      }
    }

    final lowerMessage = message.toLowerCase();

    // Determine credit vs debit from clear Safaricom wording FIRST.
    // Bare "to"/"from" regex matches were mis-labeling received money as expense.
    if (lowerMessage.contains('fuliza')) {
      details['type'] = lowerMessage.contains('partially pay')
          ? 'Fuliza Partial Payment'
          : 'Fuliza Repayment';
      details['from'] =
          lowerMessage.contains('partially pay') ? 'Fuliza' : 'M-PESA to Fuliza';
      details['to'] =
          lowerMessage.contains('partially pay') ? 'Fuliza to M-PESA' : 'Fuliza';
      details['nature'] =
          lowerMessage.contains('partially pay') ? 'credit' : 'debit';

      extractMatch('fulizaAmount', regexPatterns['fulizaAmount']!);
      extractMatch('fulizaOutstanding', regexPatterns['fulizaOutstanding']!);

      if (!details.containsKey('amount') &&
          details.containsKey('fulizaAmount')) {
        details['amount'] = details['fulizaAmount']!;
      }
    } else if (lowerMessage.contains('airtime') ||
        lowerMessage.contains('bought airtime') ||
        (lowerMessage.contains('bought') && lowerMessage.contains('for'))) {
      details['type'] = 'Airtime Purchase';
      details['from'] = 'M-PESA For Airtime';
      details['to'] = 'Mpesa For Airtime';
      details['nature'] = 'debit';
    } else if (lowerMessage.contains('paid bill for')) {
      details['type'] = 'Bill Payment';
      details['from'] = 'M-PESA';
      details['to'] =
          _extractBetween(message, 'paid bill for ', ' on') ?? 'Unknown';
      details['nature'] = 'debit';
    } else if (lowerMessage.contains('paid to') ||
        lowerMessage.contains('sent to') ||
        lowerMessage.contains('has been sent') ||
        lowerMessage.contains('withdraw') ||
        RegExp(r'sent\s+(?:ksh|kes)', caseSensitive: false)
            .hasMatch(message)) {
      // Debit before "received" so send SMS with "Transaction received" stay expenses.
      final party = _extractBetween(message, 'sent to ', ' on') ??
          _extractBetween(message, 'paid to ', ' on') ??
          _extractBetween(message, ' to ', ' on') ??
          'Outgoing';
      final linkedBank = detectLinkedBankName(message) ??
          detectLinkedBankName(party);
      if (linkedBank != null && isOwnWalletMpesaToBankMove(message)) {
        details['type'] = 'Transfer';
        details['from'] = buildMpesaToBankTransferLabel(linkedBank);
        details['to'] = buildMpesaToBankTransferLabel(linkedBank);
        details['nature'] = 'debit';
      } else {
        details['type'] = 'Payment';
        details['from'] = 'M-pesa to $party';
        details['to'] = 'M-pesa to $party';
        details['nature'] = 'debit';
      }
    } else if (lowerMessage.contains('you have received') ||
        lowerMessage.contains('have received') ||
        RegExp(r'\breceived\s+(?:ksh|kes)', caseSensitive: false)
            .hasMatch(message) ||
        lowerMessage.contains('received from') ||
        lowerMessage.contains('confirmed.you have received') ||
        (lowerMessage.contains('received') &&
            !lowerMessage.contains('transaction received') &&
            !lowerMessage.contains('sms received'))) {
      final party = _extractBetween(message, 'from ', ' on') ??
          _extractBetween(message, 'from ', '.') ??
          _extractBetween(message, 'from ', ' New') ??
          'Incoming';
      if (isMpesaCreditFromOwnBank(message, party)) {
        final linkedBank = detectLinkedBankName(message) ??
            detectLinkedBankName(party) ??
            'Bank';
        // Money moved from your bank wallet into M-Pesa — not new income.
        details['type'] = 'Transfer';
        details['from'] = buildMpesaFromBankTransferLabel(linkedBank);
        details['to'] = buildMpesaFromBankTransferLabel(linkedBank);
        details['nature'] = 'credit';
      } else {
        details['type'] = 'Received';
        details['from'] = '$party to M-pesa';
        details['to'] = '$party to M-pesa';
        details['nature'] = 'credit';
      }
    } else {
      final fromToMatch =
          RegExp(regexPatterns['fromTo']!, caseSensitive: false)
              .firstMatch(message);
      if (fromToMatch != null) {
        final action = fromToMatch.group(1)!.toLowerCase();
        final party = fromToMatch.group(2)!.trim();

        final isDebit = action.contains('paid to') ||
            action.contains('sent to') ||
            (action.contains('sent') && action.contains('to'));
        // Do NOT treat bare "to" as debit — it appears in receive SMS too.
        if (isDebit) {
          details['type'] = 'Payment';
          details['from'] = 'M-pesa to $party';
          details['to'] = 'M-pesa to $party';
          details['nature'] = 'debit';
        } else if (action.contains('received') || action == 'from') {
          details['type'] = 'Received';
          details['from'] = '$party to M-pesa';
          details['to'] = '$party to M-pesa';
          details['nature'] = 'credit';
        } else {
          details['type'] = 'Unknown';
          details['from'] = 'Unknown';
          details['to'] = 'Unknown';
          details['nature'] = 'unknown';
        }
      } else {
        details['type'] = 'Unknown';
        details['from'] = 'Unknown';
        details['to'] = 'Unknown';
        details['nature'] = 'unknown';
      }
    }

    return details;
  }

  static String? _extractAmount(RegExp regex, String message) {
    final match = regex.firstMatch(message);
    return match?.group(1)?.replaceAll(',', '');
  }

  static String? _extractDateTime(RegExp regex, String message) {
    final match = regex.firstMatch(message);
    if (match != null) {
      try {
        final dateTime = DateFormat('dd-MM-yyyy HH:mm')
            .parse('${match.group(1)} ${match.group(2)}');
        return dateTime.toString();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static String? _extractMatch(RegExp regex, String message) {
    final match = regex.firstMatch(message);
    return match?.group(1);
  }

  static String? _extractBetween(String message, String start, String end) {
    final lower = message.toLowerCase();
    final startL = start.toLowerCase();
    final endL = end.toLowerCase();
    final startIndex = lower.indexOf(startL);
    if (startIndex == -1) return null;
    final endIndex = lower.indexOf(endL, startIndex + startL.length);
    if (endIndex == -1) return null;
    return message.substring(startIndex + startL.length, endIndex).trim();
  }
}
