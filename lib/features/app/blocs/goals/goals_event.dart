part of 'goals_bloc.dart';

abstract class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object> get props => [];
}

class FetchAllGoalsEvent extends GoalsEvent {}

class AddGoalsEvent extends GoalsEvent {
  final Map<String, dynamic> goal;
  const AddGoalsEvent(this.goal);

  @override
  List<Object> get props => [goal];
}

class FetchGoalEvent extends GoalsEvent {
  final int goalId;
  const FetchGoalEvent(this.goalId);

  @override
  List<Object> get props => [goalId];
}

class UpdateGoalEvent extends GoalsEvent {
  final int goalId;
  final Goals goal;
  const UpdateGoalEvent(this.goalId, this.goal);

  @override
  List<Object> get props => [goalId];
}

class UpdateGoalStatusEvent extends GoalsEvent {
  final int goalId;
  final String status;
  const UpdateGoalStatusEvent(this.goalId, this.status);

  @override
  List<Object> get props => [goalId, status];
}

class DeleteGoalEvent extends GoalsEvent {
  final int goalId;
  const DeleteGoalEvent(this.goalId);

  @override
  List<Object> get props => [goalId];
}

class RechargeGoalEvent extends GoalsEvent {
  final int goalId;
  final double amount;
  final String? note;
  final DateTime? paidAt;
  const RechargeGoalEvent(this.goalId, this.amount, {this.note, this.paidAt});

  @override
  List<Object> get props =>
      [goalId, amount, note ?? '', paidAt?.toIso8601String() ?? ''];
}

/// Reverses a goal payment logged by mistake.
class RemoveGoalPaymentEvent extends GoalsEvent {
  final int goalId;
  final String paymentId;
  final double amount;
  const RemoveGoalPaymentEvent(this.goalId, this.paymentId, this.amount);

  @override
  List<Object> get props => [goalId, paymentId, amount];
}
