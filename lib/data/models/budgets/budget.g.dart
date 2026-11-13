// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetResponseImpl _$$BudgetResponseImplFromJson(Map<String, dynamic> json) =>
    _$BudgetResponseImpl(
      allTotalAmount: (json['all_total_amount'] as num).toInt(),
      weekly: BudgetType.fromJson(json['Weekly'] as Map<String, dynamic>),
      monthly: BudgetType.fromJson(json['Monthly'] as Map<String, dynamic>),
      annually: BudgetType.fromJson(json['Annually'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BudgetResponseImplToJson(
        _$BudgetResponseImpl instance) =>
    <String, dynamic>{
      'all_total_amount': instance.allTotalAmount,
      'Weekly': instance.weekly,
      'Monthly': instance.monthly,
      'Annually': instance.annually,
    };

_$BudgetTypeImpl _$$BudgetTypeImplFromJson(Map<String, dynamic> json) =>
    _$BudgetTypeImpl(
      totalAmount: (json['total_amount'] as num).toInt(),
      budgets: (json['budgets'] as List<dynamic>)
          .map((e) => Budget.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BudgetTypeImplToJson(_$BudgetTypeImpl instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount,
      'budgets': instance.budgets,
    };

_$BudgetImpl _$$BudgetImplFromJson(Map<String, dynamic> json) => _$BudgetImpl(
      id: (json['id'] as num).toInt(),
      budgetName: json['budget_name'] as String,
      amount: (json['amount'] as num).toInt(),
      img: json['img'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$BudgetImplToJson(_$BudgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budget_name': instance.budgetName,
      'amount': instance.amount,
      'img': instance.img,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$FormBudgetSpanImpl _$$FormBudgetSpanImplFromJson(Map<String, dynamic> json) =>
    _$FormBudgetSpanImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$FormBudgetSpanImplToJson(
        _$FormBudgetSpanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$FormBudgetTypeImpl _$$FormBudgetTypeImplFromJson(Map<String, dynamic> json) =>
    _$FormBudgetTypeImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      status: (json['status'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$FormBudgetTypeImplToJson(
        _$FormBudgetTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
