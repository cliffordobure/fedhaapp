part of 'planned_payments_bloc.dart';

abstract class PlannedPaymentsEvent extends Equatable {
  const PlannedPaymentsEvent();

  @override
  List<Object> get props => [];
}

class FetchAllPlannedPaymentsEvent extends PlannedPaymentsEvent {}

class AddPlannedPaymentsEvent extends PlannedPaymentsEvent {
  final Map<String, dynamic> plannedPayment;
  const AddPlannedPaymentsEvent(this.plannedPayment);

  @override
  List<Object> get props => [plannedPayment];
}

class FetchPlannedPaymentEvent extends PlannedPaymentsEvent {
  final int plannedPaymentId;
  const FetchPlannedPaymentEvent(this.plannedPaymentId);

  @override
  List<Object> get props => [plannedPaymentId];
}

class UpdateGoalEvent extends PlannedPaymentsEvent {
  final int plannedPaymentId;
  final PlannedPayments plannedPayment;
  const UpdateGoalEvent(this.plannedPaymentId, this.plannedPayment);

  @override
  List<Object> get props => [plannedPaymentId];
}

class DeleteGoalEvent extends PlannedPaymentsEvent {
  final int plannedPaymentId;
  const DeleteGoalEvent(this.plannedPaymentId);

  @override
  List<Object> get props => [plannedPaymentId];
}
