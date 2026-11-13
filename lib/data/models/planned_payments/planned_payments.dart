import 'package:fedha/data/models/payment_histories/payment_histories.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_payments.freezed.dart';
part 'planned_payments.g.dart';

@freezed
abstract class PlannedPayments with _$PlannedPayments {
  const factory PlannedPayments({
    int? id,
    String? name,
    String? category,
    double? amount,
    @JsonKey(name: 'payment_date') String? paymentDate,
    String? frequency,
    List<PaymentHistory>? paymentHistories,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _PlannedPayments;

  factory PlannedPayments.fromJson(Map<String, dynamic> json) =>
      _$PlannedPaymentsFromJson(json);
}
