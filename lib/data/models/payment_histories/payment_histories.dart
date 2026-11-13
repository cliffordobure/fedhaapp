import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_histories.freezed.dart';
part 'payment_histories.g.dart';

@freezed
abstract class PaymentHistory with _$PaymentHistory {
  const factory PaymentHistory({
    int? id,
    @JsonKey(name: 'planned_payments_id') int? plannedPaymentId,
    @JsonKey(name: 'amount_paid') String? amountPaid,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _PaymentHistory;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryFromJson(json);
}
