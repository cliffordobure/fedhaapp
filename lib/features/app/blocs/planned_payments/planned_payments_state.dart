part of 'planned_payments_bloc.dart';

class PlannedPaymentsState extends Equatable {
  final ServiceStatus status;
  final ApplicationMessage? message;
  final List<PlannedPayments>? plannedPayments;
  final PlannedPayments? fetchedPlannedPayments;
  const PlannedPaymentsState(
      {this.message,
      this.status = ServiceStatus.initial,
      this.plannedPayments,
      this.fetchedPlannedPayments});

  @override
  List<Object?> get props =>
      [plannedPayments, status, message, fetchedPlannedPayments];

  PlannedPaymentsState copyWith({
    List<PlannedPayments>? plannedPayments,
    PlannedPayments? fetchedPlannedPayments,
    ServiceStatus? status,
    ApplicationMessage? message,
  }) {
    return PlannedPaymentsState(
        plannedPayments: plannedPayments ?? this.plannedPayments,
        fetchedPlannedPayments:
            fetchedPlannedPayments ?? this.fetchedPlannedPayments,
        status: status ?? this.status,
        message: message);
  }
}
