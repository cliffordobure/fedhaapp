import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'income.freezed.dart';
part 'income.g.dart';

@freezed
abstract class IncomeCategory with _$IncomeCategory {
  const factory IncomeCategory({
    required int id,
    required String name,
    String? description,
    required List<Transaction> transactions,
  }) = _IncomeCategory;

  factory IncomeCategory.fromJson(Map<String, dynamic> json) =>
      _$IncomeCategoryFromJson(json);
}
