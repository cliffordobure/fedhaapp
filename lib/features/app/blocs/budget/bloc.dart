import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/budgets/budget.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part "state.dart";
part 'event.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  late BudgetService budgetService;
  BudgetBloc() : super(const BudgetState()) {
    budgetService = service<BudgetService>();

    on<StartBudgetBloc>((event, emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      final res = await budgetService.fetchUserBudgets();
      res.when(
        onError: (error) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) => emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            span: FinancialSpan.weekly,
            selected: data.weekly,
            budgets: data,
          ),
        ),
      );
    });

    on<RefreshBudgets>((event, emit) async {
      final res = await budgetService.fetchUserBudgets();
      res.when(
        onError: (error) {
          // Retry
          add(event);
        },
        // Update budgets
        onSuccess: (data) => emit(
          state.copyWith(
            span: FinancialSpan.weekly,
            selected: data.weekly,
            budgets: data,
          ),
        ),
      );
    });

    // refresh types
    on<RefreshBudgetTypes>((event, emit) async {
      final res = await budgetService.fetchBudgets();

      res.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        // showSuccess("Budget saved");
        // update types
        emit(state.copyWith(formBudgetTypes: data));
      });
    });

// Create a new budget type
    on<NewBudgetType>((event, emit) async {
      showLoading("Saving...");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.submissionInProgress,
        ),
      );
      final res = await budgetService.saveNewBudgetType({"name": event.name});

      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        showSuccess(data);
        // EasyLoading.dismiss();
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingSuccess,
              message: ApplicationMessage.success(data)),
        );
        // refresh types
        add(RefreshBudgetTypes());
      });
    });

// save budget
    on<NewBudgetForm>((event, emit) async {
      showLoading("Please wait..");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.loading,
        ),
      );
      final res = await budgetService.fetchFormBudgetSpans();
      final res2 = await budgetService.fetchBudgets();

      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        EasyLoading.dismiss();
        emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            formBudgetSpans: data,
          ),
        );
      });

      res2.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        EasyLoading.dismiss();
        emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            formBudgetTypes: data,
          ),
        );
      });
    });

    on<BudgetSpanSelected>((event, emit) {
      BudgetType data;

      switch (event.span) {
        case FinancialSpan.weekly:
          data = state.budgets!.weekly;
          break;
        case FinancialSpan.monthly:
          data = state.budgets!.monthly;
          break;
        case FinancialSpan.yearly:
          data = state.budgets!.annually;
          break;
        default:
          data = state.budgets!.weekly;
      }

      emit(state.copyWith(span: event.span, selected: data));
    });
    // custom budget

    // Save budget
    on<NewBudget>((event, emit) async {
      showLoading("Please wait.");
      emit(
        state.copyWith(
          status: ServiceStatus.submissionInProgress,
        ),
      );
      final res = await budgetService.saveBudget(event.data);
      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              status: ServiceStatus.submissionFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        showSuccess(data);
        emit(
          state.copyWith(
            status: ServiceStatus.submissionSuccess,
          ),
        );
        // TODO something
        add(RefreshBudgets());
      });
    });
  }
}
