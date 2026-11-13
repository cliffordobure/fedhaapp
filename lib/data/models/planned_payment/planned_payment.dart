import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_payment.freezed.dart';
part 'planned_payment.g.dart';

List<PlannedPayment> plannedPaymentsFromJson(dynamic str) =>
    List<PlannedPayment>.from(
      (str).map(
        (e) => PlannedPayment.fromJson(e),
      ),
    );

@freezed
class PlannedPayment with _$PlannedPayment {
  const factory PlannedPayment({
    required int? id,
    @JsonKey(name: 'user_id') required int userId,
    required String name,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'subcategory_id') int? subcategoryId,
    @JsonKey(name: 'payment_date') required String paymentDate,
    required String amount,
    required String frequency,
    dynamic status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required Category category,
    Subcategory? subcategory,
    @JsonKey(name: "payment_histories") List<PaymentHistory?>? paymentHistory,
  }) = _PlannedPayment;

  factory PlannedPayment.fromJson(Map<String, dynamic> json) =>
      _$PlannedPaymentFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required int type,
    String? image,
    required int status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class Subcategory with _$Subcategory {
  const factory Subcategory({
    required int id,
    required String name,
    @JsonKey(name: 'category_id') required int categoryId,
    dynamic image,
    required int status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Subcategory;

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);
}

@freezed
class PaymentHistory with _$PaymentHistory {
  const factory PaymentHistory({
    int? id,
    @JsonKey(name: 'planned_payments_id') num? plannedPaymentsId,
    @JsonKey(name: 'amount') required String amount,
    @JsonKey(name: 'paid_at') required String paidAt,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _PaymentHistory;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryFromJson(json);
}

// "payment_histories": [
// [        ] I/flutter ( 4965): │       {
// [        ] I/flutter ( 4965): │         "id": 2,
// [   +1 ms] I/flutter ( 4965): │         "planned_payment_id": 15,
// [        ] I/flutter ( 4965): │         "user_id": 45,
// [        ] I/flutter ( 4965): │         "paid_at": "2024-06-10 00:00:00",
// [        ] I/flutter ( 4965): │         "amount": "800.00",
// [        ] I/flutter ( 4965): │         "created_at": "2024-06-10T02:52:21.000000Z",
// [        ] I/flutter ( 4965): │         "updated_at": "2024-06-10T02:52:21.000000Z"
// [        ] I/flutter ( 4965): │       }
