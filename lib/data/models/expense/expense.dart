import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    required int id,
    required String name,
    String? description,
    @Default([]) List<Transaction> transactions,
  }) = _ExpenseCategory;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
}

// expenses
@freezed
class ExpenseType with _$ExpenseType {
  const factory ExpenseType({
    required int id,
    required String name,
  }) = _ExpenseType;

  factory ExpenseType.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeFromJson(json);
}
