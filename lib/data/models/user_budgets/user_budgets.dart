import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_budgets.freezed.dart';
part 'user_budgets.g.dart';

String _budgetAmountFromJson(dynamic value) {
  if (value == null) return '0';
  return value.toString();
}

String? _budgetOptionalAmountFromJson(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

@freezed
abstract class UserBudget with _$UserBudget {
  const factory UserBudget({
    required int? id,
    @JsonKey(name: 'user_id') required int? userId,
    @JsonKey(fromJson: _budgetAmountFromJson) @Default("0") String amount,
    @JsonKey(
      name: 'budget_limit_amount',
      fromJson: _budgetOptionalAmountFromJson,
    )
    String? budgetLimitAmount,
    @JsonKey(name: 'wallet_name') String? associatedWallet,
    @JsonKey(name: 'category_name') String? category,
    @JsonKey(name: 'subcategory_name') String? subcategoryName,
    @JsonKey(name: 'reset_period') String? resetPeriod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'budget_name') String? budgetName,
  }) = _UserBudget;

  factory UserBudget.fromJson(Map<String, dynamic> json) =>
      _$UserBudgetFromJson(json);
}

@JsonSerializable()
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime dateTime) => dateTime.toIso8601String();
}

@freezed
abstract class UserBudgets with _$UserBudgets {
  const factory UserBudgets({
    required String message,
    @JsonKey(name: 'user_budgets') required List<UserBudget> budgets,
  }) = _UserBudgets;

  factory UserBudgets.fromJson(Map<String, dynamic> json) =>
      _$UserBudgetsFromJson(json);
}

@freezed
abstract class CreateBudget with _$CreateBudget {
  const factory CreateBudget({
    @Default(0) int budgetId,
    required int type,
    required double amount,
    @JsonKey(name: 'budget_limit_amount') required double budgetLimitAmount,
    @JsonKey(name: 'reset_period') required String resetPeriod,
    @JsonKey(name: 'associated_wallet') required int associatedWallet,
  }) = _CreateBudget;

  factory CreateBudget.fromJson(Map<String, dynamic> json) =>
      _$CreateBudgetFromJson(json);
}

@freezed
abstract class SingleBudgetResponse with _$SingleBudgetResponse {
  const factory SingleBudgetResponse({
    required String message,
    @JsonKey(name: 'user_budget') required UserBudget budget,
  }) = _SingleBudgetResponse;

  factory SingleBudgetResponse.fromJson(Map<String, dynamic> json) =>
      _$SingleBudgetResponseFromJson(json);
}
