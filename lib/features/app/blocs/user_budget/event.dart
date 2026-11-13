part of 'bloc.dart';

abstract class UserBudgetEvent extends Equatable {
  const UserBudgetEvent();

  @override
  List<Object> get props => [];
}

class FetchAllUserBudgetsEvent extends UserBudgetEvent {}

class CreateUserBudgetEvent extends UserBudgetEvent {
  final Map<String, dynamic> userBudget;
  const CreateUserBudgetEvent(this.userBudget);

  @override
  List<Object> get props => [userBudget];
}

class FetchUserBudgetEvent extends UserBudgetEvent {
  final int budgetId;
  const FetchUserBudgetEvent(this.budgetId);

  @override
  List<Object> get props => [budgetId];
}

class UpdateUserBudgetEvent extends UserBudgetEvent {
  final int budgetId;
  final Map<String, dynamic> userBudget;
  const UpdateUserBudgetEvent(this.budgetId, this.userBudget);

  @override
  List<Object> get props => [budgetId];
}

class DeleteUserBudgetEvent extends UserBudgetEvent {
  final int budgetId;
  const DeleteUserBudgetEvent(this.budgetId);

  @override
  List<Object> get props => [budgetId];
}

class ContributeUserBudgetEvent extends UserBudgetEvent {
  final int budgetId;
  final double amount;
  final String? note;
  final DateTime? paidAt;
  const ContributeUserBudgetEvent(this.budgetId, this.amount,
      {this.note, this.paidAt});

  @override
  List<Object> get props =>
      [budgetId, amount, note ?? '', paidAt?.toIso8601String() ?? ''];
}

/// Reverses a payment logged by mistake (subtracts it from the spent total).
class RemoveUserBudgetPaymentEvent extends UserBudgetEvent {
  final int budgetId;
  final String paymentId;
  final double amount;
  const RemoveUserBudgetPaymentEvent(
      this.budgetId, this.paymentId, this.amount);

  @override
  List<Object> get props => [budgetId, paymentId, amount];
}
