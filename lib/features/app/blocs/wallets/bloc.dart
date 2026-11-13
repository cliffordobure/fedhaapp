import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/models/wallet/wallet_detail/wallet_details.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fedha/features/app/blocs/analytics/blocs.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/graphs/bloc.dart';
import 'package:fedha/features/app/blocs/new_analytics/new_analytic_bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/wallet-details/wallet_details_bloc.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/utils/message_reading_service/scheduller.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  late WalletService walletsService;
  late BanksService banksService;
  late TransactionsService transactionsService;
  late AppPreferences appPreferences;
  late LocalDataCache localCache;
  final TransactionsBloc transactionsBloc;
  final GraphsBloc graphsBloc;
  final DataBloc dataBloc;
  final NewAnalyticBloc newAnalyticBloc;
  final AnalyticsBloc analyticsBloc;
  final WalletDetailsBloc walletDetailsBloc;

  WalletsBloc(
    this.transactionsBloc, {
    required this.graphsBloc,
    required this.dataBloc,
    required this.newAnalyticBloc,
    required this.analyticsBloc,
    required this.walletDetailsBloc,
  }) : super(const WalletsState()) {
    walletsService = service<WalletService>();
    banksService = service<BanksService>();
    transactionsService = service<TransactionsService>();
    appPreferences = service<AppPreferences>();
    localCache = service<LocalDataCache>();

    on<StartWalletBloc>((WalletsEvent event, Emitter<WalletsState> emit) async {
      // Show cached wallets immediately, then sync.
      try {
        final cachedWallets = await localCache.loadWallets();
        if (cachedWallets != null && cachedWallets.isNotEmpty) {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            wallets: cachedWallets,
          ));
        } else {
          // New accounts have no wallets yet — show empty UI, not a spinner.
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            wallets: const [],
          ));
        }
      } catch (e) {
        debugPrint('Local wallets unavailable: $e');
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          wallets: const [],
        ));
      }

      final res = await walletsService.fetchWallets();
      res.when(
        onError: (error) {
          if (state.wallets.isEmpty) {
            emit(
              state.copyWith(
                  status: ServiceStatus.loadingFailure,
                  message: ApplicationMessage.fromFailure(error)),
            );
          }
        },
        onSuccess: (data) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingSuccess,
                wallets: data,
                smsUploaded: false),
          );
          localCache.saveWallets(data);
          // Heal SQLite rows that still store bank catalog ids as wallet_id.
          // Notifies TransactionsBloc via localTransactionUpdates.
          unawaited(localCache.normalizeLocalWalletIds(data));
          unawaited(_syncHomeCardFromAvailableTransactions(data));
        },
      );

      // fethc banks
      final resBanks = await banksService.fetchBanks();
      resBanks.when(onError: (error) {
        // Banks catalog is optional — never fail the whole wallets screen.
        debugPrint(error.error);
      }, onSuccess: (data) {
        // Emit the initial state with updated banks and filteredBanks
        emit(
          state.copyWith(
            banks: data,
            filteredBanks: data, // Update the state with all banks
          ),
        );

        // Define the list of supported banks
        List<String> supportedBanksList = [
          "M-Pesa",
          "Co-Operative Bank",
          "NCBA Bank",
          "Standard Chartered Bank",
          "Stanbic Bank",
          "Equity Bank",
          "I&M Bank",
        ];

        // Filter the banks based on whether they are in the supportedBanksList
        final supportedBanks = data.where((bank) {
          final name = bank.name.toLowerCase();
          return supportedBanksList.any((b) => b.toLowerCase() == name) ||
              name.contains('i&m') ||
              name.contains('i & m') ||
              name.contains('i and m') ||
              name.contains('equity') ||
              name.contains('standard chartered') ||
              name.contains('stanchart') ||
              name.contains('stanbic') ||
              name.contains('ncba') ||
              name.contains('coop') ||
              name.contains('co-op') ||
              name.contains('co-operative') ||
              name.contains('cooperative') ||
              name.contains('pesa');
        }).toList();

        debugPrint("Supported banks: ${supportedBanks.length}");
        debugPrint(supportedBanks.toString());

        // Emit the state with the filtered supported banks
        emit(
          state.copyWith(
            filteredBanks: supportedBanks,
            supportedBanks: supportedBanks,
          ),
        );
      });

      // fetch currencies (always keep KES + USD available for dollar accounts)
      final resCurrencies = await banksService.fetchCurrencies();
      resCurrencies.when(
        onError: (error) {
          debugPrint(error.error);
          emit(state.copyWith(currencies: _defaultCurrencies()));
        },
        onSuccess: (data) => emit(
          state.copyWith(currencies: _ensureKesAndUsd(data)),
        ),
      );
    });

    // on<FilterBanks>((event, emit) {
    //   banks = state.banks;

    //   if (event.query == '') {
    //     emit(state.copyWith(filteredBanks: banks));
    //   }
    //   debugPrint("filtereBanks called : ${banks.length}");
    //   final filteredBanks = banks.where((bank) {
    //     final name = bank.name.toLowerCase();
    //     return name.contains(event.query);
    //   }).toList();

    //   debugPrint(filteredBanks.toString());
    //   emit(
    //     state.copyWith(filteredBanks: filteredBanks),
    //   );
    // });

    on<FilterBanks>((event, emit) {
      final query = event.query.toLowerCase();
      final filteredBanks = state.supportedBanks.where((bank) {
        return query.isEmpty || bank.name.toLowerCase().contains(query);
      }).toList();

      debugPrint("Filtered banks: ${filteredBanks.length}");
      emit(
        state.copyWith(
          filteredBanks: filteredBanks,
          selectedIndex: null,
        ),
      );
    });
    on<RadioSelectEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
      debugPrint(
          "This is the event index: ${event.index}, this is the state ${state.selectedIndex}");
    });

    on<CreateManualWallet>((event, emit) async {
      showLoading("Saving wallet");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final bankId = int.tryParse('${event.data['bank_id']}') ??
          (event.data['bank_id'] is int ? event.data['bank_id'] as int : null);
      final currency =
          (event.data['currency']?.toString() ?? 'KES').toUpperCase();
      if (bankId == null) {
        showError('Invalid bank selected.');
        emit(state.copyWith(status: ServiceStatus.submissionFailure));
        return;
      }

      final duplicate = state.wallets.any((w) =>
          w.bankId == bankId &&
          (w.currency ?? 'KES').toUpperCase() == currency);
      if (duplicate) {
        showError(
          'You already have a $currency account for this bank.',
        );
        emit(state.copyWith(status: ServiceStatus.submissionFailure));
        return;
      }

      final payload = Map<String, dynamic>.from(event.data)
        ..['bank_id'] = bankId
        ..['currency'] = currency;

      var res = await walletsService.saveWallet(payload);
      var created = false;
      String? createError;

      res.when(
        onError: (error) => createError = error.error,
        onSuccess: (data) {
          created = true;
          showSuccess(data);
          emit(state.copyWith(status: ServiceStatus.loadingSuccess));
        },
      );

      // Live API may still enforce one wallet per bank. For a second
      // currency (e.g. I&M KES + I&M USD), park the existing wallet on
      // another bank_id, create, then restore — update has no uniqueness.
      if (!created &&
          createError != null &&
          _isLegacyOneWalletPerBankError(createError!)) {
        final parked = await _createSecondCurrencyWallet(
          bankId: bankId,
          currency: currency,
          payload: payload,
        );
        if (parked != null) {
          created = true;
          showSuccess(parked);
          emit(state.copyWith(status: ServiceStatus.loadingSuccess));
        } else {
          showError(createError!);
          emit(state.copyWith(status: ServiceStatus.submissionFailure));
        }
      } else if (!created) {
        showError(createError ?? 'Could not save wallet');
        emit(state.copyWith(status: ServiceStatus.submissionFailure));
      }

      // refresh wallets
      add(RefreshWallets());
    });

    on<CreateAutomaticWallet>((event, emit) async {
      showLoading("Connecting ${event.bank.name}...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final alreadyHasWallet = state.wallets.any((wallet) =>
          wallet.bankId == event.bank.id ||
          wallet.name.toLowerCase() == event.bank.name.toLowerCase());

      var created = alreadyHasWallet;
      if (!alreadyHasWallet) {
        // Prefer the same create payload as manual wallets (known-good),
        // then fall back to bulk add with the required `wallets` field.
        String currencySymbol = "KES";
        final kesMatches = state.currencies.where((c) =>
            c.symbol.toUpperCase() == 'KES' ||
            c.name.toUpperCase().contains('KES'));
        if (kesMatches.isNotEmpty) {
          currencySymbol = kesMatches.first.symbol;
        } else if (state.currencies.isNotEmpty) {
          currencySymbol = state.currencies.first.symbol;
        }

        final createRes = await walletsService.saveWallet({
          "institution_name": event.bank.name,
          "currency": currencySymbol,
          "bank_id": event.bank.id,
        });

        var createFailed = false;
        createRes.when(
          onError: (_) {
            createFailed = true;
          },
          onSuccess: (data) {
            created = true;
            showSuccess(data);
            emit(state.copyWith(status: ServiceStatus.submissionSuccess));
          },
        );

        if (createFailed) {
          final res = await banksService.saveWallets([event.bank.id]);
          res.when(
            onError: (error) {
              showError(error.error);
              emit(state.copyWith(status: ServiceStatus.submissionFailure));
            },
            onSuccess: (data) {
              created = true;
              showSuccess(data);
              emit(state.copyWith(status: ServiceStatus.submissionSuccess));
            },
          );
        }
      } else {
        showSuccess("${event.bank.name} is already connected");
        emit(state.copyWith(status: ServiceStatus.submissionSuccess));
      }

      if (created) {
        await appPreferences.addSupportedBank(event.bank.name);
        // Normalize display names to the keys SMS filters / parsers expect.
        final lower = event.bank.name.toLowerCase();
        if (lower.contains('pesa')) {
          await appPreferences.addSupportedBank('M-Pesa');
        }
        if (lower.contains('i&m') ||
            lower.contains('i & m') ||
            lower.contains('i and m')) {
          await appPreferences.addSupportedBank('I&M Bank');
        }
        if (lower.contains('equity')) {
          await appPreferences.addSupportedBank('Equity Bank');
        }
        if (lower.contains('coop') ||
            lower.contains('co-op') ||
            lower.contains('co-operative') ||
            lower.contains('cooperative')) {
          await appPreferences.addSupportedBank('Co-Operative Bank');
        }
        if (lower.contains('ncba')) {
          await appPreferences.addSupportedBank('NCBA Bank');
        }
        if (lower.contains('stanbic')) {
          await appPreferences.addSupportedBank('Stanbic Bank');
        }
        if (lower.contains('standard chartered') || lower.contains('stanchart')) {
          await appPreferences.addSupportedBank('Standard Chartered Bank');
        }
        await appPreferences.acceptReadMessages();
        add(RefreshWallets());
        transactionsBloc.add(RefreshTransactions());
        // Pull recent bank SMS into the app like M-Pesa does.
        unawaited(syncMessagesNow(lookback: kSmsImportMaxWindow));
      }
    });

    on<UpdateWalletSms>((UpdateWalletSms event, Emitter<WalletsState> emit) {
      state.copyWith(smsUploaded: true);
    });
    // RefreshWallets
    on<RefreshWallets>((WalletsEvent event, Emitter<WalletsState> emit) async {
      // Keep current wallets visible while refreshing.
      final res = await walletsService.fetchWallets();
      res.when(
        onError: (error) {
          if (state.wallets.isEmpty) {
            showError(error.error);
            emit(state.copyWith(status: ServiceStatus.loadingFailure));
          }
        },
        onSuccess: (data) {
          emit(
            state.copyWith(
                wallets: data,
                status: ServiceStatus.loadingSuccess,
                smsUploaded: false),
          );
          localCache.saveWallets(data);
          // Keep donut balance aligned when wallet balances change.
          unawaited(_syncHomeCardFromAvailableTransactions(data));
        },
      );
    });

    on<UpdateManualWallet>(
      (event, emit) async {
        showLoading("Updating wallet");
        emit(state.copyWith(status: ServiceStatus.submissionInProgress));
        final resp =
            await walletsService.updateWallet(event.walletId, event.data);

        resp.when(onError: (error) {
          showError(error.error);

          emit(state.copyWith(status: ServiceStatus.submissionFailure));
        }, onSuccess: (data) {
          showSuccess(data);

          emit(state.copyWith(status: ServiceStatus.loadingSuccess));
        });

        // refresh wallets
        add(RefreshWallets());
      },
    );

    on<DeleteWallet>(
      (event, emit) async {
        emit(state.copyWith(status: ServiceStatus.submissionInProgress));

        final matchingWallets =
            state.wallets.where((w) => w.id == event.wallletId);
        final wallet =
            matchingWallets.isEmpty ? null : matchingWallets.first;

        // 1) Update local data immediately so the UI never waits on the server.
        final remainingWallets = state.wallets
            .where((w) => w.id != event.wallletId)
            .toList(growable: false);

        if (wallet != null) {
          await _stripWalletFromLocalCache(wallet);
        }
        await localCache.saveWallets(remainingWallets);
        await _cleanupLocalWalletData(wallet);

        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          wallets: remainingWallets,
        ));
        showSuccess("Wallet deleted");
        // Don't RefreshTransactions from the server yet — that would bring
        // deleted rows back before background sync finishes.
        graphsBloc.add(RefreshGraphs());
        dataBloc.add(RefreshData());
        analyticsBloc.add(RefreshAnalytics());
        newAnalyticBloc
            .add(const NewAnalyticEvent.fetched(period: 'this_month'));

        // 2) Sync deletion to the server in the background (no loading UI).
        unawaited(_syncWalletDeletionToServer(
          walletId: event.wallletId,
          wallet: wallet,
          remainingWallets: remainingWallets,
        ));
      },
    ); // RefreshWallets

    // Exchange token
    on<ExchangeBankToken>(
      (event, emit) async {
        showLoading("Saving account");
        emit(
          state.copyWith(status: ServiceStatus.submissionInProgress),
        );

        final res = await walletsService.exchangeToken(code: event.token);

        res.when(onError: (error) {
          showError("An error occured while saving wallet");
          emit(
            state.copyWith(status: ServiceStatus.submissionFailure),
          );
        }, onSuccess: (success) {
          if (kDebugMode) {
            print(success);
          }
          showSuccess(success["message"] ?? "Wallet saved successfully");
          emit(
            state.copyWith(
                message:
                    ApplicationMessage.success("Wallet saved successfully"),
                status: ServiceStatus.submissionSuccess),
          );
          // Refresh wallets
          add(RefreshWallets());
          // Refresh Transactions
          transactionsBloc.add(RefreshTransactions());
        });
      },
    );
  }

  /// Immediately remove this wallet's rows from local cache + UI.
  Future<void> _stripWalletFromLocalCache(Wallet wallet) async {
    final markers = _walletNarrationMarkers(wallet);
    final refs = <int>{wallet.id, wallet.bankId};
    final cached = await localCache.loadTransactions();
    final current =
        cached?.transactions ?? transactionsBloc.state.transactions;

    final remaining = current.where((tx) {
      final byRef = tx.walletId != null && refs.contains(tx.walletId);
      final byNarration = _narrationMatchesWallet(tx.narration, markers);
      return !byRef && !byNarration;
    }).toList(growable: false);

    final total = remaining.fold<double>(0, (sum, t) => sum + t.amount);
    transactionsBloc.add(
      ApplyLocalTransactions(transactions: remaining, total: total),
    );
  }

  /// Server-side cleanup after the UI has already been updated locally.
  Future<void> _syncWalletDeletionToServer({
    required int walletId,
    required Wallet? wallet,
    required List<Wallet> remainingWallets,
  }) async {
    try {
      if (wallet != null) {
        await _deleteTransactionsForWallet(wallet, silent: true);
      } else {
        await _deleteWalletDetailTransactions(walletId, silent: true);
      }

      final resp = await walletsService.deleteWallet(walletId: walletId);
      resp.when(
        onError: (error) {
          debugPrint('Background wallet delete failed: ${error.error}');
        },
        onSuccess: (_) {
          debugPrint('Background wallet delete succeeded for $walletId');
        },
      );

      await _purgeOrphanTransactions(remainingWallets, silent: true);
      // Quiet sync — refresh from server without loading spinners.
      transactionsBloc.add(RefreshTransactions());
      graphsBloc.add(RefreshGraphs());
      dataBloc.add(RefreshData());
    } catch (e) {
      debugPrint('Background wallet sync failed: $e');
    } finally {
      // In case any leftover loading overlay is still up.
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
    }
  }

  Future<void> _deleteTransactionsForWallet(
    Wallet wallet, {
    bool silent = true,
  }) async {
    final refs = <int>{wallet.id, wallet.bankId};
    final ids = <int>{
      ...await _collectWalletDetailTransactionIds(wallet.id),
      ...await _collectGlobalTransactionIds(
        matchingRefs: refs,
        narrationMarkers: _walletNarrationMarkers(wallet),
      ),
    };
    await _deleteTransactionIds(ids, silent: silent);
  }

  Future<void> _deleteWalletDetailTransactions(
    int walletId, {
    bool silent = true,
  }) async {
    final ids = await _collectWalletDetailTransactionIds(walletId);
    await _deleteTransactionIds(ids.toSet(), silent: silent);
  }

  /// Deletes transactions slowly with backoff so the API rate limiter
  /// ("Too many requests") does not abort a wallet wipe mid-way.
  Future<void> _deleteTransactionIds(
    Set<int> ids, {
    bool silent = true,
  }) async {
    if (ids.isEmpty) return;

    final list = ids.toList(growable: false);
    const minDelay = Duration(milliseconds: 350);
    var backoff = minDelay;
    var index = 0;
    var retriesForCurrent = 0;
    const maxRetriesPerId = 6;

    while (index < list.length) {
      final id = list[index];

      final result = await transactionsService.deleteTransaction(id);
      var rateLimited = false;

      result.when(
        onError: (error) {
          final message = error.error.toLowerCase();
          rateLimited = error.code == 429 ||
              message.contains('too many') ||
              message.contains('rate limit') ||
              message.contains('throttle');
          final alreadyGone = !rateLimited &&
              (error.code == 404 || message.contains('not found'));
          if (!rateLimited && !alreadyGone) {
            debugPrint('Failed to delete transaction $id: ${error.error}');
          }
        },
        onSuccess: (_) {},
      );

      if (rateLimited) {
        retriesForCurrent++;
        if (retriesForCurrent > maxRetriesPerId) {
          debugPrint(
              'Giving up on transaction $id after $maxRetriesPerId rate-limit retries');
          index++;
          retriesForCurrent = 0;
          backoff = minDelay;
          continue;
        }
        backoff = Duration(
          milliseconds: (backoff.inMilliseconds * 2).clamp(350, 10000),
        );
        await Future.delayed(backoff);
        continue;
      }

      index++;
      retriesForCurrent = 0;
      backoff = minDelay;
      await Future.delayed(minDelay);
    }
  }

  Future<List<int>> _collectWalletDetailTransactionIds(int walletId) async {
    final ids = <int>[];
    WalletDetailData? detail;

    final firstPage = await walletsService.fetchWalletDetails(walletId);
    firstPage.when(
      onError: (error) {
        debugPrint('Could not load wallet transactions: ${error.error}');
      },
      onSuccess: (data) {
        detail = data;
      },
    );

    if (detail == null) return ids;

    ids.addAll(
      detail!.transactions.data.map((t) => t.id).where((id) => id > 0),
    );

    var page = detail!.transactions.currentPage;
    final lastPage = detail!.transactions.lastPage;
    while (page < lastPage) {
      page++;
      await Future.delayed(const Duration(milliseconds: 200));
      final more =
          await walletsService.fetchMoreTransactions(walletId, page);
      more.when(
        onError: (error) {
          debugPrint('Could not load wallet page $page: ${error.error}');
        },
        onSuccess: (txPage) {
          ids.addAll(txPage.data.map((t) => t.id).where((id) => id > 0));
        },
      );
    }

    return ids;
  }

  Future<Set<int>> _collectGlobalTransactionIds({
    Set<int> matchingRefs = const {},
    Set<int> excludeRefs = const {},
    List<String> narrationMarkers = const [],
    bool orphanMode = false,
  }) async {
    final ids = <int>{};
    var page = 1;
    var hasMore = true;

    while (hasMore) {
      if (page > 1) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      final response = await transactionsService.fetchTransactions(
        page: page == 1 ? null : page,
      );

      response.when(
        onError: (error) {
          debugPrint('Could not load transactions page $page: ${error.error}');
          hasMore = false;
        },
        onSuccess: (data) {
          for (final tx in data.data) {
            if (tx.id <= 0) continue;

            final matchesRef =
                tx.walletId != null && matchingRefs.contains(tx.walletId);
            final matchesNarration = narrationMarkers.isNotEmpty &&
                _narrationMatchesWallet(tx.narration, narrationMarkers);

            if (orphanMode) {
              final isUnknownWallet = tx.walletId != null &&
                  !excludeRefs.contains(tx.walletId);
              if (isUnknownWallet || matchesNarration) {
                ids.add(tx.id);
              }
            } else if (matchesRef || matchesNarration) {
              ids.add(tx.id);
            }
          }

          hasMore = data.nextPageUrl != null && data.data.isNotEmpty;
          page++;
        },
      );
    }

    return ids;
  }

  Future<void> _purgeOrphanTransactions(
    List<Wallet> wallets, {
    bool silent = true,
  }) async {
    final validRefs = <int>{
      for (final wallet in wallets) ...[wallet.id, wallet.bankId],
    };
    final orphanMarkers = _orphanNarrationMarkers(wallets);

    final orphanIds = await _collectGlobalTransactionIds(
      excludeRefs: validRefs,
      narrationMarkers: orphanMarkers,
      orphanMode: true,
    );

    if (orphanIds.isEmpty) return;

    debugPrint('Purging ${orphanIds.length} orphan transactions');
    await _deleteTransactionIds(orphanIds, silent: silent);
    if (!silent) {
      transactionsBloc.add(RefreshTransactions());
      graphsBloc.add(RefreshGraphs());
      dataBloc.add(RefreshData());
    }
  }

  List<String> _walletNarrationMarkers(Wallet wallet) {
    final markers = <String>{
      wallet.name,
      wallet.shortname,
      if (wallet.institutionName != null) wallet.institutionName!,
    };

    final lowered = markers.map((m) => m.toLowerCase()).toList();
    if (lowered.any((m) => m.contains('pesa'))) {
      markers.addAll(['M-Pesa', 'M-pesa', 'MPESA', 'M-PESA', 'mpesa']);
    }
    return markers.toList();
  }

  List<String> _orphanNarrationMarkers(List<Wallet> wallets) {
    final hasMpesaWallet = wallets.any((wallet) {
      final haystack = [
        wallet.name,
        wallet.shortname,
        wallet.institutionName ?? '',
      ].join(' ').toLowerCase();
      return haystack.contains('pesa');
    });

    if (hasMpesaWallet) return const [];
    return ['M-Pesa', 'M-pesa', 'MPESA', 'M-PESA', 'mpesa'];
  }

  bool _narrationMatchesWallet(String narration, List<String> markers) {
    final lower = narration.toLowerCase();
    return markers.any((marker) => lower.contains(marker.toLowerCase()));
  }

  Future<void> _cleanupLocalWalletData(Wallet? wallet) async {
    walletDetailsBloc.add(ClearWalletDetails());

    if (wallet == null) return;

    final hasOtherWalletWithSameName =
        state.wallets.any((w) => w.name == wallet.name);
    if (!hasOtherWalletWithSameName) {
      await appPreferences.removeSupportedBank(wallet.name);
      // Parser / SMS prefs use these aliases for M-Pesa.
      final markers = _walletNarrationMarkers(wallet);
      for (final marker in markers) {
        await appPreferences.removeSupportedBank(marker);
      }
    }
  }

  /// Prefer in-memory txs; fall back to SQLite. Skip empty lists so Home
  /// totals are never wiped while TransactionsBloc is still loading.
  Future<void> _syncHomeCardFromAvailableTransactions(
    List<Wallet> wallets,
  ) async {
    var txs = transactionsBloc.state.transactions;
    if (txs.isEmpty) {
      final cached = await localCache.loadTransactions();
      txs = cached?.transactions ?? const [];
    }
    if (txs.isEmpty) return;
    dataBloc.add(SyncCardDataFromTransactions(
      transactions: txs,
      wallets: wallets,
    ));
  }

  static List<Currency> _defaultCurrencies() => const [
        Currency(id: 1, name: 'Kenyan Shilling', symbol: 'KES'),
        Currency(id: 2, name: 'US Dollar', symbol: 'USD'),
      ];

  static List<Currency> _ensureKesAndUsd(List<Currency> incoming) {
    final bySymbol = <String, Currency>{};
    for (final c in incoming) {
      final symbol = c.symbol.trim().toUpperCase();
      if (symbol.isEmpty) continue;
      bySymbol[symbol] = c.copyWith(symbol: symbol);
    }
    // Always expose clean KES / USD labels (avoid "US Dollar (KES)" mangling).
    bySymbol['KES'] = Currency(
      id: bySymbol['KES']?.id ?? 1,
      name: 'Kenyan Shilling',
      symbol: 'KES',
    );
    bySymbol['USD'] = Currency(
      id: bySymbol['USD']?.id ?? 2,
      name: 'US Dollar',
      symbol: 'USD',
    );
    // Prefer KES then USD then others.
    final ordered = <Currency>[];
    if (bySymbol.containsKey('KES')) ordered.add(bySymbol.remove('KES')!);
    if (bySymbol.containsKey('USD')) ordered.add(bySymbol.remove('USD')!);
    ordered.addAll(bySymbol.values);
    return ordered;
  }

  static bool _isLegacyOneWalletPerBankError(String message) {
    final m = message.toLowerCase();
    return m.contains('already has a wallet with this bank') ||
        m.contains('the user already has a wallet') ||
        m.contains('wallet with this bank already exists');
  }

  Map<String, dynamic> _walletUpdatePayload(Wallet wallet, int bankId) {
    return {
      'institution_name': wallet.institutionName ?? wallet.name,
      'account_name': wallet.accountName ?? '',
      'account_number': wallet.accountNumber,
      'account_type': wallet.accountType ?? '',
      'currency': (wallet.currency ?? 'KES').toUpperCase(),
      'bank_id': bankId,
    };
  }

  /// Old servers reject a second wallet for the same bank_id. Park the
  /// existing row on another bank, create the new currency wallet, restore.
  Future<String?> _createSecondCurrencyWallet({
    required int bankId,
    required String currency,
    required Map<String, dynamic> payload,
  }) async {
    Wallet? existing;
    for (final w in state.wallets) {
      if (w.bankId == bankId) {
        existing = w;
        break;
      }
    }
    if (existing == null) return null;

    Bank? parkingBank;
    for (final b in state.banks) {
      if (b.id != bankId) {
        parkingBank = b;
        break;
      }
    }
    if (parkingBank == null) return null;

    final parkRes = await walletsService.updateWallet(
      existing.id,
      _walletUpdatePayload(existing, parkingBank.id),
    );
    var parkedOk = false;
    parkRes.when(
      onError: (_) {},
      onSuccess: (_) => parkedOk = true,
    );
    if (!parkedOk) return null;

    final createRes = await walletsService.saveWallet(payload);
    String? successMessage;
    var createdOk = false;
    createRes.when(
      onError: (_) {},
      onSuccess: (msg) {
        createdOk = true;
        successMessage = msg;
      },
    );

    // Always restore the original KES (or other) wallet bank link.
    final restoreRes = await walletsService.updateWallet(
      existing.id,
      _walletUpdatePayload(existing, bankId),
    );
    var restoredOk = false;
    restoreRes.when(
      onError: (_) {},
      onSuccess: (_) => restoredOk = true,
    );

    if (!createdOk) return null;
    if (!restoredOk) {
      debugPrint(
        'Created $currency wallet for bank $bankId but failed to restore '
        'existing wallet ${existing.id} bank_id',
      );
    }
    return successMessage ??
        (currency == 'USD'
            ? 'Dollar account added successfully'
            : 'Wallet stored successfully');
  }
}
