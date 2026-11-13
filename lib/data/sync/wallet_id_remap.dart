import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';

/// Resolves a wallet reference to the authenticated user's wallet row.
///
/// [requestedId] may be either:
/// - [Wallet.id] (user_wallets.id) — preferred
/// - [Wallet.bankId] (banks/wallets catalog id) — legacy SMS/outbox
Wallet? resolveUserWallet({
  required int requestedId,
  required List<Wallet> liveWallets,
  String? hintName,
}) {
  if (liveWallets.isEmpty) return null;

  for (final w in liveWallets) {
    if (w.id == requestedId) return w;
  }

  for (final w in liveWallets) {
    if (w.bankId == requestedId) return w;
  }

  final hint = (hintName ?? '').toLowerCase();
  final hintLooksMpesa =
      hint.contains('m-pesa') || hint.contains('mpesa');

  if (hintLooksMpesa) {
    for (final w in liveWallets) {
      final name = w.institutionName?.isNotEmpty == true
          ? w.institutionName!
          : w.name;
      if (walletNameMatchesSmsBank(name, 'M-Pesa') ||
          walletNameMatchesSmsBank(w.shortname, 'M-Pesa')) {
        return w;
      }
    }
  }

  if (hintName != null && hintName.trim().isNotEmpty) {
    for (final w in liveWallets) {
      final name = w.institutionName?.isNotEmpty == true
          ? w.institutionName!
          : w.name;
      if (walletNameMatchesSmsBank(name, hintName) ||
          walletNameMatchesSmsBank(w.shortname, hintName)) {
        return w;
      }
    }
  }

  for (final w in liveWallets) {
    final name = w.institutionName?.isNotEmpty == true
        ? w.institutionName!
        : w.name;
    if (walletNameMatchesSmsBank(name, 'M-Pesa') ||
        walletNameMatchesSmsBank(w.shortname, 'M-Pesa')) {
      return w;
    }
  }

  if (liveWallets.length == 1) return liveWallets.first;
  return null;
}

/// Prefer [Wallet.id] for local storage / outbox.
int? resolveUserWalletId({
  required int requestedId,
  required List<Wallet> liveWallets,
  String? hintName,
}) {
  return resolveUserWallet(
    requestedId: requestedId,
    liveWallets: liveWallets,
    hintName: hintName,
  )?.id;
}

List<TransactionData> remapPendingWalletIds(
  List<TransactionData> pending,
  List<Wallet> liveWallets,
) {
  if (pending.isEmpty || liveWallets.isEmpty) return pending;

  return pending.map((tx) {
    final remapped = resolveUserWalletId(
      requestedId: tx.wallet,
      liveWallets: liveWallets,
      hintName: tx.name,
    );
    if (remapped == null || remapped == tx.wallet) return tx;
    return tx.copyWith(wallet: remapped);
  }).toList();
}

List<TransactionData> ensureUserWalletIds(
  List<TransactionData> items,
  List<Wallet> liveWallets,
) {
  if (items.isEmpty || liveWallets.isEmpty) return items;
  return items.map((tx) {
    final id = resolveUserWalletId(
      requestedId: tx.wallet,
      liveWallets: liveWallets,
      hintName: tx.name,
    );
    if (id == null || id == tx.wallet) return tx;
    return tx.copyWith(wallet: id);
  }).toList();
}

/// After a cloud pull, rewrite [Transaction.walletId] to user_wallets.id.
///
/// Cloud rows may store:
/// - `user_wallet_id` (preferred — already mapped in [Transaction.fromJson])
/// - `wallet_id` as bank catalog id (legacy / dual-column backend)
/// - `wallet_id` as user wallet row id (older API)
///
/// Local UI filters/joins against [Wallet.id], so bank catalog ids must be
/// remapped or logos/stats/wallet detail look empty.
List<Transaction> normalizeTransactionWalletIds(
  List<Transaction> transactions,
  List<Wallet> liveWallets,
) {
  if (transactions.isEmpty || liveWallets.isEmpty) return transactions;

  final userIds = liveWallets.map((w) => w.id).toSet();
  return transactions.map((tx) {
    final wid = tx.walletId;
    if (wid == null) return tx;
    if (userIds.contains(wid)) return tx;

    final remapped = resolveUserWalletId(
      requestedId: wid,
      liveWallets: liveWallets,
      hintName: tx.narration,
    );
    if (remapped == null || remapped == wid) return tx;
    return tx.copyWith(walletId: remapped);
  }).toList();
}

/// Payload for POST transaction/create and multiple-create.
///
/// Backend expects:
/// - `user_wallet_id` → user_wallets.id
/// - `wallet_id` → banks/wallets catalog id (legacy + exists:wallets,id)
Map<String, dynamic> transactionDataToApiJson(
  TransactionData tx, {
  List<Wallet> liveWallets = const [],
}) {
  final resolved = liveWallets.isEmpty
      ? null
      : resolveUserWallet(
          requestedId: tx.wallet,
          liveWallets: liveWallets,
          hintName: tx.name,
        );

  final json = <String, dynamic>{
    'name': tx.name,
    'transaction_id': tx.code,
    'amount': tx.amount,
    'charges': tx.charges,
    'type': tx.type,
    if (tx.datetime != null) 'date': tx.datetime!.toIso8601String(),
    if (tx.categoryId != null) 'category_id': tx.categoryId,
    if (tx.subcategoryId != null) 'subcategory_id': tx.subcategoryId,
  };

  if (resolved != null) {
    json['user_wallet_id'] = resolved.id;
    json['wallet_id'] = resolved.bankId;
  } else {
    // Best-effort: treat stored value as user wallet row id.
    json['user_wallet_id'] = tx.wallet;
  }

  return json;
}
