import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/payment_history_store.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/utils/utils.dart';

part 'event.dart';
part 'state.dart';

class UserBudgetBloc extends Bloc<UserBudgetEvent, UserBudgetState> {
  UserBudgetBloc() : super(const UserBudgetState()) {
    final cache = service<LocalDataCache>();
    final planning = service<PlanningService>();

    on<FetchAllUserBudgetsEvent>((event, emit) async {
      final cached = await cache.loadUserBudgets();
      if (cached != null && cached.budgets.isNotEmpty) {
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess, userBudgets: cached));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await planning.getUserBudgets();
      await res.when(
        onError: ((error) async {
          if (cached == null || cached.budgets.isEmpty) {
            showError(error.error);
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.error(error.error)));
          }
        }),
        onSuccess: ((data) async {
          final merged = await cache.mergeServerBudgetsWithPending(data);
          await cache.saveUserBudgets(merged);
          emit(state.copyWith(
              status: ServiceStatus.loadingSuccess, userBudgets: merged));
        }),
      );
    });

    on<FetchUserBudgetEvent>((event, emit) async {
      UserBudget? local;
      for (final b in state.userBudgets?.budgets ?? const <UserBudget>[]) {
        if (b.id == event.budgetId) {
          local = b;
          break;
        }
      }
      if (local != null) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          selectedUserBudget: SingleBudgetResponse(
            message: 'cached',
            budget: local,
          ),
        ));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await planning.getSpecificUserBudget(event.budgetId);
      res.when(
        onError: ((error) {
          if (local == null) {
            showError(error.error);
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.error(error.error)));
          }
        }),
        onSuccess: ((data) {
          emit(state.copyWith(
              status: ServiceStatus.loadingSuccess, selectedUserBudget: data));
        }),
      );
    });

    on<CreateUserBudgetEvent>((event, emit) async {
      final tempId = cache.nextTempLocalId();
      final optimistic = UserBudget(
        id: tempId,
        userId: 0,
        amount: '${event.userBudget['amount'] ?? '0'}',
        budgetLimitAmount:
            event.userBudget['budget_limit_amount']?.toString(),
        resetPeriod: event.userBudget['reset_period']?.toString(),
        category: event.userBudget['category_name']?.toString(),
        subcategoryName: event.userBudget['subcategory_name']?.toString(),
        associatedWallet: event.userBudget['wallet_name']?.toString(),
        budgetName: event.userBudget['budget_name']?.toString() ??
            event.userBudget['category_name']?.toString() ??
            'Budget',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final existing = await cache.loadUserBudgets() ??
          state.userBudgets ??
          const UserBudgets(message: '', budgets: []);
      final merged = UserBudgets(
        message: existing.message,
        budgets: [optimistic, ...existing.budgets],
      );
      await cache.saveUserBudgets(merged);
      await cache.enqueuePlanningOp(
        entityType: 'budget',
        op: 'create',
        entityKey: 'budget_create_$tempId',
        body: event.userBudget,
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, userBudgets: merged));
      showSuccess('Budget saved — syncing…');

      final syncOk = await service<SyncEngine>().syncNow(forcePull: false);
      final pending = await cache.loadPlanningOutbox();
      final stillQueued = pending.any((row) {
        final key = '${row['entity_key'] ?? ''}';
        return key == 'budget_create_$tempId';
      });

      if (stillQueued) {
        showError(
          'Budget kept on this device, but cloud sync failed. '
          'It will retry automatically.',
        );
        final local = await cache.loadUserBudgets() ?? merged;
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess, userBudgets: local));
        return;
      }

      if (syncOk) {
        add(FetchAllUserBudgetsEvent());
      } else {
        final local = await cache.loadUserBudgets() ?? merged;
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess, userBudgets: local));
      }
    });

    on<UpdateUserBudgetEvent>((event, emit) async {
      final existing = await cache.loadUserBudgets() ??
          state.userBudgets ??
          const UserBudgets(message: '', budgets: []);
      final updated = UserBudgets(
        message: existing.message,
        budgets: existing.budgets.map((b) {
          if (b.id != event.budgetId) return b;
          return b.copyWith(
            amount: '${event.userBudget['amount'] ?? b.amount}',
            budgetLimitAmount:
                '${event.userBudget['budget_limit_amount'] ?? b.budgetLimitAmount}',
            resetPeriod:
                event.userBudget['reset_period']?.toString() ?? b.resetPeriod,
            updatedAt: DateTime.now(),
          );
        }).toList(),
      );
      await cache.saveUserBudgets(updated);
      await cache.enqueuePlanningOp(
        entityType: 'budget',
        op: 'update',
        entityKey: 'budget_update_${event.budgetId}',
        serverId: event.budgetId,
        body: event.userBudget,
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, userBudgets: updated));
      showSuccess('Budget updated');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllUserBudgetsEvent());
    });

    on<DeleteUserBudgetEvent>((event, emit) async {
      final existing = await cache.loadUserBudgets() ??
          state.userBudgets ??
          const UserBudgets(message: '', budgets: []);
      final remaining = UserBudgets(
        message: existing.message,
        budgets:
            existing.budgets.where((b) => b.id != event.budgetId).toList(),
      );
      await cache.saveUserBudgets(remaining);
      await cache.enqueuePlanningOp(
        entityType: 'budget',
        op: 'delete',
        entityKey: 'budget_delete_${event.budgetId}',
        serverId: event.budgetId,
      );
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, userBudgets: remaining));
      showSuccess('Budget deleted');
      await service<SyncEngine>().syncNow(forcePull: false);
    });

    Future<void> applySpentDelta(
      int budgetId,
      double delta,
      Emitter<UserBudgetState> emit,
    ) async {
      final existing = await cache.loadUserBudgets() ??
          state.userBudgets ??
          const UserBudgets(message: '', budgets: []);
      double? newTotal;
      final updated = UserBudgets(
        message: existing.message,
        budgets: existing.budgets.map((b) {
          if (b.id != budgetId) return b;
          final current = double.tryParse(b.amount) ?? 0;
          final next = (current + delta).clamp(0, double.infinity).toDouble();
          newTotal = next;
          return b.copyWith(
            amount: next.toStringAsFixed(2),
            updatedAt: DateTime.now(),
          );
        }).toList(),
      );
      await cache.saveUserBudgets(updated);
      if (newTotal != null) {
        // Only the latest total matters, so one queued op per budget.
        await cache.enqueuePlanningOp(
          entityType: 'budget',
          op: 'contribute',
          entityKey: 'budget_contribute_$budgetId',
          serverId: budgetId,
          body: {'new_amount': newTotal!.toStringAsFixed(2)},
        );
      }
      emit(state.copyWith(
          status: ServiceStatus.loadingSuccess, userBudgets: updated));
    }

    on<ContributeUserBudgetEvent>((event, emit) async {
      await PaymentHistoryStore.add('budget', event.budgetId,
          amount: event.amount, note: event.note, paidAt: event.paidAt);
      await applySpentDelta(event.budgetId, event.amount, emit);
      showSuccess('Payment added');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllUserBudgetsEvent());
    });

    on<RemoveUserBudgetPaymentEvent>((event, emit) async {
      await PaymentHistoryStore.remove('budget', event.budgetId, event.paymentId);
      await applySpentDelta(event.budgetId, -event.amount, emit);
      showSuccess('Payment removed');
      await service<SyncEngine>().syncNow(forcePull: false);
      add(FetchAllUserBudgetsEvent());
    });
  }
}
