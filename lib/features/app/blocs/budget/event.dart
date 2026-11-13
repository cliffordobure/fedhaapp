part of 'bloc.dart';

abstract class BudgetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartBudgetBloc extends BudgetEvent {}

class RefreshBudgets extends BudgetEvent {}

class RefreshBudgetTypes extends BudgetEvent {}

class BudgetSpanSelected extends BudgetEvent {
  final FinancialSpan span;

  BudgetSpanSelected(this.span);

  @override
  List<Object?> get props => [span];
}

class NewBudgetForm extends BudgetEvent {}

class NewBudget extends BudgetEvent {
  final Map<String, dynamic> data;

  NewBudget(this.data);

  @override
  List<Object?> get props => [data];
}

// Create a new budget type
class NewBudgetType extends BudgetEvent {
  final String name;

  NewBudgetType({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
