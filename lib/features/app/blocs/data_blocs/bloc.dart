import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  late AnalyticsService _service;
  late LocalDataCache _cache;

  DataBloc() : super(const DataState()) {
    _service = service<AnalyticsService>();
    _cache = service<LocalDataCache>();

    on<StartDataBloc>((DataEvent event, Emitter<DataState> emit) async {
      try {
        final cached = await _cache.loadHomeData();
        if (cached != null && cached.data.isNotEmpty) {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: cached.data,
            totals: cached.totals,
          ));
        } else {
          final empty = LocalDataCache.emptyHomeCard();
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: empty,
            totals: 0,
          ));
        }
      } catch (_) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          data: LocalDataCache.emptyHomeCard(),
          totals: 0,
        ));
      }

      // Prefer totals derived from the same transactions list shown below.
      try {
        final aligned = await _cardDataAlignedWithTransactions();
        if (aligned != null) {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: aligned,
            totals: _asDouble(aligned['total_balance']),
          ));
        }
      } catch (_) {}

      final res = await _service.fetchCardData();
      await res.when(onError: (error) async {
        // Keep local/empty card visible; only fail if we have nothing.
        if (state.data.isEmpty) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        }
      }, onSuccess: (data) async {
        final server = _normalizeCardData(data);
        Map<String, dynamic> merged = server;
        try {
          merged = await _overlayWithLocalTransactions(server);
        } catch (_) {}
        final totals = _asDouble(merged['total_balance']);
        emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: merged,
            totals: totals,
          ),
        );
        try {
          await _cache.saveHomeData(merged, totals: totals);
        } catch (_) {}
      });
    });

    on<RefreshData>((event, emit) async {
      final res = await _service.fetchCardData();
      await res.when(onError: (error) async {
        // Keep showing locally aligned totals when the API fails.
        final aligned = await _cardDataAlignedWithTransactions();
        if (aligned != null) {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: aligned,
            totals: _asDouble(aligned['total_balance']),
          ));
        } else if (state.data.isEmpty) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        }
      }, onSuccess: (data) async {
        final server = _normalizeCardData(data);
        final merged = await _overlayWithLocalTransactions(server);
        final totals = _asDouble(merged['total_balance']);
        emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            data: merged,
            totals: totals,
          ),
        );
        await _cache.saveHomeData(merged, totals: totals);
      });
    });

    on<SyncCardDataFromTransactions>((event, emit) async {
      // Wallets often load before transactions — never zero the donut from [].
      if (event.transactions.isEmpty) {
        final cached = await _cache.loadTransactions();
        if (cached == null || cached.transactions.isEmpty) {
          return;
        }
        final wallets = event.wallets ?? await _loadCachedWallets();
        final card = buildCardDataFromTransactions(
          cached.transactions,
          wallets: wallets,
          baseline: state.data.isEmpty
              ? LocalDataCache.emptyHomeCard()
              : state.data,
        );
        final totals = _asDouble(card['total_balance']);
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          data: card,
          totals: totals,
        ));
        await _cache.saveHomeData(card, totals: totals);
        return;
      }

      final wallets = event.wallets ?? await _loadCachedWallets();
      final card = buildCardDataFromTransactions(
        event.transactions,
        wallets: wallets,
        baseline:
            state.data.isEmpty ? LocalDataCache.emptyHomeCard() : state.data,
      );
      final totals = _asDouble(card['total_balance']);
      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        data: card,
        totals: totals,
      ));
      await _cache.saveHomeData(card, totals: totals);
    });
  }

  Map<String, dynamic> _normalizeCardData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    // New accounts sometimes return null card_data.
    return LocalDataCache.emptyHomeCard();
  }

  Future<Map<String, dynamic>?> _cardDataAlignedWithTransactions() async {
    final cachedTx = await _cache.loadTransactions();
    if (cachedTx == null || cachedTx.transactions.isEmpty) return null;
    final wallets = await _loadCachedWallets();
    return buildCardDataFromTransactions(
      cachedTx.transactions,
      wallets: wallets,
      baseline: state.data.isEmpty ? LocalDataCache.emptyHomeCard() : state.data,
    );
  }

  Future<Map<String, dynamic>> _overlayWithLocalTransactions(
    Map<String, dynamic> serverData,
  ) async {
    final cachedTx = await _cache.loadTransactions();
    if (cachedTx == null || cachedTx.transactions.isEmpty) {
      return Map<String, dynamic>.from(serverData);
    }
    final wallets = await _loadCachedWallets();
    return buildCardDataFromTransactions(
      cachedTx.transactions,
      wallets: wallets,
      baseline: serverData,
    );
  }

  Future<List<Wallet>> _loadCachedWallets() async {
    return await _cache.loadWallets() ?? const <Wallet>[];
  }
}

/// Builds home card keys from the transactions list so donut + list match.
Map<String, dynamic> buildCardDataFromTransactions(
  List<Transaction> transactions, {
  List<Wallet> wallets = const [],
  Map<String, dynamic> baseline = const {},
}) {
  var incomes = 0.0;
  var expenses = 0.0;

  for (final tx in transactions) {
    // Own-wallet moves (e.g. I&M → M-Pesa) must not inflate Income/Expense.
    if (narrationIsInternalTransfer(tx.narration)) continue;

    if (tx.type == TransactionType.credit) {
      incomes += tx.amount;
    } else {
      expenses += tx.amount + (tx.charges ?? 0);
    }
  }

  final data = Map<String, dynamic>.from(
    baseline.isEmpty ? LocalDataCache.emptyHomeCard() : baseline,
  );
  data['incomes'] = incomes;
  data['expenses'] = expenses;
  // Net from tracked activity only — not bank/M-Pesa SMS running balances.
  data['total_balance'] = incomes - expenses;
  return data;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
  return 0;
}
