part of 'planned_payment_bloc.dart';

@freezed
class PlannedPaymentEvent with _$PlannedPaymentEvent {
  const factory PlannedPaymentEvent.fetched() = _PlannedPaymentFetched;
  const factory PlannedPaymentEvent.added(
      {required PlannedPaymentRequest request}) = _PlannedPaymentAdded;
  const factory PlannedPaymentEvent.updated(
      {required int id,
      required PlannedPaymentRequest request}) = _PlannedPaymentUpdated;
  const factory PlannedPaymentEvent.deleted({
    required int id,
  }) = _PlannedPaymentDeleted;

  const factory PlannedPaymentEvent.detailFetched({
    required int id,
  }) = _PlannedPaymentDetailFetched;

  const factory PlannedPaymentEvent.paymentHistoryAdded(
      {required int id,
      required PaymentHistory request}) = _PlannedPaymentHistoryAdded;
}
