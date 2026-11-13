// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:fedha/utils/notifications_service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:another_telephony/telephony.dart'
    if (dart.library.html) 'dummy.dart';
import 'package:workmanager/workmanager.dart';

import 'package:fedha/constants/constants.dart';
import 'package:fedha/data/models/remote_message/transaction_messages.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/data/sync/wallet_id_remap.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/utils/message_reading_service/parser.dart';
import 'package:fedha/utils/message_reading_service/internal_transfer_linker.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:fedha/utils/utils.dart';

const String MESSAGE_READING_TASK = 'readMessages';
const Duration MESSAGE_READING_FREQUENCY = Duration(minutes: 15);
const Duration MESSAGE_READING_INITIAL_DELAY = Duration(minutes: 0);

/// Re-scan at most this far when recovering missed SMS (never before install).
/// Re-scan window on app open / recovery. Wider than a work day so today's
/// SMS is recovered after overnight or failed parse/upload attempts.
const Duration kSmsImportMaxWindow = Duration(hours: 48);

void initializeDependencies() {
  setUpService();
}

Future<void> initializeServices() async {
  try {
    await initTelephony(); // Ensure telephony is initialized
    initializeDependencies();
    await Workmanager().initialize(callbackDispatcher);
    await NotificationService.initialize();

    final appPrefs = service<AppPreferences>();
    // Tracking starts the day the app is first opened — not when SMS is granted.
    await ensureAppTrackingStartFromInstall();
    logger.info("auth data is : ${await appPrefs.getAuthData()}");
  } catch (e) {
    logger.severe('Failed to initialize services: $e');
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  initTelephony();
  Workmanager().executeTask((task, inputData) async {
    logger.info("Background task started: $task at ${DateTime.now()}");
    try {
      switch (task) {
        case MESSAGE_READING_TASK:
          logger.info("Starting readMessages");
          int newTimestamp = await readMessages(inputData);
          logger.info("readMessages completed, new timestamp: $newTimestamp");
          await _updateLastReadTimestamp(newTimestamp);
          logger.info("Timestamp updated");
          break;
        default:
          logger.info('Unknown task: $task');
          return Future.value(false);
      }
      logger.info("Task completed successfully at ${DateTime.now()}");
      return Future.value(true);
    } catch (e, stackTrace) {
      logger.info('Task failed: $task $e $stackTrace');
      return Future.value(false);
    }
  });
}

Telephony? telephony;
bool _smsListening = false;

Future<void> initTelephony() async {
  if (Platform.isAndroid) {
    telephony = Telephony.instance;
  } else {
    telephony = null;
  }
}

/// Handles SMS while the app is in the background / killed.
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  await initTelephony();
  await processIncomingSmsMessage(message);
}

/// Listen for new bank/M-Pesa SMS and show them in the app immediately
/// instead of waiting for the 15-minute WorkManager scan.
Future<void> startRealtimeSmsListening() async {
  if (!Platform.isAndroid || _smsListening) return;
  await initTelephony();
  if (telephony == null) return;

  try {
    telephony!.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        unawaited(processIncomingSmsMessage(message));
      },
      onBackgroundMessage: backgroundSmsHandler,
    );
    _smsListening = true;
    logger.info('Realtime SMS listening started');
  } catch (e) {
    logger.severe('Failed to start realtime SMS listening: $e');
  }
}

/// Process one incoming SMS right away (airtime, paybill, send money, etc.).
Future<void> processIncomingSmsMessage(SmsMessage message) async {
  try {
    final appPrefs = service<AppPreferences>();
    final connectedAt = await appPrefs.getInstallationDate() ?? 0;
    if (connectedAt == 0) {
      logger.info('Ignoring SMS — messaging not connected yet');
      return;
    }

    // Realtime path used to skip this; empty SUPPORTED_BANKS dropped every SMS.
    await ensureSmsBanksForUserWallets();

    // Realtime: accept anything since connect (not only last 12h).
    final filtered = await _filterMessages([message], connectedAt);
    if (filtered.isEmpty) {
      logger.info(
          'Incoming SMS ignored (unsupported/disabled sender): '
          '${message.address} → ${resolveSmsAddress(address: message.address, body: message.body)}');
      return;
    }

    final transactionsList = await _processMessages(filtered);
    if (transactionsList.transactions.isEmpty) {
      logger.info('Incoming SMS could not be parsed as a transaction');
      return;
    }

    await _handleNewTransactions(transactionsList, null);
    final stamp = message.date ?? DateTime.now().millisecondsSinceEpoch;
    await _updateLastReadTimestamp(stamp);
  } catch (e, stackTrace) {
    logger.severe('Failed to process incoming SMS: $e $stackTrace');
  }
}

/// Run an inbox scan now (used on connect / app open), not only every 15 min.
///
/// [lookback] re-reads recent SMS even if lastRead already advanced past them
/// (e.g. a prior parse/upload failure). Capped at [kSmsImportMaxWindow] and
/// never before the SMS connect/install timestamp.
Future<void> syncMessagesNow({Duration? lookback}) async {
  try {
    final newTimestamp = await readMessages(
      null,
      lookback: lookback ?? kSmsImportMaxWindow,
    );
    if (newTimestamp > 0) {
      await _updateLastReadTimestamp(newTimestamp);
    }
  } catch (e) {
    logger.severe('Immediate SMS sync failed: $e');
  }
}

Future<void> _updateLastReadTimestamp(int timestamp) async {
  final appPrefs = service<AppPreferences>();
  await appPrefs.setLastReadTimestamp(timestamp);
  logger.info("Updated lastReadTimestamp: $timestamp");
}

/// Marks the SMS/tracking floor the first time the app runs (install day,
/// local midnight). Later SMS connect must not move this floor — otherwise
/// history before "connect" would be skipped even though the user installed earlier.
Future<void> ensureAppTrackingStartFromInstall() async {
  final appPrefs = service<AppPreferences>();
  if (await appPrefs.hasInstallationDate()) return;

  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day);
  final ms = midnight.millisecondsSinceEpoch;
  await appPrefs.setInstallationDate(ms);
  await appPrefs.setLastReadTimestamp(ms);
  logger.info('App tracking start set to install day $midnight ($ms)');
}

/// Ensures a tracking floor exists. Prefer [ensureAppTrackingStartFromInstall].
/// [forceNow] no longer moves the install floor — it only seeds a missing date
/// (same as first launch) so SMS connect cannot erase the install-day start.
Future<void> ensureConnectedTimestamp({bool forceNow = false}) async {
  await ensureAppTrackingStartFromInstall();
  if (forceNow) {
    logger.info(
      'SMS connected — tracking floor kept at install day '
      '(forceNow no longer resets INSTALLATION_DATE)',
    );
  }
}

/// Sets the floor for SMS import to [start] (local midnight) and resets
/// last-read so the next scan imports from that day forward.
Future<void> setSmsTrackingStartDate(DateTime start) async {
  final appPrefs = service<AppPreferences>();
  final localMidnight = DateTime(start.year, start.month, start.day);
  final ms = localMidnight.millisecondsSinceEpoch;
  await appPrefs.setInstallationDate(ms);
  await appPrefs.setLastReadTimestamp(ms);
  logger.info('SMS tracking start set to $localMidnight ($ms)');
}

/// Full reset: wipe cloud + local transactions, set SMS start date, re-import.
/// Wallets / budgets / goals / planned payments are kept.
Future<({bool serverOk, String? serverError, int importedHint})>
    resetTransactionsAndSmsTracking({
  required DateTime trackingStart,
  bool reimportSms = true,
}) async {
  String? serverError;
  var serverOk = false;

  final cloud = await service<TransactionsService>().resetAllTransactions();
  await cloud.when(
    onSuccess: (_) async {
      serverOk = true;
    },
    onError: (err) async {
      serverError = err.error;
      serverOk = false;
    },
  );

  // Do not clear the phone if cloud wipe failed — a later sync would
  // re-download everything and undo a local-only wipe.
  if (!serverOk) {
    return (
      serverOk: false,
      serverError: serverError ?? 'Could not delete cloud transactions',
      importedHint: 0,
    );
  }

  await service<LocalDataCache>().clearAllTransactions();
  await setSmsTrackingStartDate(trackingStart);

  if (reimportSms) {
    // lastRead == tracking start → inbox scan imports that day through now.
    await syncMessagesNow(lookback: Duration.zero);
  }

  return (
    serverOk: true,
    serverError: null,
    importedHint: 0,
  );
}

Future<int> readMessages(
  Map<String, dynamic>? inputData, {
  Duration lookback = Duration.zero,
}) async {
  final appPrefs = service<AppPreferences>();
  logger.info("readMessages function called");
  logger.info("auth data is : ${await appPrefs.getAuthData()}");

  // Wallet may exist while SMS prefs were cleared (e.g. after delete/recreate).
  await ensureSmsBanksForUserWallets();

  int connectedAt = await appPrefs.getInstallationDate() ?? 0;
  int lastReadTimestamp = await appPrefs.getLastReadTimestamp() ?? 0;

  if (connectedAt == 0) {
    logger.warning("SMS not connected yet; skipping message read");
    return 0;
  }

  final nowMs = DateTime.now().millisecondsSinceEpoch;
  // Never import SMS from before the user connected messaging.
  final dateFloor = connectedAt;

  var startTimestamp =
      lastReadTimestamp > dateFloor ? lastReadTimestamp : dateFloor;

  final effectiveLookback =
      lookback > Duration.zero && lookback < kSmsImportMaxWindow
          ? lookback
          : (lookback > Duration.zero ? kSmsImportMaxWindow : Duration.zero);

  if (effectiveLookback > Duration.zero) {
    final lookbackStart = nowMs - effectiveLookback.inMilliseconds;
    // Re-read recent SMS to recover parse misses, but never before install.
    final candidate = lookbackStart > dateFloor ? lookbackStart : dateFloor;
    if (candidate < startTimestamp) {
      startTimestamp = candidate;
    }
    logger.info(
        'SMS lookback active: scan from $startTimestamp, date floor $dateFloor '
        '(${effectiveLookback.inHours}h, connectAt=$connectedAt)');
  }

  final enabled = await appPrefs.getSupportedBanks();
  logger.info('SMS enabled banks: $enabled');
  logger.info(
      'SMS connectedAt=$connectedAt lastRead=$lastReadTimestamp '
      'start=$startTimestamp floor=$dateFloor');

  List<SmsMessage> messages = await _fetchMessages(startTimestamp);
  List<SmsMessage> filteredMessages =
      await _filterMessages(messages, dateFloor);
  logger.info(
      'SMS inbox=${messages.length} filtered=${filteredMessages.length}');

  TransactionMessageList transactionsList =
      await _processMessages(filteredMessages);
  logger.info(
      'SMS parsed=${transactionsList.transactions.length}');

  int latestMessageTimestamp =
      _getLatestMessageTimestamp(filteredMessages, startTimestamp);

  if (transactionsList.transactions.isNotEmpty) {
    final uploaded =
        await _handleNewTransactions(transactionsList, inputData);
    logger.info('SMS converted/cached=$uploaded');
    if (uploaded == 0 && filteredMessages.isNotEmpty) {
      // Parsed something but convert/cache produced nothing — do not skip
      // these SMS forever (common when wallet resolve fails).
      logger.warning(
          'SMS parsed but none converted; keeping lastRead at $startTimestamp');
      return startTimestamp;
    }
  } else if (filteredMessages.isNotEmpty) {
    logger.info(
        "Bank SMS found but none parsed; keeping lastRead at $startTimestamp");
    for (final m in filteredMessages.take(3)) {
      logger.info(
          'Unparsed SMS from ${m.address}: ${(m.body ?? '').substring(0, (m.body?.length ?? 0).clamp(0, 160))}');
    }
    return startTimestamp;
  } else {
    logger.info("No new transactions to write or notify");
  }

  return latestMessageTimestamp;
}

/// If the user has SMS-capable wallets, ensure they are in SUPPORTED_BANKS
/// so inbox filters / parsers do not drop those messages.
Future<void> ensureSmsBanksForUserWallets() async {
  try {
    final prefs = service<AppPreferences>();
    final enabled = await prefs.getSupportedBanks();
    final enabledLower = enabled.map((e) => e.toLowerCase()).toSet();

    var wallets = <Wallet>[];
    final walletsRes = await service<WalletService>().fetchWallets();
    wallets = walletsRes.when(
      onSuccess: (data) => data,
      onError: (_) => <Wallet>[],
    );
    if (wallets.isEmpty) {
      wallets = await service<LocalDataCache>().loadWallets() ?? <Wallet>[];
    }

    final smsWalletNames = smsAddressToWalletName.values.toList();
    for (final wallet in wallets) {
      final name = wallet.institutionName?.isNotEmpty == true
          ? wallet.institutionName!
          : wallet.name;
      String? toAdd;
      for (final smsName in smsWalletNames) {
        if (walletNameMatchesSmsBank(name, smsName) ||
            walletNameMatchesSmsBank(wallet.shortname, smsName)) {
          toAdd = smsName;
          break;
        }
      }
      if (toAdd != null && !enabledLower.contains(toAdd.toLowerCase())) {
        await prefs.addSupportedBank(toAdd);
        enabledLower.add(toAdd.toLowerCase());
        logger.info('Re-enabled SMS bank pref for wallet: $toAdd');
      }
    }
  } catch (e) {
    logger.warning('ensureSmsBanksForUserWallets failed: $e');
  }
}

Future<List<SmsMessage>> _fetchMessages(int startTimestamp) async {
  if (Platform.isAndroid) {
    // SMS reading code here

    return await telephony!.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      filter: SmsFilter.where(SmsColumn.DATE)
          .greaterThanOrEqualTo(startTimestamp.toString()),
    );
  } else {
    // Return an empty list or handle the case where SMS reading is not supported
    return [];
  }
}

Future<List<SmsMessage>> _filterMessages(
    List<SmsMessage> messages, int connectedAt) async {
  final enabledBanks = await service<AppPreferences>().getSupportedBanks();
  final enabled = enabledBanks.map((b) => b.toLowerCase()).toSet();

  return messages.where((message) {
    final address = resolveSmsAddress(
      address: message.address,
      body: message.body,
    );
    if (address == null || !supportedBanks.contains(address)) {
      return false;
    }
    final walletName = smsAddressToWalletName[address];
    final isEnabledForUser = walletName != null &&
        (enabled.contains(walletName.toLowerCase()) ||
            enabled.any((e) => walletNameMatchesSmsBank(e, walletName)));
    final isOnOrAfterConnect =
        message.date == null || message.date! >= connectedAt;
    return isEnabledForUser && isOnOrAfterConnect;
  }).toList();
}

Future<TransactionMessageList> _processMessages(
    List<SmsMessage> messages) async {
  TransactionMessageList transactionsList =
      const TransactionMessageList(transactions: []);

  for (SmsMessage message in messages) {
    Map<String, dynamic> details =
        await TransactionExtractor.extractTransactionDetails(message, service);

    if (details.isNotEmpty) {
      // Keep transfer labels in to/from for UI; nature drives credit/debit.
      final transferLabel = details['to']?.toString() ??
          details['from']?.toString() ??
          '';
      details["type"] = details['nature'] ?? classifyTransactionType(details);
      if (narrationIsInternalTransfer(transferLabel)) {
        details['to'] = transferLabel;
        details['from'] = transferLabel;
      }
      logger.info(
          "Transaction type=${details['type']} narration=${details['to']}");
      TransactionMessage transaction = TransactionMessage.fromJson(details);

      transactionsList = addTransaction(transactionsList, transaction);
    }
  }

  // Pair bank ↔ M-Pesa legs of the same own-wallet move.
  return internalTransferLinker.link(transactionsList);
}

int _getLatestMessageTimestamp(
    List<SmsMessage> messages, int lastReadTimestamp) {
  return messages.fold(lastReadTimestamp, (maxTimestamp, message) {
    return message.date != null && message.date! > maxTimestamp
        ? message.date!
        : maxTimestamp;
  });
}

Future<int> _handleNewTransactions(TransactionMessageList transactionsList,
    Map<String, dynamic>? inputData) async {
  List<TransactionData> transactionData =
      await _convertToTransactionData(transactionsList);

  await writeTransactionsToFile(transactionsList);

  // Show in the app immediately from local DB; cloud upload is queued.
  // Only notify / queue upload for codes that are not already stored —
  // lookback / pull-to-refresh re-parses recent SMS and must not spam.
  var convertedCount = 0;
  try {
    final cache = service<LocalDataCache>();
    final localRows = LocalDataCache.fromTransactionData(transactionData);
    // Attach SMS running balances so home "Total Balance" stays accurate.
    final byCode = {
      for (final msg in transactionsList.transactions)
        if (msg.reference != null && msg.reference!.isNotEmpty)
          msg.reference!: msg,
    };
    final enriched = localRows.map((row) {
      final msg = byCode[row.transactionId];
      if (msg?.balance == null) return row;
      final balance = double.tryParse(
        msg!.balance.toString().replaceAll(',', ''),
      );
      if (balance == null) return row;
      return row.copyWith(balance: balance);
    }).toList();
    convertedCount = enriched.length;

    if (enriched.isNotEmpty) {
      final alreadyKnown = await cache.existingTransactionCodes(
        enriched.map((r) => r.transactionId),
      );
      final deleted = await cache.loadDeletedTransactionCodes();
      final brandNew = enriched
          .where((r) =>
              !alreadyKnown.contains(r.transactionId) &&
              !deleted.contains(r.transactionId.trim()))
          .toList();
      final alreadySeen = enriched
          .where((r) =>
              alreadyKnown.contains(r.transactionId) &&
              !deleted.contains(r.transactionId.trim()))
          .toList();

      // Refresh balances for known rows without re-queueing sync / notifying.
      if (alreadySeen.isNotEmpty) {
        await cache.mergeTransactions(
          alreadySeen,
          pendingSync: false,
          notify: brandNew.isEmpty,
        );
      }

      if (brandNew.isNotEmpty) {
        final newPayloads = transactionData
            .where((p) =>
                !alreadyKnown.contains(p.code) &&
                !deleted.contains(p.code.trim()))
            .toList();
        await cache.mergeTransactions(
          brandNew,
          pendingSync: true,
          uploadPayloads: newPayloads,
        );
        await NotificationService.showImmediateNotification(
          "New Transactions",
          "${brandNew.length} new transaction${brandNew.length == 1 ? '' : 's'} obtained",
        );
        transactionData = newPayloads;
      } else {
        transactionData = [];
        logger.info(
            'SMS re-scan found ${enriched.length} known transaction(s); skipping notification');
      }
    }
  } catch (e) {
    logger.warning('Failed to cache local SMS transactions: $e');
  }

  logger
      .info("The number of items to be uploaded is: ${transactionData.length}");
  if (transactionData.isNotEmpty) {
    // Never block the UI on cloud upload — local rows already notified Home.
    unawaited(() async {
      try {
        await service<SyncEngine>().syncNow();
      } catch (_) {
        try {
          await uploadMessages(transactionData);
        } catch (e) {
          logger.warning('Background SMS upload failed: $e');
        }
      }
    }());
  }
  // Return converted count (not only brand-new) so lastRead advances on re-scans.
  return convertedCount;
}

Future<List<TransactionData>> _convertToTransactionData(
    TransactionMessageList transactionsList) async {
  double parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      try {
        return double.parse(value.replaceAll(',', ''));
      } catch (e) {
        logger.severe('Failed to parse double: $value, error: $e');
        return 0.0;
      }
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  // Prefer fresh server wallets so we never attach a deleted/stale wallet id.
  var userWallets = <Wallet>[];
  final walletsRes = await service<WalletService>().fetchWallets();
  userWallets = walletsRes.when(
    onSuccess: (data) => data,
    onError: (error) {
      logger.warning(
          'Wallet refresh failed for SMS convert, using local cache: $error');
      return <Wallet>[];
    },
  );
  if (userWallets.isNotEmpty) {
    await service<LocalDataCache>().saveWallets(userWallets);
  } else {
    userWallets = await service<LocalDataCache>().loadWallets() ?? <Wallet>[];
  }
  logger.info(
      'SMS convert using ${userWallets.length} user wallets: '
      '${userWallets.map((w) => 'row=${w.id}/bank=${w.bankId}:${w.name}').join(', ')}');

  final out = <TransactionData>[];
  for (final transaction in transactionsList.transactions) {
    final ref = transaction.reference?.trim() ?? '';
    final amountRaw = transaction.amount;
    final amountStr = amountRaw?.toString().trim() ?? '';
    if (ref.isEmpty || amountStr.isEmpty) {
      logger.warning(
          'Dropping SMS tx missing ref/amount ref=$ref amount=$amountStr');
      continue;
    }

    // Transaction create API expects user_wallet_id (= Wallet.id).
    // Prefer the wallet whose currency matches the SMS (KES vs USD).
    final smsCurrency = normalizeSmsCurrency(transaction.currency);
    final walletId = _resolveUserWalletIdForSmsAccount(
      userWallets,
      transaction.account,
      currency: smsCurrency,
    );
    if (walletId == null) {
      logger.warning(
          'Dropping SMS tx $ref — no matching user wallet for ${transaction.account} ($smsCurrency). '
          'Wallets: ${userWallets.map((w) => "${w.id}:${w.institutionName ?? w.name}/${w.currency}").join(", ")}');
      continue;
    }

    // Prefer nature (credit/debit) so income totals stay correct.
    // Parser stores nature into `type` before building TransactionMessage.
    final rawType = (transaction.type ?? '').toLowerCase();
    String normalizedType;
    if (rawType == 'credit' ||
        rawType.contains('received') ||
        rawType.contains('deposit')) {
      normalizedType = 'credit';
    } else if (rawType == 'debit' ||
        rawType.contains('payment') ||
        rawType.contains('sent') ||
        rawType.contains('paid') ||
        rawType.contains('withdrawal') ||
        rawType.contains('purchase')) {
      normalizedType = 'debit';
    } else {
      final guessed = classifyTransactionType({
        'type': transaction.type,
        'from': transaction.from,
        'to': transaction.to,
      }).toLowerCase();
      if (guessed.contains('credit')) {
        normalizedType = 'credit';
      } else if (guessed.contains('debit')) {
        normalizedType = 'debit';
      } else {
        final to = (transaction.to ?? '').toLowerCase();
        final from = (transaction.from ?? '').toLowerCase();
        if (to.contains('your account') ||
            to.contains('your card') ||
            to == 'ncba bank' ||
            to == 'equity bank' ||
            to == 'i&m bank') {
          normalizedType = 'credit';
        } else if (from.contains('your account') ||
            from.contains('your card')) {
          normalizedType = 'debit';
        } else {
          logger.warning(
              'Ambiguous credit/debit for $ref type=$rawType from=$from to=$to — defaulting to debit');
          // Prefer debit (expense) when ambiguous — never invent income.
          final fromIsUser = from.contains('your account') ||
              from.contains('your card') ||
              from.contains('m-pesa') ||
              from.contains('mpesa') ||
              from.contains('bank');
          final toIsUser = to.contains('your account') ||
              to.contains('your card');
          if (toIsUser && !fromIsUser) {
            normalizedType = 'credit';
          } else {
            normalizedType = 'debit';
          }
        }
      }
    }

    final label = transaction.to ?? transaction.from ?? "Fuliza Credit";
    out.add(TransactionData(
      name: label,
      wallet: walletId,
      amount: parseDouble(amountRaw),
      charges: parseDouble(transaction.cost ?? '0'),
      datetime: transaction.datetime,
      code: ref,
      type: narrationIsInternalTransfer(label)
          ? (normalizedType.contains('credit') ? 'credit' : 'debit')
          : normalizedType,
      currency: smsCurrency,
    ));
  }
  return out;
}

/// Maps an SMS account/address to the user wallet row id ([Wallet.id]).
/// When the user has both KES and USD wallets for the same bank, prefer
/// the wallet whose [currency] matches the SMS.
int? _resolveUserWalletIdForSmsAccount(
  List<Wallet> wallets,
  String? account, {
  String currency = 'KES',
}) {
  if (wallets.isEmpty) return null;

  final mappedName = account == null
      ? null
      : smsAddressToWalletName[normalizeSmsAddress(account) ?? account];
  final normalizedAccount = (account ?? '').toLowerCase().trim();
  final wantCurrency = normalizeSmsCurrency(currency);

  final matches = <Wallet>[];
  for (final wallet in wallets) {
    final name = wallet.institutionName?.isNotEmpty == true
        ? wallet.institutionName!
        : wallet.name;
    final shortname = wallet.shortname;
    var isBankMatch = false;
    if (mappedName != null && walletNameMatchesSmsBank(name, mappedName)) {
      isBankMatch = true;
    } else if (mappedName != null &&
        walletNameMatchesSmsBank(shortname, mappedName)) {
      isBankMatch = true;
    } else if (normalizedAccount.isNotEmpty &&
        (name.toLowerCase() == normalizedAccount ||
            shortname.toLowerCase() == normalizedAccount ||
            walletNameMatchesSmsBank(name, account!))) {
      isBankMatch = true;
    }
    if (isBankMatch) matches.add(wallet);
  }

  if (matches.isEmpty) {
    // Last resort: single wallet → attach there.
    if (wallets.length == 1) return wallets.first.id;
    return null;
  }

  // Prefer exact currency (USD dollar account vs KES).
  for (final w in matches) {
    if (walletCurrencyMatches(w.currency, wantCurrency)) return w.id;
  }
  // USD SMS but only KES wallet exists — still attach rather than drop.
  return matches.first.id;
}

TransactionMessageList addTransaction(
    TransactionMessageList transactionsList, TransactionMessage transaction) {
  if (transaction.amount == null || transaction.type == "Unknown") {
    return transactionsList;
  }

  bool isDuplicate = transactionsList.transactions.any(
    (t) =>
        t.reference == transaction.reference &&
        t.account == transaction.account,
  );

  if (!isDuplicate) {
    return transactionsList.copyWith(
      transactions: List.of(transactionsList.transactions)..add(transaction),
    );
  }
  return transactionsList;
}

Future<void> uploadMessages(List<TransactionData> transactionsData) async {
  try {
    final wallets =
        await service<LocalDataCache>().loadWallets() ?? const <Wallet>[];
    final payload = wallets.isEmpty
        ? transactionsData
        : ensureUserWalletIds(transactionsData, wallets);
    final transactionService = service<TransactionsService>();
    final result = await transactionService.saveMultipleTransactions(payload);
    await result.when(
      onError: (error) async {
        logger.severe(
            'Failed to upload ${payload.length} SMS transactions: ${error.error}');
      },
      onSuccess: (message) async {
        final codes = payload.map((t) => t.code).toList();
        await service<LocalDataCache>().markUploaded(codes);
        logger.info(
            'Successfully uploaded ${payload.length} transactions: $message');
      },
    );
  } catch (e) {
    logger.severe('Failed to upload transactions: $e');
  }
}

Future<void> writeTransactionsToFile(
    TransactionMessageList transactionsList) async {
  Directory? directory = await _getAppropriateDirectory();
  if (directory == null) {
    throw Exception('Unable to get directory');
  }

  final String timestamp = DateTime.now().toIso8601String();
  final file = File('${directory.path}/transactions_$timestamp.json');

  try {
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(transactionsList.toJson()));
    logger.info('Transactions written to file successfully: ${file.path}');
  } catch (e) {
    logger.severe('An error occurred while writing to file: $e');
    rethrow;
  }
}

Future<Directory?> _getAppropriateDirectory() async {
  if (Platform.isAndroid) {
    return await getExternalStorageDirectory();
  } else {
    return await getApplicationDocumentsDirectory();
  }
}

void scheduleMessageReading() async {
  try {
    final appPrefs = service<AppPreferences>();
    await ensureConnectedTimestamp();

    final connectedAt = await appPrefs.getInstallationDate() ?? 0;
    final lastReadTimestamp = await appPrefs.getLastReadTimestamp() ?? 0;

    logger.info("Connected at: $connectedAt");
    logger.info("Last read timestamp: $lastReadTimestamp");

    // Realtime path — airtime/payments show as soon as the SMS arrives.
    await startRealtimeSmsListening();
    // Catch anything that arrived while the app was not listening,
    // including SMS skipped earlier by a failed parse / rate-limit.
    // Only the last 12h from install/connect — avoid historical dumps.
    unawaited(syncMessagesNow(lookback: kSmsImportMaxWindow));

    await Workmanager().registerPeriodicTask(
      MESSAGE_READING_TASK,
      MESSAGE_READING_TASK,
      frequency: MESSAGE_READING_FREQUENCY,
      initialDelay: MESSAGE_READING_INITIAL_DELAY,
      inputData: {
        'installationDate': connectedAt.toString(),
        'lastReadTimestamp': lastReadTimestamp.toString(),
      },
    );

    logger.info("Tasks have been scheduled successfully");
  } catch (e) {
    logger.severe('Failed to schedule message reading tasks: $e');
  }
}
