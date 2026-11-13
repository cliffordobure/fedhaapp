/// Catalog of labeled Kenyan bank / M-Pesa SMS samples used as fixtures
/// for parser tests and as a living reference when adding new formats.
///
/// Add real (anonymized) SMS here whenever a new pattern appears in the wild.
library;

class SmsSample {
  const SmsSample({
    required this.id,
    required this.sender,
    required this.body,
    required this.expectedNature,
    required this.expectedKind,
    this.notes,
  });

  final String id;
  /// Canonical sender after [normalizeSmsAddress], e.g. `MPESA`, `Equity Bank`.
  final String sender;
  final String body;
  /// `credit`, `debit`, or `unknown`.
  final String expectedNature;
  /// `expense`, `income`, `bank_to_mpesa`, `mpesa_to_bank`, `ignore`.
  final String expectedKind;
  final String? notes;
}

/// Curated samples covering own-wallet bank ↔ M-Pesa and normal spend/receive.
const List<SmsSample> kSmsSampleCatalog = [
  // --- Equity → M-Pesa (own wallet) ---
  SmsSample(
    id: 'equity_to_mpesa_1',
    sender: 'Equity Bank',
    body:
        'Dear Customer, you have transferred KES 2,500.00 to your M-PESA on 16/08/26 at 14:22. Ref EQX91AB2. New balance is KES 12,300.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),
  SmsSample(
    id: 'equity_to_mpesa_2',
    sender: 'Equity Bank',
    body:
        'Amt: KES 1,000.00 has been transferred to M-PESA. Ref: EQ99881. Available Bal KES 5,400.00 on 16/08/2026 09:10.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),

  // --- M-Pesa receive from bank (counterpart) ---
  SmsSample(
    id: 'mpesa_from_equity_1',
    sender: 'MPESA',
    body:
        'EQX91AB2 Confirmed.You have received Ksh2,500.00 from EQUITY BANK on 16/8/26 at 2:22 PM New M-PESA balance is Ksh3,100.00.',
    expectedNature: 'credit',
    expectedKind: 'bank_to_mpesa',
    notes: 'Credit leg of own bank→M-Pesa; not income',
  ),

  // --- Coop / NCBA / Stanbic / StanChart / I&M → M-Pesa ---
  SmsSample(
    id: 'coop_to_mpesa_1',
    sender: 'CoopBank',
    body:
        'Co-op Bank: KES 800.00 transferred to your M-Pesa on 15/08/26 11:05. Ref CB77881. Avail Bal KES 9,200.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),
  SmsSample(
    id: 'ncba_to_mpesa_1',
    sender: 'NCBA_BANK',
    body:
        'NCBA: You have transferred KES 3,000.00 into M-PESA. Ref NCB445. Available Balance KES 20,000.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),
  SmsSample(
    id: 'stanbic_to_mpesa_1',
    sender: 'Stanbic',
    body:
        'Stanbic: KES 500.00 sent to your M-PESA wallet on 14/08/26. Ref ST991. New balance KES 4,100.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),
  SmsSample(
    id: 'stanchart_to_mpesa_1',
    sender: 'StanChart',
    body:
        'Standard Chartered: You transferred KES 1,200.00 to M-PESA. Ref SC331. Available Bal KES 8,800.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),
  SmsSample(
    id: 'im_to_mpesa_1',
    sender: 'I&M Bank',
    body:
        'I&M Bank: You have transferred KES 750.00 to your M-PESA on 13/08/26 at 16:40. Ref IM2201. Available Bal KES 6,050.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_mpesa',
  ),

  // --- Normal expenses (must NOT be internal transfers) ---
  SmsSample(
    id: 'mpesa_send_person',
    sender: 'MPESA',
    body:
        'SIL2EHTLXS Confirmed. Ksh200.00 sent to mary wanjiku +254719177614 on 21/9/24 at 7:03 PM. New M-PESA balance is Ksh0.00. Transaction cost, Ksh7.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'mpesa_receive_person',
    sender: 'MPESA',
    body:
        'SIM3GAHPR3 Confirmed.You have received Ksh100.00 from Pascaline Arusei 0728896722 on 22/9/24 at 10:09 AM New M-PESA balance is Ksh100.00.',
    expectedNature: 'credit',
    expectedKind: 'income',
  ),
  SmsSample(
    id: 'equity_pay_person',
    sender: 'Equity Bank',
    body:
        'Dear Customer, KES 1,500.00 has been debited from your account. Paid to JOHN DOE on 16/08/26. Ref EQ771. New balance is KES 10,000.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'equity_transfer_of_to_person',
    sender: 'Equity Bank',
    body:
        'Dear Customer, Transfer of KES 148,000.00 to JANE Wanjiku was successful on 24/08/26 at 10:15. Ref EQ148K. New balance is KES 12,000.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
    notes: 'Common Equity wording that used to fall through as income',
  ),
  SmsSample(
    id: 'equity_send_to_phone_mpesa',
    sender: 'Equity Bank',
    body:
        'Dear Customer, you have transferred KES 148,000.00 to 254712345678 JANE WANJIKU on 24/08/26. Ref EQMOB1. New balance is KES 5,000.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
    notes: 'Bank → someone else M-Pesa (phone present) = expense, not own wallet',
  ),
  SmsSample(
    id: 'equity_pesalink',
    sender: 'Equity Bank',
    body:
        'Dear Customer, Pesalink of KES 20,000.00 to the account of PETER OTIENO was successful. Ref PL991. New balance is KES 8,000.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'coop_send_to_person',
    sender: 'CoopBank',
    body:
        'Co-op Bank: Transfer of KES 5,000.00 to MARY NJERI was successful on 20/08/26. REF NO: CB9001. Avail Bal KES 1,200.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'ncba_send_to_person',
    sender: 'NCBA_BANK',
    body:
        'NCBA: You have sent KES 9,500.00 to JAMES KAMAU on 19/08/26. Ref NCB771. Available Balance KES 2,100.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'stanbic_send_to_person',
    sender: 'Stanbic',
    body:
        'Stanbic: KES 3,200.00 sent to ANN WAMBUI for payment on 18/08/26. Ref ST440. New balance KES 700.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'stanchart_send_to_person',
    sender: 'StanChart',
    body:
        'Standard Chartered: Transfer of KES 4,000.00 to the account of DAVID MWANGI was successful on 2026-08-17. Ref SC882.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'im_send_to_person',
    sender: 'I&M Bank',
    body:
        'I&M Bank: You have transferred KES 6,000.00 to GRACE ACHIENG on 16/08/26 at 09:05. Ref IM889. Available Bal KES 3,400.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'equity_salary',
    sender: 'Equity Bank',
    body:
        'Dear Customer, your account has been credited with KES 50,000.00 from ACME LTD on 01/08/26. Ref EQSAL1. New balance is KES 55,000.00.',
    expectedNature: 'credit',
    expectedKind: 'income',
  ),

  SmsSample(
    id: 'im_to_ncba_debit',
    sender: 'I&M Bank',
    body:
        'I&M Bank: You have transferred KES 15,000.00 to NCBA Bank via Pesalink on 25/08/26 at 10:15. Ref IMNCBA1. Available Bal KES 4,200.00.',
    expectedNature: 'debit',
    expectedKind: 'bank_to_bank',
    notes: 'Own-wallet I&M → NCBA debit leg',
  ),
  SmsSample(
    id: 'ncba_from_im_credit',
    sender: 'NCBA_BANK',
    body:
        'NCBA: Your account has been credited with KES 15,000.00 from I&M Bank on 25/08/26. Ref NCBIM1. Available Balance KES 22,500.00.',
    expectedNature: 'credit',
    expectedKind: 'bank_to_bank',
    notes: 'Own-wallet I&M → NCBA credit leg',
  ),

  // --- USD / dollar account (same debit/credit rules, currency=USD) ---
  SmsSample(
    id: 'equity_usd_credit',
    sender: 'Equity Bank',
    body:
        'Dear Customer, your USD account has been credited with USD 1,250.00 from ACME EXPORTS on 20/08/26. Ref EQUSD1. New balance is USD 3,400.00.',
    expectedNature: 'credit',
    expectedKind: 'income',
    notes: 'Dollar account income',
  ),
  SmsSample(
    id: 'equity_usd_send_person',
    sender: 'Equity Bank',
    body:
        'Dear Customer, Transfer of USD 500.00 to JANE WANJIKU was successful on 24/08/26. Ref EQUSD2. New balance is USD 2,900.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
    notes: 'Dollar account send to someone = expense',
  ),
  SmsSample(
    id: 'stanbic_usd_debit',
    sender: 'Stanbic',
    body:
        'Stanbic: USD 200.00 has been debited from your account. Paid to SUPPLIER LTD on 18/08/26. Ref STUSD1. New balance USD 1,100.00.',
    expectedNature: 'debit',
    expectedKind: 'expense',
  ),
  SmsSample(
    id: 'ncba_usd_credit',
    sender: 'NCBA_BANK',
    body:
        'NCBA: Your dollar account has been credited with USD 80.00 on 19/08/26. Ref NCBUSD1. Available Balance USD 920.00.',
    expectedNature: 'credit',
    expectedKind: 'income',
  ),
];
