// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
class BudgetResponse with _$BudgetResponse {
  const factory BudgetResponse({
    @JsonKey(name: 'all_total_amount') required int allTotalAmount,
    @JsonKey(name: 'Weekly') required BudgetType weekly,
    @JsonKey(name: 'Monthly') required BudgetType monthly,
    @JsonKey(name: 'Annually') required BudgetType annually,
  }) = _BudgetResponse;

  factory BudgetResponse.fromJson(Map<String, dynamic> json) =>
      _$BudgetResponseFromJson(json);
}

@freezed
class BudgetType with _$BudgetType {
  const factory BudgetType({
    @JsonKey(name: 'total_amount') required int totalAmount,
    required List<Budget> budgets,
  }) = _BudgetType;

  factory BudgetType.fromJson(Map<String, dynamic> json) =>
      _$BudgetTypeFromJson(json);
}

@freezed
class Budget with _$Budget {
  const factory Budget({
    required int id,
    @JsonKey(name: 'budget_name') required String budgetName,
    required int amount,
    required String img,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

@freezed
class FormBudgetSpan with _$FormBudgetSpan {
  const factory FormBudgetSpan({
    required int id,
    required String name,
    required int status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _FormBudgetSpan;

  factory FormBudgetSpan.fromJson(Map<String, dynamic> json) =>
      _$FormBudgetSpanFromJson(json);
}

@freezed
class FormBudgetType with _$FormBudgetType {
  const factory FormBudgetType({
    required int id,
    required String name,
    String? img,
    int? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _FormBudgetType;

  factory FormBudgetType.fromJson(Map<String, dynamic> json) =>
      _$FormBudgetTypeFromJson(json);
}

// MARK: New Budget Models
