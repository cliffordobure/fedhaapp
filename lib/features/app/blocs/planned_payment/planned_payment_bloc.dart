import 'package:fedha/data/local/planned_payment_progress.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/planned_payment/planned_payment_request.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/utils/notifications_service/notification_service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/data/error/failure.dart';

import 'package:fedha/data/services/service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_payment_bloc.freezed.dart';
part 'planned_payment_event.dart';
part 'planned_payment_state.dart';

class PlannedPaymentBloc
    extends Bloc<PlannedPaymentEvent, PlannedPaymentState> {
  late PlannedPaymentService _plannedPaymentService;
  late LocalDataCache _cache;

  PlannedPaymentBloc() : super(const PlannedPaymentState()) {
    _plannedPaymentService = service<PlannedPaymentService>();
    _cache = service<LocalDataCache>();

    on<_PlannedPaymentFetched>((event, emit) async {
      final cached = await _cache.loadPlannedPayments();
      if (cached != null && cached.isNotEmpty) {
        emit(PlannedPaymentState(
          status: PlannedPaymentStatus.success,
          plannedPayments: cached,
        ));
      } else {
        emit(const PlannedPaymentState(status: PlannedPaymentStatus.loading));
      }

      final plannedPaymentRes =
          await _plannedPaymentService.fetchPlannedPayment();

      await plannedPaymentRes.when(onError: (error) async {
        if (cached == null || cached.isEmpty) {
          emit(PlannedPaymentState(
              status: PlannedPaymentStatus.failure, failure: error));
        }
      }, onSuccess: (plannedPayments) async {
        await _cache.savePlannedPayments(plannedPayments);
        emit(PlannedPaymentState(
            status: PlannedPaymentStatus.success,
            plannedPayments: plannedPayments));

        final prefs = service<AppPreferences>();
        if (await prefs.isPlannePaymentsnotifScheduled() == false &&
            plannedPayments.isNotEmpty) {
          try {
            for (final payment in plannedPayments) {
              if (payment.id == null || payment.id! <= 0) continue;
              await NotificationService.schedulePlannedPaymentNotification(
                  id: payment.id!,
                  name: payment.name,
                  amount: payment.amount,
                  paymentDate: payment.paymentDate,
                  frequency: payment.frequency,
                  userid: payment.userId);
            }
            await prefs.setPlannePaymentsnotifScheduled(true);
          } catch (_) {
            // Reminder scheduling must never break planned-payment save/load.
          }
        }
      });
    });

    on<_PlannedPaymentAdded>((event, emit) async {
      final now = DateTime.now().toIso8601String();
      final tempId = _cache.nextTempLocalId();
      final optimistic = PlannedPayment(
        id: tempId,
        userId: 0,
        name: event.request.name,
        categoryId: event.request.categoryId,
        subcategoryId: event.request.subcategoryId,
        paymentDate: event.request.paymentDate,
        amount: event.request.amount,
        frequency: event.request.frequency,
        status: 'pending',
        createdAt: now,
        updatedAt: now,
        category: Category(
          id: event.request.categoryId,
          name: 'Category',
          type: 1,
          status: 1,
          createdAt: now,
          updatedAt: now,
        ),
        subcategory: event.request.subcategoryId > 0
            ? Subcategory(
                id: event.request.subcategoryId,
                name: 'Subcategory',
                categoryId: event.request.categoryId,
                status: 1,
                createdAt: now,
                updatedAt: now,
              )
            : null,
        paymentHistory: const [],
      );

      final existing = await _cache.loadPlannedPayments() ?? state.plannedPayments;
      final merged = [optimistic, ...existing];
      await _cache.savePlannedPayments(merged);
      await _cache.enqueuePlanningOp(
        entityType: 'planned_payment',
        op: 'create',
        entityKey: 'pp_create_$tempId',
        body: event.request.toJson(),
      );

      emit(PlannedPaymentState(
        status: PlannedPaymentStatus.success,
        plannedPayments: merged,
      ));
      showSuccess('Payment saved — syncing…');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(const PlannedPaymentEvent.fetched());
    });

    on<_PlannedPaymentUpdated>((event, emit) async {
      final existing = await _cache.loadPlannedPayments() ?? state.plannedPayments;
      final updated = existing.map((p) {
        if (p.id != event.id) return p;
        return p.copyWith(
          name: event.request.name,
          categoryId: event.request.categoryId,
          subcategoryId: event.request.subcategoryId,
          paymentDate: event.request.paymentDate,
          amount: event.request.amount,
          frequency: event.request.frequency,
          updatedAt: DateTime.now().toIso8601String(),
        );
      }).toList();
      await _cache.savePlannedPayments(updated);
      await _cache.enqueuePlanningOp(
        entityType: 'planned_payment',
        op: 'update',
        entityKey: 'pp_update_${event.id}',
        serverId: event.id,
        body: event.request.toJson(),
      );

      emit(PlannedPaymentState(
        status: PlannedPaymentStatus.success,
        plannedPayments: updated,
      ));
      showSuccess('Planned payment updated');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(const PlannedPaymentEvent.fetched());
    });

    on<_PlannedPaymentDeleted>((event, emit) async {
      final existing = await _cache.loadPlannedPayments() ?? state.plannedPayments;
      final remaining = existing.where((p) => p.id != event.id).toList();
      await _cache.savePlannedPayments(remaining);
      await _cache.enqueuePlanningOp(
        entityType: 'planned_payment',
        op: 'delete',
        entityKey: 'pp_delete_${event.id}',
        serverId: event.id,
      );

      emit(PlannedPaymentState(
        status: PlannedPaymentStatus.success,
        plannedPayments: remaining,
      ));
      showSuccess('Payment deleted');
      if (event.id > 0) {
        await NotificationService.cancelNotification(event.id);
      }
      await service<SyncEngine>().syncNow(forcePull: false);
    });

    on<_PlannedPaymentDetailFetched>((event, emit) async {
      // Prefer SQLite list cache so the detail screen never waits on network.
      PlannedPayment? cached;
      final localList = await _cache.loadPlannedPayments() ?? state.plannedPayments;
      for (final p in localList) {
        if (p.id == event.id) {
          cached = p;
          break;
        }
      }
      if (cached == null && state.plannedPayment?.id == event.id) {
        cached = state.plannedPayment;
      }

      if (cached != null) {
        emit(state.copyWith(
          status: PlannedPaymentStatus.success,
          plannedPayments: localList,
          plannedPayment: cached,
        ));
      } else {
        emit(state.copyWith(status: PlannedPaymentStatus.loading));
      }

      if (event.id <= 0) {
        // Temp/offline-only row — nothing to fetch from cloud.
        return;
      }

      final res =
          await _plannedPaymentService.plannedPaymentDetails(id: event.id);
      await res.when(
        onError: (error) async {
          if (cached == null) {
            emit(PlannedPaymentState(
                status: PlannedPaymentStatus.failure, failure: error));
          }
        },
        onSuccess: (detail) async {
          // Merge into local list cache.
          final updatedList = <PlannedPayment>[
            for (final p in localList)
              if (p.id == detail.id) detail else p,
          ];
          if (!updatedList.any((p) => p.id == detail.id)) {
            updatedList.insert(0, detail);
          }
          await _cache.savePlannedPayments(updatedList);
          emit(state.copyWith(
            status: PlannedPaymentStatus.success,
            plannedPayments: updatedList,
            plannedPayment: detail,
          ));
        },
      );
    });

    on<_PlannedPaymentHistoryAdded>((event, emit) async {
      // Local-first: append history on device, queue cloud mark-as-paid.
      final list = await _cache.loadPlannedPayments() ?? state.plannedPayments;
      PlannedPayment? current;
      for (final p in list) {
        if (p.id == event.id) {
          current = p;
          break;
        }
      }
      if (current == null) return;

      // One mark-as-paid per cycle (once / day / week / month).
      final links = await _cache.loadLinksForEntity(
        entityType: AllocationEntityType.plannedPayment,
        entityId: event.id,
      );
      final linkedTotal =
          links.fold<double>(0, (sum, l) => sum + l.linkedAmount.abs());
      if (!canMarkPlannedPaymentPaid(
        payment: current,
        linkedTotal: linkedTotal,
      )) {
        emit(state.copyWith(
          status: PlannedPaymentStatus.success,
          plannedPayments: list,
          plannedPayment: current,
        ));
        showSuccess('Already marked as paid for this period');
        return;
      }

      final now = DateTime.now().toIso8601String();
      final historyEntry = PaymentHistory(
        id: _cache.nextTempLocalId(),
        plannedPaymentsId: event.id,
        amount: event.request.amount,
        paidAt: event.request.paidAt,
        userId: event.request.userId,
        createdAt: now,
        updatedAt: now,
      );

      PlannedPayment? updatedPayment;
      final updatedList = list.map((p) {
        if (p.id != event.id) return p;
        final histories = <PaymentHistory?>[
          ...(p.paymentHistory ?? const <PaymentHistory?>[]),
          historyEntry,
        ];
        updatedPayment = p.copyWith(paymentHistory: histories);
        return updatedPayment!;
      }).toList();

      if (updatedPayment != null) {
        await _cache.savePlannedPayments(updatedList);
        // Recompute paid / partially_paid from history + any linked txs.
        final progress = await refreshPlannedPaymentLinkStatus(
          cache: _cache,
          plannedPaymentId: event.id,
        );
        final refreshed = await _cache.loadPlannedPayments() ?? updatedList;
        PlannedPayment? latest;
        for (final p in refreshed) {
          if (p.id == event.id) {
            latest = p;
            break;
          }
        }
        emit(state.copyWith(
          status: PlannedPaymentStatus.success,
          plannedPayments: refreshed,
          plannedPayment: latest ?? updatedPayment,
        ));
        if (progress?.isPaid == true) {
          showSuccess('Fully paid');
        } else if (progress?.isPartial == true) {
          showSuccess('Partially paid');
        } else {
          showSuccess('Payment recorded');
        }
      }

      await _cache.enqueuePlanningOp(
        entityType: 'planned_payment',
        op: 'mark_paid',
        entityKey: 'pp_paid_${event.id}_${DateTime.now().millisecondsSinceEpoch}',
        serverId: event.id,
      );
      await service<SyncEngine>().syncNow(forcePull: false);
    });
  }
}
