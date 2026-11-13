part of 'planned_payment_bloc.dart';

enum PlannedPaymentStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == PlannedPaymentStatus.initial;
  bool get isLoading => this == PlannedPaymentStatus.loading;
  bool get isSuccess => this == PlannedPaymentStatus.success;
  bool get isFailure => this == PlannedPaymentStatus.failure;
}

@freezed
class PlannedPaymentState with _$PlannedPaymentState {
  const factory PlannedPaymentState({
    @Default(PlannedPaymentStatus.initial) PlannedPaymentStatus status,
    @Default([]) List<PlannedPayment> plannedPayments,
    PlannedPayment? plannedPayment,
    Failure? failure,
  }) = _PlannedPaymentState;
}
