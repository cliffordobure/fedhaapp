import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_transactions.freezed.dart';
part 'top_transactions.g.dart';

@freezed
class TopTransactionsResponse with _$TopTransactionsResponse {
  const factory TopTransactionsResponse({
    required int status,
    required bool success,
    required String message,
    required Data data,
    required Period period,
  }) = _TopTransactionsResponse;

  factory TopTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TopTransactionsResponseFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: 'top_incomes') required List<Transaction> topIncomes,
    @JsonKey(name: 'top_expenses') required List<Transaction> topExpenses,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
