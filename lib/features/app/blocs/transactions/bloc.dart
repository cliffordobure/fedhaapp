import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fedha/data/local/transaction_merge.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';

import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  late TransactionsService transactionsService;
  late LocalDataCache localCache;
  final IncomeBloc incomeBloc;
  final ExpenseBloc expenseBloc;
  final DataBloc dataBloc;
  StreamSubscription? _localTxSub;

  TransactionsBloc(this.incomeBloc, this.expenseBloc, this.dataBloc)
      : super(const TransactionsState()) {
    transactionsService = service<TransactionsService>();
    localCache = service<LocalDataCache>();
    _localTxSub = localCache.localTransactionUpdates.listen((txs) {
      add(AddLocalTransactions(transactions: txs));
    });

    // Create new transaction
    on<UploadTransaction>((event, emit) async {
      // Local-first: show on Home immediately, then queue cloud in background.
      final payload = event.data.datetime == null
          ? event.data.copyWith(datetime: DateTime.now())
          : event.data;
      final localRows = LocalDataCache.fromTransactionData([payload]);
      final merged = await localCache.mergeTransactions(
        localRows,
        notify: true,
        pendingSync: true,
        uploadPayloads: [payload],
      );
      // Keep optimistic list on screen; background push must not replace it.
      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        transactions: merged,
        filteredTransactions: merged,
        total: merged.fold<double>(0, (sum, t) => sum + t.amount),
      ));
      _syncHomeTotals(merged);

      showLoading("Saving transaction");
      try {
        // True push-only — syncNow(forcePull:false) still pulls every 2 min
        // and that race can hide the new row until a manual reload.
        await service<SyncEngine>().pushPendingOnly();
        showSuccess("Transaction saved");
      } catch (e) {
        // Still available offline; will sync later.
        showSuccess("Saved offline — will sync when online");
      }
    });

    on<AddLocalTransactions>((event, emit) async {
      if (event.transactions.isEmpty) return;
      // SMS path already upserted + queued the outbox. Re-upserting here with
      // default syncStatus=synced was wiping pending upload state.
      final cached = await localCache.loadTransactions();
      final baseline = mergeTransactionsDeduped(
        state.transactions,
        secondary: cached?.transactions ?? const [],
        preferPrimary: true,
      );
      final merged = mergeTransactionsDeduped(
        event.transactions,
        secondary: baseline,
        preferPrimary: true,
      );
      // Debits may match bills / planned payments / budgets / goals.
      // Only brand-new codes — sync pull notifies with the full list.
      final existingCodes = {
        for (final t in state.transactions) t.transactionId,
      };
      final candidates = event.transactions
          .where((t) =>
              t.type == TransactionType.debit &&
              t.transactionId.trim().isNotEmpty &&
              !existingCodes.contains(t.transactionId))
          .toList();
      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        transactions: merged,
        filteredTransactions: merged,
        total: merged.fold<double>(0, (sum, t) => sum + t.amount),
        pendingAllocationMatches: candidates.isEmpty
            ? state.pendingAllocationMatches
            : [
                ...state.pendingAllocationMatches,
                ...candidates,
              ],
      ));
      _syncHomeTotals(merged);
    });

    on<ClearPendingAllocationMatches>((event, emit) async {
      emit(state.copyWith(pendingAllocationMatches: const []));
    });

    on<ApplyLocalTransactions>((event, emit) async {
      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        transactions: event.transactions,
        filteredTransactions: event.transactions,
        total: event.total,
      ));
      await localCache.saveTransactions(
        event.transactions,
        total: event.total,
      );
      _syncHomeTotals(event.transactions);
    });
    on<UpdateTransaction>(
      (event, emit) async {
        try {
          showLoading("Updating transaction...");

          // Local-first: SMS rows often have negative/temp ids that the
          // cloud does not know yet — always update SQLite by code/id.
          final updatedList = state.transactions.map((tx) {
            final byId =
                event.transactionId > 0 && tx.id == event.transactionId;
            final byCode = (event.transactionCode ?? '').isNotEmpty &&
                tx.transactionId == event.transactionCode;
            if (!byId && !byCode) return tx;
            return tx.copyWith(
              narration: event.narration ?? tx.narration,
              amount: event.amount ?? tx.amount,
              updatedAt: DateTime.now(),
            );
          }).toList(growable: false);

          final total =
              updatedList.fold<double>(0, (sum, t) => sum + t.amount);
          await localCache.saveTransactions(
            updatedList,
            total: total,
            nextPageUrl: state.nextPageUrl,
          );
          emit(state.copyWith(
            hasUpdated: true,
            transactions: updatedList,
            filteredTransactions: updatedList,
            total: total,
          ));
          _syncHomeTotals(updatedList);

          // Cloud update only when we have a real server id.
          if (event.transactionId > 0) {
            final response = await transactionsService.updateTransaction(
              event.transactionId,
              event.narration,
              event.amount,
            );
            await response.when(
              onError: (error) async {
                // Local copy already saved — don't scare the user with 404.
                final msg = (error.error).toLowerCase();
                if (msg.contains('not found') || msg.contains('resource')) {
                  showSuccess("Updated on this device");
                } else {
                  showError(error.error);
                }
              },
              onSuccess: (_) async {
                showSuccess("Transaction updated successfully");
              },
            );
          } else {
            showSuccess("Updated on this device");
          }

          incomeBloc.add(RefreshIncome());
          expenseBloc.add(RefreshExpense());
        } catch (e) {
          debugPrint("Error updating transaction: $e");
          showError("Failed to update transaction");
        }
      },
    );

    on<DeleteTransaction>(
      (event, emit) async {
        try {
          showLoading("Deleting transaction...");

          bool matches(Transaction tx) {
            final byId =
                event.transactionId > 0 && tx.id == event.transactionId;
            final byCode = (event.transactionCode ?? '').isNotEmpty &&
                tx.transactionId == event.transactionCode;
            return byId || byCode;
          }

          // Prefer code from the live list when the event omitted it.
          var code = (event.transactionCode ?? '').trim();
          if (code.isEmpty) {
            for (final tx in state.transactions) {
              if (matches(tx) && tx.transactionId.trim().isNotEmpty) {
                code = tx.transactionId.trim();
                break;
              }
            }
          }

          await localCache.deleteTransactionLocally(
            serverId: event.transactionId > 0 ? event.transactionId : null,
            transactionCode: code.isNotEmpty ? code : null,
          );

          final remaining = state.transactions
              .where((tx) => !matches(tx))
              .toList(growable: false);
          final total =
              remaining.fold<double>(0, (sum, t) => sum + t.amount);

          await localCache.saveTransactions(
            remaining,
            total: total,
            nextPageUrl: state.nextPageUrl,
          );

          emit(state.copyWith(
            transactions: remaining,
            filteredTransactions: remaining,
            total: total,
          ));
          _syncHomeTotals(remaining);

          if (event.transactionId > 0) {
            final response = await transactionsService
                .deleteTransaction(event.transactionId);
            response.when(
              onError: (error) {
                final msg = error.error.toLowerCase();
                if (msg.contains('not found') || msg.contains('resource')) {
                  showSuccess("Deleted on this device");
                } else {
                  // Local delete already stuck; warn but keep device clean.
                  showSuccess(
                    "Removed on this device. Cloud delete failed: ${error.error}",
                  );
                }
              },
              onSuccess: (data) {
                showSuccess(
                  data.trim().isNotEmpty
                      ? data
                      : "Transaction deleted successfully",
                );
              },
            );
          } else {
            showSuccess("Deleted on this device");
          }

          incomeBloc.add(RefreshIncome());
          expenseBloc.add(RefreshExpense());
        } catch (e) {
          debugPrint("Error deleting transaction: $e");
          showError("Failed to delete transaction");
        }
      },
    );

    on<UpdateCategory>((event, emit) async {
      debugPrint("This is the transaction ID: ${event.transactionId}");

      final idAsInt = int.tryParse(event.transactionId) ?? 0;

      // Local-first: apply category on device immediately, then sync to cloud.
      final updatedList = state.transactions.map((tx) {
        final byId = idAsInt != 0 && tx.id == idAsInt;
        final byCode = tx.transactionId == event.transactionId ||
            tx.id.toString() == event.transactionId;
        if (!byId && !byCode) return tx;
        return tx.copyWith(
          categoryId: event.categoryId,
          subcategoryId: event.subcategoryId,
          updatedAt: DateTime.now(),
        );
      }).toList(growable: false);

      final total = updatedList.fold<double>(0, (sum, t) => sum + t.amount);
      await localCache.saveTransactions(
        updatedList,
        total: total,
        nextPageUrl: state.nextPageUrl,
      );
      if (!emit.isDone) {
        emit(state.copyWith(
          transactions: updatedList,
          filteredTransactions: updatedList,
          total: total,
        ));
      }
      _syncHomeTotals(updatedList);
      showSuccess("Category Updated");

      // Cloud sync by transaction code (SMS refs) or numeric PK.
      final shouldSyncCloud = event.transactionId.trim().isNotEmpty &&
          (idAsInt > 0 || !event.transactionId.startsWith('local_'));
      if (shouldSyncCloud) {
        final response = await transactionsService.updateCategory(
            event.categoryId, event.subcategoryId, event.transactionId);

        await response.when(
          onError: ((error) async {
            final msg = (error.error).toLowerCase();
            if (!msg.contains('not found') && !msg.contains('resource')) {
              showError(error.error);
            }
          }),
          onSuccess: (data) async {
            // Optional refresh from server; keep local if pull fails.
            try {
              final transactionsResponse =
                  await transactionsService.fetchTransactions();
              await transactionsResponse.when(
                onError: (_) async {},
                onSuccess: (response) async {
                  await localCache.saveTransactions(
                    response.data,
                    total: response.totalAmount ?? 0,
                    nextPageUrl: response.nextPageUrl,
                  );
                  if (!emit.isDone) {
                    emit(state.copyWith(
                      transactions: response.data,
                      total: response.totalAmount ?? 0,
                      filteredTransactions: response.data,
                      nextPageUrl: response.nextPageUrl,
                      hasMoreData: response.nextPageUrl != null,
                    ));
                  }
                },
              );
            } catch (_) {}
          },
        );
      }

      incomeBloc.add(RefreshIncome());
      expenseBloc.add(RefreshExpense());
    });

    on<StartTransactions>((event, emit) async {
      // 1) Paint from local cache immediately when available.
      try {
        final cached = await localCache.loadTransactions();
        if (cached != null && cached.transactions.isNotEmpty) {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            transactions: cached.transactions,
            filteredTransactions: cached.transactions,
            total: cached.total,
            nextPageUrl: cached.nextPageUrl,
            hasMoreData: cached.nextPageUrl != null,
          ));
          _syncHomeTotals(cached.transactions);
        } else {
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            transactions: const [],
            filteredTransactions: const [],
            total: 0,
            hasMoreData: false,
          ));
        }
      } catch (e) {
        // Corrupt/locked local DB must not block Home — pull from cloud next.
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          transactions: const [],
          filteredTransactions: const [],
          total: 0,
          hasMoreData: false,
        ));
      }

      // Load expenses / incomes in parallel with sync.
      expenseBloc.add(LoadCategories());
      incomeBloc.add(FetchIncomeTypes());

      // 2) Full pull (+ push) via SyncEngine, then re-read local DB.
      await service<SyncEngine>().syncNow(forcePull: true);
      var synced = await localCache.loadTransactions();
      if ((synced == null || synced.transactions.isEmpty) &&
          state.transactions.isEmpty) {
        // One retry if the first cycle raced with another sync.
        await service<SyncEngine>().syncNow(forcePull: true);
        synced = await localCache.loadTransactions();
      }
      if (synced != null && synced.transactions.isNotEmpty) {
        // Preserve any txs added while this start/sync was in flight.
        final kept = mergeTransactionsDeduped(
          synced.transactions,
          secondary: state.transactions,
          preferPrimary: true,
        );
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          transactions: kept,
          filteredTransactions: kept,
          total: kept.fold<double>(0, (sum, t) => sum + t.amount),
          nextPageUrl: synced.nextPageUrl,
          hasMoreData: synced.nextPageUrl != null,
        ));
        _syncHomeTotals(kept);
      } else if (state.transactions.isNotEmpty) {
        // Keep in-memory rows if the pull came back empty.
        _syncHomeTotals(state.transactions);
      } else {
        // New / empty accounts are valid — not a load failure.
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          transactions: const [],
          filteredTransactions: const [],
          total: 0,
          hasMoreData: false,
        ));
        _syncHomeTotals(const []);
      }
    });

// RefreshTransactions
    on<RefreshTransactions>((event, emit) async {
      // Always paint from local DB first (single source of truth).
      final cached = await localCache.loadTransactions();
      final localBaseline = mergeTransactionsDeduped(
        state.transactions,
        secondary: cached?.transactions ?? const [],
        preferPrimary: true,
      );
      if (localBaseline.isNotEmpty) {
        final total =
            localBaseline.fold<double>(0, (sum, t) => sum + t.amount);
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          transactions: localBaseline,
          filteredTransactions: localBaseline,
          total: total,
        ));
        _syncHomeTotals(localBaseline);
      }

      // Await full multi-page sync so today's cloud txs are not lost to a
      // page-1-only overwrite race.
      await service<SyncEngine>().syncNow(forcePull: true);
      final synced = await localCache.loadTransactions();
      final refreshed = mergeTransactionsDeduped(
        synced?.transactions ?? const [],
        secondary: localBaseline,
        preferPrimary: true,
      );
      if (refreshed.isNotEmpty) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          transactions: refreshed,
          filteredTransactions: refreshed,
          total: refreshed.fold<double>(0, (sum, t) => sum + t.amount),
          nextPageUrl: synced?.nextPageUrl,
          hasMoreData: synced?.nextPageUrl != null,
        ));
        _syncHomeTotals(refreshed);
      } else if (localBaseline.isEmpty && state.transactions.isEmpty) {
        showError('Unable to refresh transactions');
      }
    });

    on<LoadNextPageEvent>((event, emit) async {
      if (state.hasMoreData) {
        emit(state.copyWith(loadNextstatus: ServiceStatus.loading));
        final nextPageResponse = await transactionsService.fetchTransactions(
            page: state.currentPage + 1);

        nextPageResponse.when(onError: (error) {
          // Handle error if needed...
          emit(
            state.copyWith(
              loadNextstatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error(error.error),
            ),
          );
        }, onSuccess: (response) {
          // Merge the new page data with the existing data
          final allTransactions = List.of(state.transactions)
            ..addAll(response.data);

          emit(
            state.copyWith(
                currentPage: state.currentPage + 1,
                transactions: allTransactions,
                filteredTransactions: allTransactions,
                nextPageUrl: response.nextPageUrl,
                hasMoreData: response.nextPageUrl != null,
                loadNextstatus: ServiceStatus.loadingSuccess),
          );
        });
      }
    });

    on<ClearTransactions>((event, emit) {
      emit(const TransactionsState());
      // Refresh transactions
      add(StartTransactions());
    });

    on<FilterTransactions>((event, emit) {
      if (event.keyword != null && event.keyword!.trim().isNotEmpty) {
        emit(state.copyWith(
            filteredTransactions: state.transactions
                .where((element) =>
                    element.toJson().toString().contains(event.keyword!))
                .toList()));
      } else {
        emit(state.copyWith(filteredTransactions: state.transactions));
      }
    });

    on<ToggleCategorySelected>((event, emit) =>
        emit(state.copyWith(categorySelected: event.selected)));

    // filter
    on<FilterByType>((event, emit) {
      if (event.filter == TransactionsFilter.CREDIT) {
        emit(state.copyWith(
            currentFilter: event.filter,
            filteredTransactions: state.transactions
                .where((element) => element.type == TransactionType.credit)
                .toList()));
      } else if (event.filter == TransactionsFilter.DEBIT) {
        emit(state.copyWith(
            currentFilter: event.filter,
            filteredTransactions: state.transactions
                .where((element) => element.type == TransactionType.debit)
                .toList()));
      } else {
        emit(state.copyWith(
            currentFilter: event.filter,
            filteredTransactions: state.transactions));
      }
    });

    // Create multiple new transactions
    on<UploadMultipleTransaction>((event, emit) async {
      // showLoading("Saving Multiple transactions");
      if (!state.hasUpdated) {
        final res =
            await transactionsService.saveMultipleTransactions(event.data);

        res.when(onError: (error) {
          // showError(error.error);
        }, onSuccess: (data) {
          emit(state.copyWith(
            hasUpdated: true,
          ));
        });
        // walletsBloc.add(UpdateWalletSms());
        // refresh transaction
        add(RefreshTransactions());
        incomeBloc.add(RefreshIncome());
        expenseBloc.add(RefreshExpense());
      }
    });
  }

  /// Keep optimistic / SMS rows that the server has not ingested yet.
  /// Never keep both a local copy and a server copy of the same payment.
  List<Transaction> _mergeServerWithLocal(
    List<Transaction> server,
    List<Transaction> local,
  ) {
    return mergeTransactionsDeduped(
      server,
      secondary: local,
      preferPrimary: true,
    );
  }

  void _syncHomeTotals(List<Transaction> transactions) {
    dataBloc.add(SyncCardDataFromTransactions(transactions: transactions));
  }

  @override
  Future<void> close() {
    _localTxSub?.cancel();
    return super.close();
  }
}
