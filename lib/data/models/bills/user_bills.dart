// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bills.freezed.dart';
part 'user_bills.g.dart';

@freezed
class UserBill with _$UserBill {
  const factory UserBill({
    @JsonKey(name: 'all_total_amount') required int allTotalAmount,
    @JsonKey(name: 'Weekly') required BillSpan weekly,
    @JsonKey(name: 'Monthly') required BillSpan monthly,
    @JsonKey(name: 'Annually') required BillSpan annually,
  }) = _UserBill;

  factory UserBill.fromJson(Map<String, dynamic> json) =>
      _$UserBillFromJson(json);
}

@freezed
class BillSpan with _$BillSpan {
  const factory BillSpan({
    @JsonKey(name: 'total_amount') required double totalAmount,
    required List<Bill> bills,
  }) = _BillSpan;

  factory BillSpan.fromJson(Map<String, dynamic> json) =>
      _$BillSpanFromJson(json);
}

@freezed
class Bill with _$Bill {
  const factory Bill({
    required int id,
    required String name,
    required String img,
    required String wallet,
    required int amount,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}
