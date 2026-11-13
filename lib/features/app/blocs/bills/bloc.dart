import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/bills/bills.dart';
import 'package:fedha/data/models/bills/bill_types.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part "state.dart";
part 'event.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  late BillService billsService;
  late LocalDataCache _cache;

  BillsBloc() : super(const BillsState()) {
    billsService = service<BillService>();
    _cache = service<LocalDataCache>();

    on<StartBillsBloc>((BillsEvent event, Emitter<BillsState> emit) async {
      final cached = await _cache.loadUserBills();
      if (cached != null) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          span: FinancialSpan.weekly,
          selected: cached.weekly,
          bill: cached,
        ));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await billsService.fetchUserBills();
      await res.when(
        onError: (error) async {
          if (cached == null) {
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)));
          }
        },
        onSuccess: (server) async {
          final data = BillService.mergePendingBills(
              server, await _cache.loadUserBills());
          await _cache.saveUserBills(data);
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            span: FinancialSpan.weekly,
            selected: data.weekly,
            bill: data,
          ));
        },
      );
    });

    on<RefreshBills>((event, emit) async {
      final res = await billsService.fetchUserBills();
      await res.when(
        onError: (error) async {
          // Keep local snapshot — don't spin forever.
        },
        onSuccess: (server) async {
          final data = BillService.mergePendingBills(
              server, await _cache.loadUserBills());
          await _cache.saveUserBills(data);
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            selected: _spanOf(data, state.span),
            bill: data,
          ));
        },
      );
    });

    on<NewBillForm>((BillsEvent event, Emitter<BillsState> emit) async {
      emit(state.copyWith(formStatus: ServiceStatus.loading));
      final res = await billsService.fetchBillTypes();
      res.when(onError: (error) {
        emit(state.copyWith(
          formStatus: ServiceStatus.loadingSuccess,
          billTypes: state.billTypes.isNotEmpty
              ? state.billTypes
              : _fallbackBillTypes,
        ));
      }, onSuccess: (data) {
        emit(state.copyWith(
          formStatus: ServiceStatus.loadingSuccess,
          billTypes: data.isNotEmpty ? data : _fallbackBillTypes,
        ));
      });
    });

    on<SpanSelected>((event, emit) {
      final bill = state.bill;
      if (bill == null) {
        emit(state.copyWith(span: event.span));
        return;
      }
      emit(state.copyWith(
          span: event.span, selected: _spanOf(bill, event.span)));
    });

    on<NewBill>((event, emit) async {
      final tempId = _cache.nextTempLocalId();
      final amount =
          num.tryParse('${event.data['amount'] ?? 0}')?.round() ?? 0;
      final name = '${event.data['name'] ?? 'Bill'}';
      final typeName = '${event.data['bill_type_name'] ?? ''}';
      final targetSpan = _spanForTypeName(typeName);
      final optimisticBill = Bill(
        id: tempId,
        name: name,
        img: '',
        wallet: '${event.data['wallet'] ?? ''}',
        amount: amount,
      );

      final current = await _cache.loadUserBills() ?? state.bill ?? _emptyBills;
      final updated = _replaceSpan(
        current,
        targetSpan,
        (span) => BillSpan(
          totalAmount: span.totalAmount + amount,
          bills: [optimisticBill, ...span.bills],
        ),
        allTotalDelta: amount,
      );
      await _cache.saveUserBills(updated);
      await _cache.enqueuePlanningOp(
        entityType: 'bill',
        op: 'create',
        entityKey: 'bill_create_$tempId',
        body: {
          'name': name,
          'bill_type': event.data['bill_type'],
          'wallet_id': event.data['wallet_id'],
          'amount': amount,
        },
      );

      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        bill: updated,
        selected: _spanOf(updated, targetSpan),
        span: targetSpan,
      ));
      showSuccess('Bill saved — syncing…');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(RefreshBills());
    });

    on<EditBill>((event, emit) async {
      final current = await _cache.loadUserBills() ?? state.bill;
      final amount = num.tryParse('${event.data['amount'] ?? ''}')?.round();
      if (current != null && amount != null) {
        BillSpan patch(BillSpan span) {
          final bills = span.bills
              .map((b) => b.id == event.id
                  ? Bill(
                      id: b.id,
                      name: b.name,
                      img: b.img,
                      wallet: '${event.data['wallet'] ?? b.wallet}',
                      amount: amount,
                    )
                  : b)
              .toList();
          final total =
              bills.fold<double>(0, (s, b) => s + b.amount.toDouble());
          return BillSpan(totalAmount: total, bills: bills);
        }

        final updated = UserBill(
          allTotalAmount: current.allTotalAmount,
          weekly: patch(current.weekly),
          monthly: patch(current.monthly),
          annually: patch(current.annually),
        );
        await _cache.saveUserBills(updated);
        emit(state.copyWith(
          bill: updated,
          selected: _spanOf(updated, state.span),
        ));
      }

      if (event.id < 0) {
        // Not on the server yet: rewrite the queued create instead.
        await _cache.enqueuePlanningOp(
          entityType: 'bill',
          op: 'create',
          entityKey: 'bill_create_${event.id}',
          body: {
            'name': event.data['name'],
            'bill_type': event.data['bill_type'],
            'wallet_id': event.data['wallet_id'],
            'amount': amount ?? event.data['amount'],
          },
        );
      } else {
        await _cache.enqueuePlanningOp(
          entityType: 'bill',
          op: 'update',
          entityKey: 'bill_update_${event.id}',
          serverId: event.id,
          body: {
            'bill_type': event.data['bill_type'],
            'wallet_id': event.data['wallet_id'],
            'amount': amount ?? event.data['amount'],
          },
        );
      }
      showSuccess('Bill updated — syncing…');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(RefreshBills());
    });

    on<DeleteBill>((event, emit) async {
      final current = await _cache.loadUserBills() ?? state.bill;
      if (current != null) {
        BillSpan strip(BillSpan span) {
          final bills = span.bills.where((b) => b.id != event.id).toList();
          final total =
              bills.fold<double>(0, (s, b) => s + b.amount.toDouble());
          return BillSpan(totalAmount: total, bills: bills);
        }

        final updated = UserBill(
          allTotalAmount: current.allTotalAmount,
          weekly: strip(current.weekly),
          monthly: strip(current.monthly),
          annually: strip(current.annually),
        );
        await _cache.saveUserBills(updated);
        emit(state.copyWith(
          bill: updated,
          selected: _spanOf(updated, state.span),
        ));
      }

      if (event.id < 0) {
        await _cache.removePlanningOp(
            entityType: 'bill', entityKey: 'bill_create_${event.id}');
      } else {
        await _cache.enqueuePlanningOp(
          entityType: 'bill',
          op: 'delete',
          entityKey: 'bill_delete_${event.id}',
          serverId: event.id,
        );
      }
      showSuccess('Bill deleted');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(RefreshBills());
    });

    on<RefreshBillTypes>((event, emit) async {
      final res = await billsService.fetchBillTypes();
      res.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        showSuccess('Bill type saved');
        emit(state.copyWith(billTypes: data));
      });
    });

    on<NewBillType>((event, emit) async {
      showLoading('Saving...');
      emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));
      final res = await billsService.saveNewBillType({'name': event.name});

      res.when(onError: (error) {
        showError(error.error);
        emit(state.copyWith(
            formStatus: ServiceStatus.loadingFailure,
            message: ApplicationMessage.fromFailure(error)));
      }, onSuccess: (data) {
        showSuccess(data);
        emit(state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            message: ApplicationMessage.success(data)));
        add(RefreshBillTypes());
      });
    });
  }

  static const _emptyBills = UserBill(
    allTotalAmount: 0,
    weekly: BillSpan(totalAmount: 0, bills: []),
    monthly: BillSpan(totalAmount: 0, bills: []),
    annually: BillSpan(totalAmount: 0, bills: []),
  );

  /// Mirrors the server's `bills/types` ids, used when that call fails.
  static const _fallbackBillTypes = [
    BillType(id: 1, name: 'Weekly', status: 1, createdAt: '', updatedAt: ''),
    BillType(id: 2, name: 'Monthly', status: 1, createdAt: '', updatedAt: ''),
    BillType(id: 3, name: 'Annually', status: 1, createdAt: '', updatedAt: ''),
  ];

  static FinancialSpan _spanForTypeName(String name) {
    final n = name.toLowerCase();
    if (n.startsWith('month')) return FinancialSpan.monthly;
    if (n.startsWith('annual') || n.startsWith('year')) {
      return FinancialSpan.yearly;
    }
    return FinancialSpan.weekly;
  }

  static BillSpan _spanOf(UserBill bill, FinancialSpan? span) {
    switch (span) {
      case FinancialSpan.monthly:
        return bill.monthly;
      case FinancialSpan.yearly:
        return bill.annually;
      default:
        return bill.weekly;
    }
  }

  static UserBill _replaceSpan(
    UserBill bill,
    FinancialSpan span,
    BillSpan Function(BillSpan) change, {
    int allTotalDelta = 0,
  }) {
    return UserBill(
      allTotalAmount: bill.allTotalAmount + allTotalDelta,
      weekly: span == FinancialSpan.weekly ? change(bill.weekly) : bill.weekly,
      monthly:
          span == FinancialSpan.monthly ? change(bill.monthly) : bill.monthly,
      annually:
          span == FinancialSpan.yearly ? change(bill.annually) : bill.annually,
    );
  }
}
