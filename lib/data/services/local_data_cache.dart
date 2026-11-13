import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fedha/data/local/fedha_database.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/local/transaction_merge.dart';
import 'package:fedha/data/models/ads/ads.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/categories/categories.dart' as cats;
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/graphs/chart_data.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/sync/wallet_id_remap.dart';
import 'package:path_provider/path_provider.dart';

/// Local-first store. UI should read from here; cloud sync is secondary.
class LocalDataCache {
  LocalDataCache({FedhaDatabase? db}) : _db = db ?? FedhaDatabase.instance;

  final FedhaDatabase _db;
  final _localTxUpdates = StreamController<List<Transaction>>.broadcast();
  bool _migratedLegacy = false;

  /// Live updates for UI (e.g. SMS parsed before server sync).
  Stream<List<Transaction>> get localTransactionUpdates =>
      _localTxUpdates.stream;

  Future<void> _ensureMigrated() async {
    if (_migratedLegacy) return;
    _migratedLegacy = true;
    try {
      final existing = await _db.loadAllTransactions();
      if (existing.isNotEmpty) return;

      final legacy = await _readLegacyJson('cache_transactions.json');
      if (legacy == null) return;
      final raw = legacy['data'];
      if (raw is! List) return;
      final txs = raw
          .whereType<Map>()
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      if (txs.isNotEmpty) {
        await _db.upsertTransactions(txs, syncStatus: 'synced');
      }

      final walletsLegacy = await _readLegacyJson('cache_wallets.json');
      final wRaw = walletsLegacy?['data'];
      if (wRaw is List) {
        final wallets = wRaw
            .whereType<Map>()
            .map((e) => Wallet.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (wallets.isNotEmpty) await _db.saveWallets(wallets);
      }

      final homeLegacy = await _readLegacyJson('cache_home_data.json');
      if (homeLegacy != null) {
        await _db.putKv('home_data', homeLegacy);
      }
    } catch (_) {
      // Migration must never break startup.
    }
  }

  Future<Map<String, dynamic>?> _readLegacyJson(String name) async {
    try {
      final root = await getApplicationDocumentsDirectory();
      final file = File('${root.path}/fedha_cache/$name');
      if (!await file.exists()) return null;
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  // --- Transactions ---

  Future<void> saveTransactions(
    List<Transaction> transactions, {
    double total = 0,
    String? nextPageUrl,
    bool fromServer = false,
    bool notify = false,
  }) async {
    await _ensureMigrated();
    final deleted = await loadDeletedTransactionCodes();
    final filtered = deleted.isEmpty
        ? transactions
        : transactions
            .where((t) => !deleted.contains(t.transactionId.trim()))
            .toList(growable: false);
    if (fromServer) {
      await _db.replaceAllTransactions(filtered);
      // Drop any tombstoned rows that replaceAll re-inserted from pending locals.
      if (deleted.isNotEmpty) {
        for (final code in deleted) {
          await _db.deleteTransactionByCode(code);
        }
      }
    } else {
      await _db.upsertTransactions(filtered, syncStatus: 'synced');
    }
    final computedTotal = total > 0
        ? total
        : filtered.fold<double>(0, (s, t) => s + t.amount);
    await _db.putKv('transactions_meta', {
      'total': computedTotal,
      'next_page_url': nextPageUrl,
      'saved_at': DateTime.now().toIso8601String(),
    });
    if (notify && filtered.isNotEmpty && !_localTxUpdates.isClosed) {
      _localTxUpdates.add(filtered);
    }
  }

  Future<({List<Transaction> transactions, double total, String? nextPageUrl})?>
      loadTransactions() async {
    await _ensureMigrated();
    final deleted = await loadDeletedTransactionCodes();
    final raw = await _db.loadAllTransactions();
    // Heal rows that were "deleted" in UI but never removed from SQLite.
    if (deleted.isNotEmpty) {
      for (final t in raw) {
        final code = t.transactionId.trim();
        if (code.isNotEmpty && deleted.contains(code)) {
          await _db.deleteTransactionByCode(code);
        }
      }
    }
    final cleaned = deleted.isEmpty
        ? raw
        : raw
            .where((t) => !deleted.contains(t.transactionId.trim()))
            .toList(growable: false);
    final transactions = mergeTransactionsDeduped(cleaned);
    // One-time cleanup if older merges left duplicate rows in SQLite.
    if (transactions.length < cleaned.length) {
      await _db.replaceAllTransactions(transactions);
    }
    final meta = await _db.getKv('transactions_meta');
    if (transactions.isEmpty && meta == null) return null;
    return (
      transactions: transactions,
      total: (meta?['total'] as num?)?.toDouble() ??
          transactions.fold<double>(0, (s, t) => s + t.amount),
      nextPageUrl: meta?['next_page_url'] as String?,
    );
  }

  /// Codes already present locally, plus user-deleted codes (so SMS won't revive them).
  Future<Set<String>> existingTransactionCodes(Iterable<String> codes) async {
    await _ensureMigrated();
    final found = await _db.existingTransactionCodes(codes);
    final deleted = await loadDeletedTransactionCodes();
    if (deleted.isEmpty) return found;
    for (final c in codes) {
      final code = c.trim();
      if (code.isNotEmpty && deleted.contains(code)) found.add(code);
    }
    return found;
  }

  /// Permanently remove a transaction locally and block SMS/cloud revive.
  Future<void> deleteTransactionLocally({
    int? serverId,
    String? transactionCode,
  }) async {
    await _ensureMigrated();
    final code = transactionCode?.trim() ?? '';
    if (code.isNotEmpty) {
      await rememberDeletedTransactionCode(code);
      await _db.deleteTransactionByCode(code);
    }
    if (serverId != null && serverId > 0) {
      await _db.deleteTransactionByServerId(serverId);
    }
    final remaining = await _db.loadAllTransactions();
    await _db.putKv('transactions_meta', {
      'total': remaining.fold<double>(0, (s, t) => s + t.amount),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Set<String>> loadDeletedTransactionCodes() async {
    await _ensureMigrated();
    final json = await _db.getKv('deleted_transaction_codes');
    final raw = json?['codes'];
    if (raw is! List) return <String>{};
    return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toSet();
  }

  Future<void> rememberDeletedTransactionCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    final codes = await loadDeletedTransactionCodes();
    if (!codes.add(trimmed)) return;
    await _db.putKv('deleted_transaction_codes', {
      'codes': codes.toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  /// Upsert SMS/manual rows as pending (or synced if [markSynced]).
  Future<List<Transaction>> mergeTransactions(
    List<Transaction> incoming, {
    double? total,
    bool notify = true,
    bool pendingSync = false,
    List<TransactionData>? uploadPayloads,
  }) async {
    await _ensureMigrated();
    final deleted = await loadDeletedTransactionCodes();
    final filteredIncoming = deleted.isEmpty
        ? incoming
        : incoming
            .where((t) => !deleted.contains(t.transactionId.trim()))
            .toList(growable: false);
    if (filteredIncoming.isEmpty) {
      return mergeTransactionsDeduped(await _db.loadAllTransactions());
    }

    final payloadByCode = <String, String?>{};
    if (uploadPayloads != null) {
      for (final p in uploadPayloads) {
        if (deleted.contains(p.code.trim())) continue;
        payloadByCode[p.code] = jsonEncode(p.toJson());
      }
    }

    await _db.upsertTransactions(
      filteredIncoming,
      syncStatus: pendingSync ? 'pending' : 'synced',
      payloadByCode: payloadByCode,
    );

    if (pendingSync && uploadPayloads != null) {
      for (final p in uploadPayloads) {
        if (deleted.contains(p.code.trim())) continue;
        await _db.enqueueOutbox(
          entityType: 'transaction',
          entityKey: p.code,
          payload: p.toJson(),
        );
      }
    }

    final all = mergeTransactionsDeduped(await _db.loadAllTransactions());
    final computedTotal =
        total ?? all.fold<double>(0, (sum, t) => sum + t.amount);
    await _db.putKv('transactions_meta', {
      'total': computedTotal,
      'saved_at': DateTime.now().toIso8601String(),
    });

    if (notify && !_localTxUpdates.isClosed) {
      _localTxUpdates.add(filteredIncoming);
    }
    return all;
  }

  Future<List<TransactionData>> loadPendingUploadPayloads() async {
    await _ensureMigrated();
    final outbox = await _db.loadOutbox(limit: 100);
    final payloads = <TransactionData>[];
    for (final row in outbox) {
      if (row['entity_type'] != 'transaction') continue;
      try {
        final map = jsonDecode(row['payload_json'] as String);
        if (map is Map) {
          payloads.add(
            TransactionData.fromJson(Map<String, dynamic>.from(map)),
          );
        }
      } catch (_) {}
    }
    // Fallback: pending rows with payload_json on transactions table.
    if (payloads.isEmpty) {
      final db = await _db.database;
      final rows = await db.query(
        'transactions',
        where: "sync_status IN ('pending','failed') AND payload_json IS NOT NULL",
      );
      for (final row in rows) {
        try {
          final map = jsonDecode(row['payload_json'] as String);
          if (map is Map) {
            payloads.add(
              TransactionData.fromJson(Map<String, dynamic>.from(map)),
            );
          }
        } catch (_) {}
      }
    }
    return payloads;
  }

  /// Remap stale wallet ids in the outbox to wallets the server currently has.
  Future<List<TransactionData>> preparePendingUploads(
    List<Wallet> liveWallets,
  ) async {
    await _ensureMigrated();
    final pending = await loadPendingUploadPayloads();
    if (pending.isEmpty) return const [];

    final remapped = remapPendingWalletIds(pending, liveWallets);
    for (final tx in remapped) {
      await _db.enqueueOutbox(
        entityType: 'transaction',
        entityKey: tx.code,
        payload: tx.toJson(),
      );
      // Keep local transaction row wallet_id in sync when possible.
      final db = await _db.database;
      await db.update(
        'transactions',
        {'wallet_id': tx.wallet},
        where: 'transaction_code = ?',
        whereArgs: [tx.code],
      );
    }
    return remapped;
  }

  Future<void> markUploaded(List<String> codes) async {
    await _db.markTransactionsSynced(codes);
    final outbox = await _db.loadOutbox(limit: 200);
    for (final row in outbox) {
      final key = row['entity_key'] as String?;
      if (key != null && codes.contains(key)) {
        await _db.removeOutbox(row['id'] as int);
      }
    }
  }

  /// Snapshot used by Profile → Data sync.
  Future<CloudSyncStatus> loadCloudSyncStatus() async {
    await _ensureMigrated();
    final backlog = await _db.countSyncBacklog();
    final planningOutbox = await loadPlanningOutbox();
    final meta = await _db.getKv('cloud_sync_meta');
    DateTime? lastSyncedAt;
    final raw = meta?['last_synced_at'] as String?;
    if (raw != null && raw.isNotEmpty) {
      lastSyncedAt = DateTime.tryParse(raw);
    }
    // Prefer the larger of row pending vs outbox (they often overlap),
    // then add planning (bills/planned/budget/goals) waiting uploads.
    final txWaiting = backlog.pending > backlog.outbox
        ? backlog.pending
        : backlog.outbox;
    return CloudSyncStatus(
      pendingUploadCount: txWaiting + planningOutbox.length,
      failedCount: backlog.failed,
      lastSyncedAt: lastSyncedAt,
    );
  }

  Future<void> markCloudSyncedNow() async {
    await _ensureMigrated();
    await _db.putKv('cloud_sync_meta', {
      'last_synced_at': DateTime.now().toIso8601String(),
    });
  }

  // --- Wallets ---

  Future<void> saveWallets(List<Wallet> wallets) async {
    await _ensureMigrated();
    await _db.saveWallets(wallets);
  }

  Future<List<Wallet>?> loadWallets() async {
    await _ensureMigrated();
    final wallets = await _db.loadWallets();
    if (wallets.isEmpty) return null;
    return wallets;
  }

  /// Rewrite SQLite transaction.wallet_id from bank catalog ids → user row ids.
  /// Safe to call repeatedly; preserves sync_status / outbox.
  Future<int> normalizeLocalWalletIds(List<Wallet> liveWallets) async {
    await _ensureMigrated();
    if (liveWallets.isEmpty) return 0;
    final raw = await _db.loadAllTransactions();
    if (raw.isEmpty) return 0;

    final userIds = liveWallets.map((w) => w.id).toSet();
    final db = await _db.database;
    var changed = 0;
    for (final tx in raw) {
      final wid = tx.walletId;
      if (wid == null || userIds.contains(wid)) continue;
      final remapped = resolveUserWalletId(
        requestedId: wid,
        liveWallets: liveWallets,
        hintName: tx.narration,
      );
      if (remapped == null || remapped == wid) continue;
      await db.update(
        'transactions',
        {'wallet_id': remapped},
        where: 'transaction_code = ?',
        whereArgs: [tx.transactionId],
      );
      changed++;
    }
    if (changed > 0 && !_localTxUpdates.isClosed) {
      final updated = await _db.loadAllTransactions();
      _localTxUpdates.add(updated);
    }
    return changed;
  }

  // --- Home card / donut data ---

  Future<void> saveHomeData(Map<String, dynamic> data,
      {double totals = 0}) async {
    await _ensureMigrated();
    await _db.putKv('home_data', {
      'data': data,
      'totals': totals,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<({Map<String, dynamic> data, double totals})?> loadHomeData() async {
    await _ensureMigrated();
    final json = await _db.getKv('home_data');
    if (json == null) return null;
    final data = json['data'];
    if (data is! Map) return null;
    return (
      data: Map<String, dynamic>.from(data),
      totals: (json['totals'] as num?)?.toDouble() ?? 0,
    );
  }

  // --- Weekly graphs ---

  Future<void> saveWeeklyGraphs(List<ChartData> data, String dateRange) async {
    await _ensureMigrated();
    await _db.putKv('graphs_weekly', {
      'date_range': dateRange,
      'data': data.map((e) => e.toJson()).toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<({List<ChartData> data, String dateRange})?> loadWeeklyGraphs() async {
    await _ensureMigrated();
    final json = await _db.getKv('graphs_weekly');
    if (json == null) return null;
    final raw = json['data'];
    if (raw is! List) return null;
    return (
      data: raw
          .whereType<Map>()
          .map((e) => ChartData.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      dateRange: json['date_range'] as String? ?? '',
    );
  }

  // --- Marketing ads / slides ---

  Future<void> saveAds(List<Ads> ads) async {
    await _ensureMigrated();
    await _db.putKv('marketing_ads', {
      'data': ads.map((e) => e.toJson()).toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Ads>?> loadAds() async {
    await _ensureMigrated();
    final json = await _db.getKv('marketing_ads');
    if (json == null) return null;
    final raw = json['data'];
    if (raw is! List || raw.isEmpty) return null;
    return raw
        .whereType<Map>()
        .map((e) => Ads.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // --- Local allocation links (bill / planned / budget / goal) ---

  Future<void> saveTransactionLink(TransactionAllocationLink link) async {
    await _ensureMigrated();
    await _db.upsertTransactionLink(link);
  }

  Future<TransactionAllocationLink?> loadTransactionLink(String code) async {
    await _ensureMigrated();
    return _db.getTransactionLink(code);
  }

  Future<Map<String, TransactionAllocationLink>> loadTransactionLinks() async {
    await _ensureMigrated();
    return _db.loadAllTransactionLinks();
  }

  /// Local links for a bill / planned payment / budget / goal.
  Future<List<TransactionAllocationLink>> loadLinksForEntity({
    required AllocationEntityType entityType,
    required int entityId,
  }) async {
    final all = await loadTransactionLinks();
    return all.values
        .where((l) => l.entityType == entityType && l.entityId == entityId)
        .toList();
  }

  Future<void> removeTransactionLink(String code) async {
    await _ensureMigrated();
    await _db.deleteTransactionLink(code);
  }

  Future<Set<String>> loadDismissedAllocationCodes() async {
    await _ensureMigrated();
    final json = await _db.getKv('dismissed_allocation_matches');
    final raw = json?['codes'];
    if (raw is! List) return <String>{};
    return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toSet();
  }

  Future<void> dismissAllocationMatch(String code) async {
    final codes = await loadDismissedAllocationCodes();
    codes.add(code);
    await _db.putKv('dismissed_allocation_matches', {
      'codes': codes.toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  /// Build optimistic rows from SMS / manual upload payloads.
  static List<Transaction> fromTransactionData(List<TransactionData> items) {
    final now = DateTime.now();
    return items.map((item) {
      final raw = item.type.toLowerCase();
      final isCredit = raw.contains('credit') ||
          raw.contains('received') ||
          raw.contains('income') ||
          raw.contains('deposit') ||
          raw.contains('refund');
      return Transaction(
        id: -item.code.hashCode.abs(),
        transactionId: item.code,
        type: isCredit ? TransactionType.credit : TransactionType.debit,
        amount: item.amount,
        narration: item.name,
        charges: item.charges,
        date: item.datetime ?? now,
        walletId: item.wallet,
        currency: item.currency ?? 'KES',
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
  }

  // --- Planning entities (bills / planned / budgets / goals) ---

  static const planningEntityTypes = {
    'bill',
    'planned_payment',
    'budget',
    'goal',
  };

  Future<void> savePlannedPayments(List<PlannedPayment> items) async {
    await _ensureMigrated();
    await _db.putKv('planned_payments', {
      'data': items.map((e) => e.toJson()).toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<PlannedPayment>?> loadPlannedPayments() async {
    await _ensureMigrated();
    final json = await _db.getKv('planned_payments');
    final raw = json?['data'];
    if (raw is! List) return null;
    return raw
        .whereType<Map>()
        .map((e) => PlannedPayment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveGoals(List<Goals> items) async {
    await _ensureMigrated();
    await _db.putKv('goals', {
      'data': items.map((e) => e.toJson()).toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Goals>?> loadGoals() async {
    await _ensureMigrated();
    final json = await _db.getKv('goals');
    final raw = json?['data'];
    if (raw is! List) return null;
    return raw
        .whereType<Map>()
        .map((e) => Goals.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveUserBudgets(UserBudgets data) async {
    await _ensureMigrated();
    await _db.putKv('user_budgets', {
      'data': data.toJson(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> saveExpenseCategories(cats.CategoryResponse data) async {
    await _ensureMigrated();
    await _db.putKv('expense_categories', {
      'data': data.toJson(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<cats.CategoryResponse?> loadExpenseCategories() async {
    await _ensureMigrated();
    final json = await _db.getKv('expense_categories');
    final raw = json?['data'];
    if (raw is! Map) return null;
    try {
      return cats.CategoryResponse.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveIncomeCategories(List<cats.Category> data) async {
    await _ensureMigrated();
    await _db.putKv('income_categories', {
      'data': data.map((e) => e.toJson()).toList(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<cats.Category>?> loadIncomeCategories() async {
    await _ensureMigrated();
    final json = await _db.getKv('income_categories');
    final raw = json?['data'];
    if (raw is! List) return null;
    try {
      return raw
          .whereType<Map>()
          .map((e) => cats.Category.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<UserBudgets?> loadUserBudgets() async {
    await _ensureMigrated();
    final json = await _db.getKv('user_budgets');
    final raw = json?['data'];
    if (raw is! Map) return null;
    try {
      return UserBudgets.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  /// Keep optimistic local budgets that are still queued for create when a
  /// server pull would otherwise wipe them (failed/pending sync).
  /// Applies goal payments that haven't reached the server yet, so a pull
  /// never reverts `amount_saved` to the older server value.
  Future<List<Goals>> mergeServerGoalsWithPending(List<Goals> server) async {
    final rows = await loadPlanningOutbox();
    final pending = <int, double>{};
    for (final row in rows) {
      if ('${row['entity_type']}' != 'goal') continue;
      final payloadRaw = row['payload_json'];
      final payload = payloadRaw is String
          ? (payloadRaw.isEmpty ? null : jsonDecode(payloadRaw))
          : payloadRaw;
      if (payload is! Map || '${payload['op']}' != 'recharge') continue;
      final id = int.tryParse('${payload['server_id']}');
      final body = payload['body'];
      final total = body is Map
          ? double.tryParse('${body['new_amount_saved']}')
          : null;
      if (id != null && total != null) pending[id] = total;
    }
    if (pending.isEmpty) return server;
    return server
        .map((g) => pending.containsKey(g.id)
            ? g.copyWith(amountSaved: pending[g.id])
            : g)
        .toList();
  }

  Future<UserBudgets> mergeServerBudgetsWithPending(UserBudgets server) async {
    final rows = await loadPlanningOutbox();
    final pendingCreates = <UserBudget>[];
    final pendingAmounts = <int, String>{};

    for (final row in rows) {
      if ('${row['entity_type']}' != 'budget') continue;
      final payloadRaw = row['payload_json'];
      final payload = payloadRaw is String
          ? (payloadRaw.isEmpty ? null : jsonDecode(payloadRaw))
          : payloadRaw;
      if (payload is! Map) continue;
      final map = Map<String, dynamic>.from(payload);
      if ('${map['op']}' == 'contribute') {
        final id = int.tryParse('${map['server_id']}');
        final body = map['body'];
        final total = body is Map ? body['new_amount'] : null;
        if (id != null && total != null) pendingAmounts[id] = '$total';
        continue;
      }
      if ('${map['op']}' != 'create') continue;
      final body = map['body'] is Map
          ? Map<String, dynamic>.from(map['body'] as Map)
          : <String, dynamic>{};
      final entityKey = '${row['entity_key'] ?? map['entity_key'] ?? ''}';
      final tempId = int.tryParse(
            entityKey.replaceFirst('budget_create_', ''),
          ) ??
          nextTempLocalId();

      pendingCreates.add(
        UserBudget(
          id: tempId,
          userId: 0,
          amount: '${body['amount'] ?? '0'}',
          budgetLimitAmount: body['budget_limit_amount']?.toString(),
          resetPeriod: body['reset_period']?.toString(),
          category: body['category_name']?.toString(),
          subcategoryName: body['subcategory_name']?.toString(),
          associatedWallet: body['wallet_name']?.toString(),
          budgetName: body['budget_name']?.toString() ??
              body['category_name']?.toString() ??
              'Budget',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Unsynced payments win over the (older) server total.
    if (pendingAmounts.isNotEmpty) {
      server = UserBudgets(
        message: server.message,
        budgets: server.budgets
            .map((b) => pendingAmounts.containsKey(b.id)
                ? b.copyWith(amount: pendingAmounts[b.id]!)
                : b)
            .toList(),
      );
    }

    if (pendingCreates.isEmpty) return server;

    final serverIds = server.budgets.map((b) => b.id).whereType<int>().toSet();
    final extras = pendingCreates
        .where((b) => b.id == null || !serverIds.contains(b.id))
        .toList();
    if (extras.isEmpty) return server;

    return UserBudgets(
      message: server.message,
      budgets: [...extras, ...server.budgets],
    );
  }

  Future<void> saveUserBills(UserBill data) async {
    await _ensureMigrated();
    await _db.putKv('user_bills', {
      'data': data.toJson(),
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<UserBill?> loadUserBills() async {
    await _ensureMigrated();
    final json = await _db.getKv('user_bills');
    final raw = json?['data'];
    if (raw is! Map) return null;
    try {
      return UserBill.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  /// Queue a planning CRUD op for SyncEngine (create/update/delete/status).
  Future<void> enqueuePlanningOp({
    required String entityType,
    required String op,
    required String entityKey,
    int? serverId,
    Map<String, dynamic>? body,
  }) async {
    assert(planningEntityTypes.contains(entityType));
    await _ensureMigrated();
    await _db.enqueueOutbox(
      entityType: entityType,
      entityKey: entityKey,
      payload: {
        'op': op,
        'entity_type': entityType,
        'server_id': serverId,
        'body': body ?? {},
        'queued_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> loadPlanningOutbox({int limit = 80}) async {
    await _ensureMigrated();
    final rows = await _db.loadOutbox(limit: limit);
    return rows
        .where((r) => planningEntityTypes.contains(r['entity_type']))
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
  }

  Future<void> removePlanningOp({
    required String entityType,
    required String entityKey,
  }) async {
    await _ensureMigrated();
    await _db.deleteOutboxByEntityKey(
        entityType: entityType, entityKey: entityKey);
  }

  Future<void> removeOutboxRow(int id) async {
    await _ensureMigrated();
    await _db.removeOutbox(id);
  }

  int nextTempLocalId() =>
      -DateTime.now().microsecondsSinceEpoch.remainder(1000000000);

  /// Clear SQLite when logging out or switching accounts.
  Future<void> clearAllUserData() async {
    await _ensureMigrated();
    await _db.clearAllUserData();
  }

  /// Remove every local transaction (and home/graph caches) without touching
  /// wallets, budgets, goals, or bills.
  Future<void> clearAllTransactions() async {
    await _ensureMigrated();
    await _db.clearAllTransactions();
    if (!_localTxUpdates.isClosed) {
      _localTxUpdates.add(const []);
    }
  }

  Future<int?> loadLocalOwnerUserId() async {
    await _ensureMigrated();
    final meta = await _db.getKv('local_owner');
    final id = meta?['user_id'];
    if (id is int) return id;
    if (id is num) return id.toInt();
    return int.tryParse('$id');
  }

  Future<void> saveLocalOwnerUserId(int userId) async {
    await _ensureMigrated();
    await _db.putKv('local_owner', {
      'user_id': userId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic> emptyHomeCard() => {
        'total_balance': 0.0,
        'incomes': 0.0,
        'expenses': 0.0,
      };
}

/// Mobile → cloud sync health for Profile UI.
class CloudSyncStatus {
  const CloudSyncStatus({
    required this.pendingUploadCount,
    required this.failedCount,
    this.lastSyncedAt,
  });

  final int pendingUploadCount;
  final int failedCount;
  final DateTime? lastSyncedAt;

  bool get isFullySynced =>
      pendingUploadCount <= 0 && failedCount <= 0;
}
