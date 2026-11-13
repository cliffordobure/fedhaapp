import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fedha/data/local/transaction_merge.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/planning_sync.dart';
import 'package:fedha/data/sync/wallet_id_remap.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final _log = Logger('SyncEngine');

/// Pushes pending local transactions to the cloud and pulls remote updates
/// when connectivity is available. UI always reads from [LocalDataCache].
class SyncEngine {
  SyncEngine({
    LocalDataCache? cache,
    TransactionsService? transactionsService,
    WalletService? walletService,
    Connectivity? connectivity,
    PlanningSync? planningSync,
  })  : _cache = cache ?? service<LocalDataCache>(),
        _txService = transactionsService ?? service<TransactionsService>(),
        _walletService = walletService ?? service<WalletService>(),
        _connectivity = connectivity ?? Connectivity(),
        _planning = planningSync ?? PlanningSync();

  final LocalDataCache _cache;
  final TransactionsService _txService;
  final WalletService _walletService;
  final Connectivity _connectivity;
  final PlanningSync _planning;

  StreamSubscription? _connSub;
  bool _syncing = false;
  Completer<void>? _activeSync;
  bool _forcePullQueued = false;
  bool _lastSyncOk = true;
  String? _lastPushError;
  DateTime? _lastPullAt;

  /// Keep pulls short so Profile "Sync now" cannot spin for minutes.
  static const int _maxPullPages = 5;

  /// Hard ceiling for any sync cycle (push + pull).
  static const Duration syncTimeout = Duration(seconds: 45);

  /// Last cloud push failure message (for Profile sync UI).
  String? get lastPushError => _lastPushError;

  void start() {
    _connSub?.cancel();
    _connSub = _connectivity.onConnectivityChanged.listen((results) {
      if (_hasNetwork(results)) {
        unawaited(syncNow());
      }
    });
    unawaited(syncNow());
  }

  void stop() {
    _connSub?.cancel();
    _connSub = null;
  }

  /// Push pending local transactions only — never pull.
  /// Used after creating a tx so a soft pull cannot hide the optimistic row.
  Future<bool> pushPendingOnly() async {
    if (_syncing) {
      final inFlight = _activeSync;
      if (inFlight != null) await inFlight.future;
      return _lastSyncOk;
    }

    _syncing = true;
    final completer = Completer<void>();
    _activeSync = completer;
    _lastSyncOk = true;
    try {
      final results = await _connectivity.checkConnectivity();
      if (!_hasNetwork(results)) {
        _log.info('Offline — skipping push-only sync');
        return false;
      }
      await _pushPending().timeout(syncTimeout);
      await _cache.markCloudSyncedNow();
    } on TimeoutException {
      _lastSyncOk = false;
      _log.warning('Push-only sync timed out');
    } catch (e, st) {
      _lastSyncOk = false;
      _log.warning('Push-only sync failed: $e\n$st');
    } finally {
      _syncing = false;
      if (!completer.isCompleted) completer.complete();
      if (identical(_activeSync, completer)) {
        _activeSync = null;
      }
    }
    return _lastSyncOk;
  }

  /// Single-flight sync. Concurrent callers await the same run instead of
  /// stacking recursive force-pulls (which made the UI spin forever).
  ///
  /// Returns `false` on timeout / failure so the UI can stop its spinner.
  Future<bool> syncNow({bool forcePull = false}) async {
    if (forcePull) _forcePullQueued = true;

    if (_syncing) {
      final inFlight = _activeSync;
      if (inFlight != null) {
        await inFlight.future;
      }
      // A concurrent force-pull must still run after the in-flight cycle.
      if (_forcePullQueued && !_syncing) {
        return syncNow(forcePull: true);
      }
      return _lastSyncOk;
    }

    _syncing = true;
    final completer = Completer<void>();
    _activeSync = completer;
    _lastSyncOk = true;
    try {
      await _runSyncCycles().timeout(syncTimeout);
    } on TimeoutException {
      _lastSyncOk = false;
      _log.warning('Sync timed out after ${syncTimeout.inSeconds}s');
    } catch (e, st) {
      _lastSyncOk = false;
      _log.warning('Sync failed: $e\n$st');
    } finally {
      _syncing = false;
      if (!completer.isCompleted) completer.complete();
      if (identical(_activeSync, completer)) {
        _activeSync = null;
      }
    }
    return _lastSyncOk;
  }

  Future<void> _runSyncCycles() async {
    var cycles = 0;
    do {
      final shouldForce = _forcePullQueued;
      _forcePullQueued = false;

      final results = await _connectivity.checkConnectivity();
      if (!_hasNetwork(results)) {
        _log.info('Offline — skipping cloud sync');
        return;
      }

      // Push local-first planning creates before any pull that would
      // overwrite optimistic SQLite rows (budgets/goals/etc.).
      final planningBefore = await _cache.loadPlanningOutbox();
      if (planningBefore.isNotEmpty) {
        final planningOk = await _planning.pushPending();
        if (!planningOk) _lastSyncOk = false;
      }

      final shouldPull = shouldForce ||
          _lastPullAt == null ||
          DateTime.now().difference(_lastPullAt!) > const Duration(minutes: 2);
      if (shouldPull) {
        await _pullRemote();
        await _planning.pullAll();
        _lastPullAt = DateTime.now();
      }
      await _pushPending();

      final planningQueued = await _cache.loadPlanningOutbox();
      if (planningQueued.isNotEmpty) {
        final planningOk = await _planning.pushPending();
        if (!planningOk) _lastSyncOk = false;
        await _planning.pullAll();
      }

      await _cache.markCloudSyncedNow();
      cycles += 1;
    } while (_forcePullQueued && cycles < 2);
  }

  Future<List<Wallet>> _refreshLiveWallets() async {
    final result = await _walletService.fetchWallets();
    final live = result.when(
      onSuccess: (data) => data,
      onError: (error) {
        _log.warning('Wallet refresh failed before push: ${error.error}');
        return <Wallet>[];
      },
    );
    if (live.isNotEmpty) {
      await _cache.saveWallets(live);
      _log.info(
        'Live wallets for push: '
        '${live.map((w) => 'row=${w.id}/bank=${w.bankId}:${w.shortname}').join(', ')}',
      );
      return live;
    }
    return await _cache.loadWallets() ?? const [];
  }

  /// The outbox is read 100 rows at a time; keep pushing until it drains
  /// (e.g. a reset re-import of hundreds of SMS) or a batch makes no progress.
  Future<void> _pushPending() async {
    const maxBatches = 20;
    for (var i = 0; i < maxBatches; i++) {
      final pushed = await _pushPendingBatch();
      if (pushed == 0) return;
    }
  }

  Future<int> _pushPendingBatch() async {
    final rawPending = await _cache.loadPendingUploadPayloads();
    if (rawPending.isEmpty) return 0;

    final liveWallets = await _refreshLiveWallets();
    if (liveWallets.isEmpty) {
      _log.warning('No live wallets — cannot remap / push pending txs');
      _lastPushError =
          'No wallets found. Add M-Pesa or a bank wallet, then sync again.';
      _lastSyncOk = false;
      return 0;
    }

    // Rewrite outbox to user_wallets.id, then POST with user_wallet_id + wallet_id.
    final prepared = await _cache.preparePendingUploads(liveWallets);
    final pending = ensureUserWalletIds(prepared, liveWallets);

    final validUserWalletIds = liveWallets.map((w) => w.id).toSet();
    final uploadable = <TransactionData>[];
    final blocked = <TransactionData>[];
    for (final tx in pending) {
      if (validUserWalletIds.contains(tx.wallet)) {
        uploadable.add(tx);
      } else {
        blocked.add(tx);
      }
    }

    if (blocked.isNotEmpty) {
      _log.severe(
        'Blocked ${blocked.length} upload(s) — could not map to user_wallet_id: '
        '${blocked.map((t) => '${t.code}->${t.wallet}').join(', ')}. '
        'Live wallets: ${liveWallets.map((w) => '${w.shortname}:row=${w.id}/bank=${w.bankId}').join(', ')}',
      );
      _lastPushError =
          'Wallet mismatch: add/reconnect the wallet for these SMS, then sync again.';
      _lastSyncOk = false;
    }

    if (uploadable.isEmpty) return 0;

    _log.info(
      'Pushing ${uploadable.length} pending transactions '
      '(user_wallet_id: ${uploadable.map((t) => t.wallet).toSet().join(', ')})',
    );
    var pushed = 0;
    final result = await _txService.saveMultipleTransactions(uploadable);
    await result.when(
      onError: (error) async {
        _lastSyncOk = false;
        _lastPushError = error.error;
        _log.severe('Push failed: ${error.error}');
      },
      onSuccess: (_) async {
        final codes = uploadable.map((p) => p.code).toList();
        await _cache.markUploaded(codes);
        _lastPushError = blocked.isEmpty ? null : _lastPushError;
        _log.info('Pushed ${codes.length} transactions');
        pushed = codes.length;
      },
    );
    return pushed;
  }

  Future<void> _pullRemote() async {
    final liveWallets = await _refreshLiveWallets();

    final remote = <Transaction>[];
    String? nextPageUrl;
    var page = 1;
    String? previousNextUrl;

    while (page <= _maxPullPages) {
      final result = await _txService.fetchTransactions(page: page);
      var stop = false;
      await result.when(
        onError: (error) async {
          _log.warning('Pull failed (page $page): ${error.error}');
          stop = true;
        },
        onSuccess: (response) async {
          remote.addAll(response.data);
          nextPageUrl = response.nextPageUrl;
          if (response.nextPageUrl == null ||
              response.data.isEmpty ||
              response.nextPageUrl == previousNextUrl) {
            stop = true;
          }
          previousNextUrl = response.nextPageUrl;
        },
      );
      if (stop) break;
      page += 1;
    }

    if (remote.isEmpty && page == 1) {
      // Still heal any legacy bank-id rows already in SQLite.
      if (liveWallets.isNotEmpty) {
        await _cache.normalizeLocalWalletIds(liveWallets);
      }
      return;
    }

    final normalizedRemote =
        normalizeTransactionWalletIds(remote, liveWallets);

    final local = await _cache.loadTransactions();
    final localTxs = normalizeTransactionWalletIds(
      local?.transactions ?? const <Transaction>[],
      liveWallets,
    );
    final merged = mergeTransactionsDeduped(
      normalizedRemote,
      secondary: localTxs,
      preferPrimary: true,
    );
    // fromServer:true preserves pending/failed local rows that are not on
    // the server yet (instant SMS) instead of marking them synced.
    await _cache.saveTransactions(
      merged,
      total: merged.fold<double>(0, (s, t) => s + t.amount),
      nextPageUrl: nextPageUrl,
      fromServer: true,
      notify: true,
    );
    debugPrint(
      'SyncEngine pulled ${remote.length} remote txs ($page page(s)); '
      'normalized wallet ids against ${liveWallets.length} wallets',
    );
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }
}
