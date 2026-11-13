## How Fedha classifies bank / M-Pesa SMS

| Situation | Example | Nature | Counts as |
|-----------|---------|--------|-----------|
| **Own wallet** bank → your M-Pesa | "transferred to your M-PESA" | debit on bank, credit on M-Pesa | **Transfer** (not income/expense) |
| **Own wallet** M-Pesa → your bank | "sent to EQUITY BANK" / Bank Deposit | debit on M-Pesa, credit on bank | **Transfer** |
| **Send to someone** (phone / name / Pesalink) | "Transfer of KES/USD … to JANE…" / `2547…` | **debit** | **Expense** |
| **Receive from someone** | "received from Pascaline…" | **credit** | **Income** |
| **Salary / deposit** | "account has been credited with…" | **credit** | **Income** |
| **Dollar (USD) account** | "USD 500.00" / "dollar account" | same debit/credit rules | Routed to the bank’s **USD** wallet |

## Pipeline

1. **Per-bank parsers** (`parser.dart`) extract amount / ref / nature from SMS.
2. **Own-wallet detection** (`sms_banks.dart`) tags bank→M-Pesa and M-Pesa→bank moves with a `Transfer:` narration. Third-party sends (phone numbers, Pesalink, "paid to NAME") stay expenses.
3. **Linker** (`internal_transfer_linker.dart`) pairs matching debit + credit legs **only when at least one side is already tagged as a transfer** (same amount, within 45 minutes) and stamps a shared `[xfer:…]` id.
4. **Income / expense** totals skip any narration that `narrationIsInternalTransfer` recognizes (home, analytics, wallet detail).

Both legs of an own-wallet move still appear on each wallet (bank went down, M-Pesa went up) — they just do not inflate income or spending.

## Growing coverage

- Add anonymized samples to `lib/utils/message_reading_service/sms_sample_catalog.dart`.
- Extend tests in `test/sms_transfer_test.dart`.
- Backend library (after migrate): `GET/POST /api/sms-samples` for labeled samples from admin/tools.

## Migrate backend

```bash
php artisan migrate
```

Creates `sms_message_samples` for storing labeled SMS from production.
