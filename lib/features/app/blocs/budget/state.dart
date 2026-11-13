part of 'bloc.dart';

class BudgetState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final ServiceStatus formStatus;
  
  final List<FormBudgetType> formBudgetTypes;
  final List<FormBudgetSpan> formBudgetSpans;
  final BudgetResponse? budgets;
  final FinancialSpan? span;
  final BudgetType? selected;

  const BudgetState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.formBudgetTypes = const [],
      this.formBudgetSpans = const [],
      this.budgets,
      this.span,
      this.formStatus=ServiceStatus.initial,
      this.selected});

  BudgetState copyWith(
      {ServiceStatus? status,
      ServiceStatus? formStatus,
      ApplicationMessage? message,
      List<FormBudgetType>? formBudgetTypes,
      List<FormBudgetSpan>? formBudgetSpans,
      FinancialSpan? span,
      BudgetResponse? budgets,
      BudgetType? selected}) {
    return BudgetState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      message: message,
      formBudgetTypes: formBudgetTypes ?? this.formBudgetTypes,
      formBudgetSpans: formBudgetSpans ?? this.formBudgetSpans,
      budgets: budgets ?? this.budgets,
      span: span ?? this.span,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props =>
      [status, message, formBudgetTypes, formBudgetSpans, budgets, span, selected,formStatus];
}
