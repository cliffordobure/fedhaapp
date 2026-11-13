import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/payment_history_store.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/utils/utils.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc() : super(const GoalsState()) {
    final cache = service<LocalDataCache>();
    final planning = service<PlanningService>();

    on<FetchAllGoalsEvent>((event, emit) async {
      final cached = await cache.loadGoals();
      if (cached != null && cached.isNotEmpty) {
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess, goals: cached));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await planning.getGoals();
      await res.when(
        onError: ((error) async {
          if (cached == null || cached.isEmpty) {
            showError(error.error);
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.error(error.error)));
          }
        }),
        onSuccess: ((server) async {
          final data = await cache.mergeServerGoalsWithPending(server);
          await cache.saveGoals(data);
          Goals? selected;
          for (final g in data) {
            if (g.id == state.goal?.id) selected = g;
          }
          emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            goals: data,
            goal: selected ?? state.goal,
          ));
        }),
      );
    });

    on<FetchGoalEvent>((event, emit) async {
      Goals? local;
      for (final g in state.goals ?? const <Goals>[]) {
        if (g.id == event.goalId) {
          local = g;
          break;
        }
      }
      if (local != null) {
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess, goal: local));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await planning.getSpecificGoals(event.goalId);
      await res.when(
        onError: ((error) async {
          if (local == null) {
            showError(error.error);
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.error(error.error)));
          }
        }),
        onSuccess: ((data) async {
          final merged = await cache.mergeServerGoalsWithPending([data]);
          emit(state.copyWith(
              status: ServiceStatus.loadingSuccess, goal: merged.first));
        }),
      );
    });

    on<AddGoalsEvent>((event, emit) async {
      final tempId = cache.nextTempLocalId();
      final optimistic = Goals(
        id: tempId,
        name: '${event.goal['name'] ?? ''}',
        desiredDate: DateTime.tryParse('${event.goal['desired_date'] ?? ''}'),
        targetAmount: (event.goal['target_amount'] as num?)?.toDouble(),
        amountSaved: (event.goal['amount_saved'] as num?)?.toDouble(),
        color: event.goal['color']?.toString(),
        icon: event.goal['icon']?.toString(),
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final existing = await cache.loadGoals() ?? state.goals ?? <Goals>[];
      final merged = [optimistic, ...existing];
      await cache.saveGoals(merged);
      await cache.enqueuePlanningOp(
        entityType: 'goal',
        op: 'create',
        entityKey: 'goal_create_$tempId',
        body: event.goal,
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, goals: merged));
      showSuccess('Goal saved — syncing…');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllGoalsEvent());
    });

    on<UpdateGoalStatusEvent>((event, emit) async {
      final existing = await cache.loadGoals() ?? state.goals ?? <Goals>[];
      final updated = existing
          .map((g) =>
              g.id == event.goalId ? g.copyWith(status: event.status) : g)
          .toList();
      await cache.saveGoals(updated);
      await cache.enqueuePlanningOp(
        entityType: 'goal',
        op: 'status',
        entityKey: 'goal_status_${event.goalId}',
        serverId: event.goalId,
        body: {'status': event.status},
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, goals: updated));
      showSuccess('Goal updated');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllGoalsEvent());
    });

    on<UpdateGoalEvent>((event, emit) async {
      final existing = await cache.loadGoals() ?? state.goals ?? <Goals>[];
      final updated = existing
          .map((g) => g.id == event.goalId ? event.goal : g)
          .toList();
      await cache.saveGoals(updated);
      await cache.enqueuePlanningOp(
        entityType: 'goal',
        op: 'update',
        entityKey: 'goal_update_${event.goalId}',
        serverId: event.goalId,
        body: event.goal.toJson(),
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, goals: updated));
      showSuccess('Goal updated');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllGoalsEvent());
    });

    on<DeleteGoalEvent>((event, emit) async {
      final existing = await cache.loadGoals() ?? state.goals ?? <Goals>[];
      final remaining =
          existing.where((g) => g.id != event.goalId).toList();
      await cache.saveGoals(remaining);
      await cache.enqueuePlanningOp(
        entityType: 'goal',
        op: 'delete',
        entityKey: 'goal_delete_${event.goalId}',
        serverId: event.goalId,
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, goals: remaining));
      showSuccess('Goal deleted');
      await service<SyncEngine>().syncNow(forcePull: false);
    });

    Future<void> applySavedDelta(
      int goalId,
      double delta,
      Emitter<GoalsState> emit,
    ) async {
      final existing = await cache.loadGoals() ?? state.goals ?? <Goals>[];
      Goals? updatedGoal;
      final updated = existing.map((g) {
        if (g.id != goalId) return g;
        final next = g.copyWith(
          amountSaved: ((g.amountSaved ?? 0) + delta)
              .clamp(0, double.infinity)
              .toDouble(),
          updatedAt: DateTime.now(),
        );
        updatedGoal = next;
        return next;
      }).toList();
      if (updatedGoal == null && state.goal?.id == goalId) {
        updatedGoal = state.goal!.copyWith(
          amountSaved: ((state.goal!.amountSaved ?? 0) + delta)
              .clamp(0, double.infinity)
              .toDouble(),
        );
      }
      await cache.saveGoals(updated);
      if (updatedGoal != null) {
        // Only the latest total matters, so one queued op per goal.
        await cache.enqueuePlanningOp(
          entityType: 'goal',
          op: 'recharge',
          entityKey: 'goal_recharge_$goalId',
          serverId: goalId,
          body: {'new_amount_saved': updatedGoal!.amountSaved},
        );
      }
      emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        goals: updated,
        goal: updatedGoal ?? state.goal,
      ));
    }

    on<RechargeGoalEvent>((event, emit) async {
      await PaymentHistoryStore.add('goal', event.goalId,
          amount: event.amount, note: event.note, paidAt: event.paidAt);
      await applySavedDelta(event.goalId, event.amount, emit);
      showSuccess('Payment added');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllGoalsEvent());
    });

    on<RemoveGoalPaymentEvent>((event, emit) async {
      await PaymentHistoryStore.remove('goal', event.goalId, event.paymentId);
      await applySavedDelta(event.goalId, -event.amount, emit);
      showSuccess('Payment removed');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllGoalsEvent());
    });
  }
}
