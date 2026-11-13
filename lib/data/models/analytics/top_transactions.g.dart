// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopTransactionsResponseImpl _$$TopTransactionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TopTransactionsResponseImpl(
      status: (json['status'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TopTransactionsResponseImplToJson(
        _$TopTransactionsResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'period': instance.period,
    };

_$DataImpl _$$DataImplFromJson(Map<String, dynamic> json) => _$DataImpl(
      topIncomes: (json['top_incomes'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      topExpenses: (json['top_expenses'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DataImplToJson(_$DataImpl instance) =>
    <String, dynamic>{
      'top_incomes': instance.topIncomes,
      'top_expenses': instance.topExpenses,
    };
