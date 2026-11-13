part of 'bloc.dart';

class UserBudgetState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final UserBudgets? userBudgets;
  final SingleBudgetResponse? selectedUserBudget;

  const UserBudgetState({
    this.status = ServiceStatus.initial,
    this.message,
    this.userBudgets,
    this.selectedUserBudget,
  });

  UserBudgetState copyWith({
    ServiceStatus? status,
    ApplicationMessage? message,
    UserBudgets? userBudgets,
    SingleBudgetResponse? selectedUserBudget,
  }) {
    return UserBudgetState(
      status: status ?? this.status,
      message: message,
      userBudgets: userBudgets ?? this.userBudgets,
      selectedUserBudget: selectedUserBudget ?? this.selectedUserBudget,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        userBudgets,
        selectedUserBudget,
      ];
}
