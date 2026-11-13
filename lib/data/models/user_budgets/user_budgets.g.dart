// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_budgets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTimeConverter _$DateTimeConverterFromJson(Map<String, dynamic> json) =>
    DateTimeConverter();

Map<String, dynamic> _$DateTimeConverterToJson(DateTimeConverter instance) =>
    <String, dynamic>{};

_$UserBudgetImpl _$$UserBudgetImplFromJson(Map<String, dynamic> json) =>
    _$UserBudgetImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      amount:
          json['amount'] == null ? "0" : _budgetAmountFromJson(json['amount']),
      budgetLimitAmount:
          _budgetOptionalAmountFromJson(json['budget_limit_amount']),
      associatedWallet: json['wallet_name'] as String?,
      category: json['category_name'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      resetPeriod: json['reset_period'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      budgetName: json['budget_name'] as String?,
    );

Map<String, dynamic> _$$UserBudgetImplToJson(_$UserBudgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount': instance.amount,
      'budget_limit_amount': instance.budgetLimitAmount,
      'wallet_name': instance.associatedWallet,
      'category_name': instance.category,
      'subcategory_name': instance.subcategoryName,
      'reset_period': instance.resetPeriod,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'budget_name': instance.budgetName,
    };

_$UserBudgetsImpl _$$UserBudgetsImplFromJson(Map<String, dynamic> json) =>
    _$UserBudgetsImpl(
      message: json['message'] as String,
      budgets: (json['user_budgets'] as List<dynamic>)
          .map((e) => UserBudget.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserBudgetsImplToJson(_$UserBudgetsImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user_budgets': instance.budgets,
    };

_$CreateBudgetImpl _$$CreateBudgetImplFromJson(Map<String, dynamic> json) =>
    _$CreateBudgetImpl(
      budgetId: (json['budgetId'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      budgetLimitAmount: (json['budget_limit_amount'] as num).toDouble(),
      resetPeriod: json['reset_period'] as String,
      associatedWallet: (json['associated_wallet'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateBudgetImplToJson(_$CreateBudgetImpl instance) =>
    <String, dynamic>{
      'budgetId': instance.budgetId,
      'type': instance.type,
      'amount': instance.amount,
      'budget_limit_amount': instance.budgetLimitAmount,
      'reset_period': instance.resetPeriod,
      'associated_wallet': instance.associatedWallet,
    };

_$SingleBudgetResponseImpl _$$SingleBudgetResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleBudgetResponseImpl(
      message: json['message'] as String,
      budget: UserBudget.fromJson(json['user_budget'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SingleBudgetResponseImplToJson(
        _$SingleBudgetResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user_budget': instance.budget,
    };
