import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_payment_request.freezed.dart';
part 'planned_payment_request.g.dart';

@freezed
class PlannedPaymentRequest with _$PlannedPaymentRequest {
  const factory PlannedPaymentRequest({
    required String name,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'subcategory_id') required int subcategoryId,
    required String amount,
    @JsonKey(name: 'payment_date') required String paymentDate,
    required String frequency,
  }) = _PlannedPaymentRequest;

  factory PlannedPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PlannedPaymentRequestFromJson(json);
}
