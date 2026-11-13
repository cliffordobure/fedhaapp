// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bills.freezed.dart';
part 'bills.g.dart';

@freezed
class BillExpense with _$BillExpense {
  const factory BillExpense({
    required int id,
    required String name,
    String? img,
    int? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _BillExpense;

  factory BillExpense.fromJson(Map<String, dynamic> json) =>
      _$BillExpenseFromJson(json);
}
