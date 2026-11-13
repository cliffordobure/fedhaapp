/// Canonical SMS sender → wallet display name used in prefs / API.
const Map<String, String> smsAddressToWalletName = {
  'MPESA': 'M-Pesa',
  'CoopBank': 'Co-Operative Bank',
  'NCBA_BANK': 'NCBA Bank',
  'Stanbic': 'Stanbic Bank',
  'StanChart': 'Standard Chartered Bank',
  'Equity Bank': 'Equity Bank',
  'I&M Bank': 'I&M Bank',
};

String _compactAlnum(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9&]'), '');

bool _looksLikeCoop(String value) {
  final c = _compactAlnum(value);
  return c.contains('coop') ||
      c.contains('cooperative') ||
      c.contains('coopsacco');
}

/// Normalize carrier sender IDs to a canonical key in [supportedBanks].
String? normalizeSmsAddress(String? address) {
  if (address == null) return null;
  final trimmed = address.trim();
  if (trimmed.isEmpty) return null;

  final compact = trimmed
      .toUpperCase()
      .replaceAll(RegExp(r'[\s._-]+'), '')
      .replaceAll('AND', '&');

  if (compact == 'MPESA' || (compact.contains('MPESA') && compact.length <= 8)) {
    return 'MPESA';
  }

  // Equity Bank Kenya senders: Equity Bank, EQUITYBANK, EQUITY, etc.
  if (compact == 'EQUITYBANK' ||
      compact == 'EQUITY' ||
      compact.startsWith('EQUITYBANK') ||
      compact.startsWith('EQUITY')) {
    return 'Equity Bank';
  }

  // I&M Bank Kenya senders: I&M Bank, IMBANK, I&M, etc.
  if (compact == 'I&MBANK' ||
      compact == 'IMBANK' ||
      compact == 'I&M' ||
      compact == 'IM' ||
      compact.startsWith('I&MBANK') ||
      compact.startsWith('IMBANK')) {
    return 'I&M Bank';
  }

  // Co-op: after stripping dashes, CO-OPERATIVEBANK → COOPERATIVEBANK.
  if (compact == 'COOPBANK' ||
      compact == 'COOPERATIVEBANK' ||
      compact == 'COOPERATIVE' ||
      compact == 'COOP' ||
      compact.startsWith('COOPBANK') ||
      compact.startsWith('COOPERATIVE') ||
      compact.startsWith('COOP')) {
    return 'CoopBank';
  }
  if (compact == 'NCBA' ||
      compact == 'NCBABANK' ||
      compact == 'NCBA_BANK' ||
      compact.startsWith('NCBA')) {
    return 'NCBA_BANK';
  }
  if (compact == 'STANBIC' ||
      compact == 'STANBICBANK' ||
      compact.startsWith('STANBIC')) {
    return 'Stanbic';
  }
  if (compact == 'STANCHART' ||
      compact == 'STANCHARTBANK' ||
      compact == 'STANDARDCHARTERED' ||
      compact == 'STANDARDCHARTEREDBANK' ||
      compact == 'SCB' ||
      compact == 'SCBL' ||
      compact.startsWith('STANCHART') ||
      compact.startsWith('STANDARDCHARTERED')) {
    return 'StanChart';
  }

  // Exact / case-insensitive match against known canonical keys.
  for (final key in smsAddressToWalletName.keys) {
    if (key.toLowerCase() == trimmed.toLowerCase()) return key;
  }
  return trimmed;
}

/// When Android shows a numeric shortcode / unknown sender, infer bank from body.
String? inferCanonicalSmsAddressFromBody(String? body) {
  if (body == null || body.trim().isEmpty) return null;
  final bank = detectLinkedBankName(body);
  if (bank == null) return null;
  for (final entry in smsAddressToWalletName.entries) {
    if (walletNameMatchesSmsBank(entry.value, bank)) return entry.key;
  }
  return null;
}

/// Resolve the best canonical SMS address for filtering / parsing.
String? resolveSmsAddress({String? address, String? body}) {
  final fromAddress = normalizeSmsAddress(address);
  if (fromAddress != null && smsAddressToWalletName.containsKey(fromAddress)) {
    return fromAddress;
  }
  final fromBody = inferCanonicalSmsAddressFromBody(body);
  if (fromBody != null) return fromBody;
  return fromAddress;
}

bool walletNameMatchesSmsBank(String walletName, String smsWalletName) {
  final a = walletName.toLowerCase().trim();
  final b = smsWalletName.toLowerCase().trim();
  if (a.isEmpty || b.isEmpty) return false;
  if (a == b) return true;

  final ca = _compactAlnum(a);
  final cb = _compactAlnum(b);
  if (ca == cb) return true;
  if (ca.contains(cb) || cb.contains(ca)) {
    // Avoid tiny accidental overlaps (e.g. "im").
    if (ca.length >= 4 && cb.length >= 4) return true;
  }

  if (a.contains('pesa') && b.contains('pesa')) return true;
  if (a.contains('equity') && b.contains('equity')) return true;
  if ((a.contains('i&m') ||
          a.contains('i & m') ||
          a.contains('i and m') ||
          a.contains('imbank') ||
          ca.contains('imbank') ||
          ca.contains('i&m')) &&
      (b.contains('i&m') ||
          b.contains('i & m') ||
          b.contains('i and m') ||
          b.contains('imbank') ||
          cb.contains('imbank') ||
          cb.contains('i&m'))) {
    return true;
  }
  if (_looksLikeCoop(a) && _looksLikeCoop(b)) return true;
  if (a.contains('ncba') && b.contains('ncba')) return true;
  if (a.contains('stanbic') && b.contains('stanbic')) return true;
  if ((a.contains('standard chartered') ||
          a.contains('stanchart') ||
          ca.contains('standardchartered') ||
          ca.contains('stanchart')) &&
      (b.contains('standard chartered') ||
          b.contains('stanchart') ||
          cb.contains('standardchartered') ||
          cb.contains('stanchart'))) {
    return true;
  }
  return false;
}

/// Prefix used so home Income/Expense can ignore own-wallet moves.
const String kInternalTransferPrefix = 'Transfer:';

String buildBankToMpesaTransferLabel(String bankName) =>
    '$kInternalTransferPrefix $bankName → M-Pesa';

String buildMpesaFromBankTransferLabel(String bankName) =>
    '$kInternalTransferPrefix from $bankName';

String buildMpesaToBankTransferLabel(String bankName) =>
    '$kInternalTransferPrefix M-Pesa → $bankName';

String buildBankToBankTransferLabel(String fromBank, String toBank) =>
    '$kInternalTransferPrefix $fromBank → $toBank';

/// All supported banks mentioned in an SMS body (order = detection priority).
List<String> detectLinkedBankNames(String message) {
  final lower = message.toLowerCase();
  final found = <String>[];

  void addIf(String name, bool match) {
    if (!match) return;
    if (found.any((b) => walletNameMatchesSmsBank(b, name))) return;
    found.add(name);
  }

  addIf(
    'I&M Bank',
    lower.contains('i&m') ||
        lower.contains('i & m') ||
        lower.contains('i and m') ||
        lower.contains('imbank'),
  );
  addIf('Equity Bank', lower.contains('equity'));
  addIf(
    'Co-Operative Bank',
    lower.contains('co-operative') ||
        lower.contains('cooperative') ||
        lower.contains('co-op') ||
        RegExp(r'\bcoop\b').hasMatch(lower) ||
        lower.contains('coop bank'),
  );
  addIf('NCBA Bank', lower.contains('ncba'));
  addIf('Stanbic Bank', lower.contains('stanbic'));
  addIf(
    'Standard Chartered Bank',
    lower.contains('standard chartered') || lower.contains('stanchart'),
  );
  return found;
}

/// Another supported bank in the SMS, excluding [selfBank].
String? detectOtherBankName(String message, String selfBank) {
  for (final name in detectLinkedBankNames(message)) {
    if (!walletNameMatchesSmsBank(name, selfBank)) return name;
  }
  return null;
}

/// Own-wallet bank → bank debit (e.g. I&M Pesalink/transfer to NCBA).
bool isOwnWalletBankToBankDebit(String message, String sourceBank) {
  final other = detectOtherBankName(message, sourceBank);
  if (other == null) return false;

  final lower = message.toLowerCase();
  final looksLikeMove = lower.contains('transfer') ||
      lower.contains('transferred') ||
      lower.contains('pesalink') ||
      lower.contains('sent to') ||
      lower.contains('paid to') ||
      lower.contains('funds transfer') ||
      lower.contains('has been debited') ||
      lower.contains('you have been debited') ||
      lower.contains('was successful');

  if (!looksLikeMove) return false;

  // Inbound credit wording means this is the destination bank SMS, not source.
  if (lower.contains('you have been credited') ||
      lower.contains('has been credited') ||
      lower.contains('you have received') ||
      lower.contains('credited with') ||
      lower.contains('funds received')) {
    return false;
  }
  return true;
}

/// Own-wallet bank → bank credit on the destination bank SMS.
bool isOwnWalletBankToBankCredit(String message, String destBank) {
  final other = detectOtherBankName(message, destBank);
  if (other == null) return false;

  final lower = message.toLowerCase();
  return lower.contains('you have been credited') ||
      lower.contains('has been credited') ||
      lower.contains('credited with') ||
      lower.contains('you have received') ||
      lower.contains('have received') ||
      lower.contains('funds received') ||
      lower.contains('received from') ||
      lower.contains('transferred to your account') ||
      lower.contains('credited to your account') ||
      lower.contains('into your account') ||
      RegExp(
        r'(?:from|by)\s+(?:i\s*&\s*m|imbank|equity|co-?op|ncba|stanbic|standard\s+chartered|stanchart)',
        caseSensitive: false,
      ).hasMatch(lower);
}

/// Kenyan mobile numbers in SMS (beneficiary of a third-party send).
final RegExp kKenyaMobileInSms = RegExp(
  r'(?:\+?254|0)\s*7\d{8}|\b7\d{8}\b',
  caseSensitive: false,
);

/// True when the SMS is clearly paying / sending to another person or account
/// (not the user's own M-Pesa wallet).
bool looksLikeThirdPartySend(String message) {
  final lower = message.toLowerCase();

  if (kKenyaMobileInSms.hasMatch(message)) return true;

  // Pesalink / RTGS / EFT / account-to-account to someone else.
  if (lower.contains('pesalink') ||
      lower.contains('rtgs') ||
      lower.contains('eft ') ||
      lower.contains('swift') ||
      RegExp(r'\bto\s+the\s+(?:account|a/?c)\s+of\b', caseSensitive: false)
          .hasMatch(lower) ||
      RegExp(r'\bbeneficiary\b', caseSensitive: false).hasMatch(lower)) {
    return true;
  }

  // "paid to JOHN" / "sent to MARY" / "sent KES/USD 9,500.00 to JAMES"
  if (RegExp(
        r'(?:paid|sent|transfer(?:red)?)\s+(?:(?:kes|ksh|usd|us\$|\$)\s*[,\d.]+\s+)?to\s+(?!your\b)(?!m[\s-]?pesa\b)(?!mpesa\b)[a-z]',
        caseSensitive: false,
      ).hasMatch(lower) &&
      !RegExp(
        r'(?:paid|sent|transfer(?:red)?)\s+(?:(?:kes|ksh|usd|us\$|\$)\s*[,\d.]+\s+)?to\s+(?:your\s+)?m[\s-]?pesa\b',
        caseSensitive: false,
      ).hasMatch(lower)) {
    return true;
  }

  // "Transfer of KES/USD X to NAME"
  if (RegExp(
        r'transfer\s+of\s+(?:kes|ksh|usd|us\$|\$)\s*[,\d.]+\s+to\s+(?!your\b)(?!m[\s-]?pesa\b)',
        caseSensitive: false,
      ).hasMatch(lower)) {
    return true;
  }

  return false;
}

/// True only for moving money between the user's own bank and own M-Pesa.
/// Ordinary payments (Pesalink, paybill, send-to-phone) stay expenses.
bool isOwnWalletBankToMpesaMove(String message) {
  final lower = message.toLowerCase();
  if (!mentionsMpesa(lower)) return false;

  // Never treat third-party mobile / Pesalink sends as own-wallet shuffles.
  if (looksLikeThirdPartySend(message)) return false;

  // Require explicit "your M-Pesa" OR transfer/sent … to M-Pesa (no person/phone).
  final toOwnMpesa = RegExp(
        r'(?:transfer(?:red)?|sent|moved|push(?:ed)?)\s+to\s+your\s+m[\s-]?pesa',
        caseSensitive: false,
      ).hasMatch(lower) ||
      RegExp(
        r'(?:into|to)\s+your\s+m[\s-]?pesa',
        caseSensitive: false,
      ).hasMatch(lower) ||
      lower.contains('to your m-pesa') ||
      lower.contains('to your mpesa') ||
      lower.contains('into your m-pesa') ||
      lower.contains('your m-pesa wallet') ||
      lower.contains('your mpesa wallet') ||
      // "transferred/sent … to M-Pesa" or "into M-PESA" with a move verb nearby.
      RegExp(
            r'(?:transfer(?:red)?|sent|moved|push(?:ed)?|has been)\b[\s\S]{0,48}(?:to|into)\s+m[\s-]?pesa\b',
            caseSensitive: false,
          ).hasMatch(lower) ||
      lower.contains('withdrawal to m-pesa') ||
      lower.contains('withdrawn to m-pesa');

  if (!toOwnMpesa) return false;

  // "paid to JOHN via M-Pesa" is spending, not an own-wallet shuffle.
  if (RegExp(r'paid\s+to\s+\w', caseSensitive: false).hasMatch(lower) &&
      !RegExp(r'paid\s+to\s+(?:your\s+)?m[\s-]?pesa', caseSensitive: false)
          .hasMatch(lower)) {
    return false;
  }
  return true;
}

/// M-Pesa → bank (e.g. "sent to EQUITY BANK" / "Bank Deposit to …").
bool isOwnWalletMpesaToBankMove(String message) {
  final lower = message.toLowerCase();
  final bank = detectLinkedBankName(message);
  if (bank == null) return false;

  // Receive-on-M-Pesa from a bank is the bank→M-Pesa credit leg, not M-Pesa→bank.
  if (lower.contains('you have received') ||
      lower.contains('have received') ||
      RegExp(r'\breceived\s+(?:ksh|kes)', caseSensitive: false).hasMatch(lower)) {
    return false;
  }

  // Sending to a person who happens to bank at Equity is not own-wallet.
  if (looksLikeThirdPartySend(message) &&
      !RegExp(
        r'(?:sent|transfer(?:red)?|paid|deposit(?:ed)?)\s+to\s+(?:your\s+)?(?:bank\s+account|equity\s+bank|co-?op|ncba|stanbic|standard\s+chartered|i\s*&\s*m)',
        caseSensitive: false,
      ).hasMatch(lower)) {
    return false;
  }

  return RegExp(
        r'(?:sent|transfer(?:red)?|paid|deposit(?:ed)?)\s+to\s+(?:your\s+)?(?:bank|equity\s+bank|co-?operative|co-?op\s+bank|ncba|stanbic|standard\s+chartered|i\s*&\s*m)',
        caseSensitive: false,
      ).hasMatch(lower) ||
      lower.contains('bank deposit') ||
      lower.contains('deposited to bank') ||
      lower.contains('to bank account');
}

/// M-Pesa "received from X" is an own-wallet bank→M-Pesa credit only when
/// [party] is clearly a bank (not "JOHN DOE" or a phone number).
bool isMpesaCreditFromOwnBank(String message, String? party) {
  final bank = detectLinkedBankName(message) ??
      (party != null ? detectLinkedBankName(party) : null);
  if (bank == null) return false;
  if (looksLikeThirdPartySend(message)) return false;

  final p = (party ?? '').toLowerCase().trim();
  if (p.isEmpty) {
    // Body must still look like a bank source, not a person.
    return detectLinkedBankName(message) != null &&
        !RegExp(r'received\s+from\s+[a-z]+\s+[a-z]+', caseSensitive: false)
            .hasMatch(message.toLowerCase());
  }

  // Party is essentially the bank name alone (optionally with "bank").
  final bankLower = bank.toLowerCase();
  final compactParty = p.replaceAll(RegExp(r'[^a-z0-9&]'), '');
  final compactBank = bankLower.replaceAll(RegExp(r'[^a-z0-9&]'), '');
  if (compactParty.contains(compactBank) || compactBank.contains(compactParty)) {
    return true;
  }
  if (p.contains('equity') ||
      p.contains('co-op') ||
      p.contains('coop') ||
      p.contains('cooperative') ||
      p.contains('ncba') ||
      p.contains('stanbic') ||
      p.contains('stanchart') ||
      p.contains('standard chartered') ||
      p.contains('i&m') ||
      p.contains('i & m')) {
    // Reject "john equity" style — party should start with bank token.
    return RegExp(
      r'^(?:equity|co-?op|cooperative|ncba|stanbic|standard|stanchart|i\s*&\s*m|imbank)',
      caseSensitive: false,
    ).hasMatch(p);
  }
  return false;
}

bool narrationIsInternalTransfer(String? narration) {
  final n = (narration ?? '').toLowerCase().trim();
  if (n.isEmpty) return false;

  // Labels we set for own-wallet bank ↔ M-Pesa / bank ↔ bank moves.
  if (n.startsWith('transfer:') ||
      n.contains('[xfer:') ||
      n.contains('→ m-pesa') ||
      n.contains('m-pesa →') ||
      n.contains('internal transfer')) {
    return true;
  }
  // "Transfer: I&M Bank → NCBA Bank" (arrow between two banks).
  if (n.contains('→') && detectLinkedBankNames(n).length >= 2) {
    return true;
  }
  // "Transfer from Equity Bank" credit-leg label (without arrow).
  if (n.startsWith('transfer from ') && detectLinkedBankName(n) != null) {
    return true;
  }

  // Legacy: only re-detect on full SMS-like text (amounts/refs), never on
  // short UI narrations like "Jane to M-pesa" (person → your phone = income).
  if (n.contains('kes') || n.contains('ksh') || n.contains('ref')) {
    return isOwnWalletBankToMpesaMove(n) || isOwnWalletMpesaToBankMove(n);
  }
  return false;
}

/// Detect bank ↔ M-Pesa wording in an SMS body (own money moving).
String? detectLinkedBankName(String message) {
  final all = detectLinkedBankNames(message);
  return all.isEmpty ? null : all.first;
}

bool mentionsMpesa(String message) {
  final lower = message.toLowerCase();
  return lower.contains('m-pesa') ||
      lower.contains('mpesa') ||
      lower.contains('m pesa');
}

/// Currency token used in Kenyan bank SMS (KES or USD dollar accounts).
const String kSmsCurrencyPattern = r'(?:USD|US\$|\$|KES|Kshs?|KSH)';

/// Normalize a raw currency token from SMS to `USD` or `KES`.
String normalizeSmsCurrency(String? raw) {
  final s = (raw ?? '').trim().toUpperCase();
  if (s.isEmpty) return 'KES';
  if (s.contains('USD') ||
      s == 'US\$' ||
      s == '\$' ||
      s.contains('DOLLAR')) {
    return 'USD';
  }
  return 'KES';
}

/// Detect transaction currency from SMS body (dollar account vs KES).
String detectSmsCurrency(String message) {
  final lower = message.toLowerCase();

  // Explicit dollar-account wording wins.
  if (lower.contains('usd account') ||
      lower.contains('dollar account') ||
      lower.contains('us dollar') ||
      lower.contains('u.s. dollar') ||
      RegExp(r'\busd\b').hasMatch(lower) ||
      lower.contains('us\$')) {
    return 'USD';
  }

  // First amount's currency code.
  final amountCur = RegExp(
    '$kSmsCurrencyPattern\\.\\s*[\\d,]',
    caseSensitive: false,
  ).firstMatch(message);
  if (amountCur != null) {
    return normalizeSmsCurrency(amountCur.group(0));
  }

  // Bare $1,200.00 with no KES/Ksh nearby.
  if (RegExp(r'\$\s*[,\d]+').hasMatch(message) &&
      !lower.contains('kes') &&
      !lower.contains('ksh')) {
    return 'USD';
  }

  return 'KES';
}

/// Extract the first money amount and its currency from an SMS.
({String? amount, String currency}) extractSmsAmountAndCurrency(String message) {
  final re = RegExp(
    '(?:Amt[:\\s]*|Amount[:\\s]*)?($kSmsCurrencyPattern)\\.?\\s*([,\\d]+(?:\\.\\d{1,2})?)',
    caseSensitive: false,
  );
  final match = re.firstMatch(message);
  if (match != null) {
    return (
      amount: match.group(2)?.replaceAll(',', ''),
      currency: normalizeSmsCurrency(match.group(1)),
    );
  }
  return (amount: null, currency: detectSmsCurrency(message));
}

bool walletCurrencyMatches(String? walletCurrency, String smsCurrency) {
  final w = normalizeSmsCurrency(walletCurrency);
  final s = normalizeSmsCurrency(smsCurrency);
  return w == s;
}
