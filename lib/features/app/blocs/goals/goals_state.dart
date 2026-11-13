part of 'goals_bloc.dart';

class GoalsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<Goals>? goals;
  final Goals? goal;

  const GoalsState({
    this.message,
    this.status = ServiceStatus.initial,
    this.goals,
    this.goal,
  });

  GoalsState copyWith({
    List<Goals>? goals,
    Goals? goal,
    ServiceStatus? status,
    ApplicationMessage? message,
  }) {
    return GoalsState(
        goals: goals ?? this.goals,
        goal: goal ?? this.goal,
        status: status ?? this.status,
        message: message);
  }

  @override
  List<Object?> get props => [status, message, goals, goal];
}
