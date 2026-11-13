// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialDataImpl _$$FinancialDataImplFromJson(Map<String, dynamic> json) =>
    _$FinancialDataImpl(
      today: FinancialInfo.fromJson(json['today'] as Map<String, dynamic>),
      weekly: FinancialInfo.fromJson(json['weekly'] as Map<String, dynamic>),
      monthly: FinancialInfo.fromJson(json['monthly'] as Map<String, dynamic>),
      yearly: FinancialInfo.fromJson(json['yearly'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FinancialDataImplToJson(_$FinancialDataImpl instance) =>
    <String, dynamic>{
      'today': instance.today,
      'weekly': instance.weekly,
      'monthly': instance.monthly,
      'yearly': instance.yearly,
    };

_$FinancialInfoImpl _$$FinancialInfoImplFromJson(Map<String, dynamic> json) =>
    _$FinancialInfoImpl(
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      charges: (json['charges'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$FinancialInfoImplToJson(_$FinancialInfoImpl instance) =>
    <String, dynamic>{
      'income': instance.income,
      'expense': instance.expense,
      'charges': instance.charges,
      'balance': instance.balance,
    };

_$TransactionAnalyticsImpl _$$TransactionAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionAnalyticsImpl(
      message: json['message'] as String,
      data: AnalyticsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransactionAnalyticsImplToJson(
        _$TransactionAnalyticsImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      totalAmount: (json['total_amount'] as num).toInt(),
      topCategories: (json['top_categories'] as List<dynamic>)
          .map((e) => TopCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount,
      'top_categories': instance.topCategories,
      'period': instance.period,
    };

_$TopCategoryImpl _$$TopCategoryImplFromJson(Map<String, dynamic> json) =>
    _$TopCategoryImpl(
      categoryId: (json['category_id'] as num).toInt(),
      categoryName: json['category_name'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TopCategoryImplToJson(_$TopCategoryImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'total_amount': instance.totalAmount,
      'transactions': instance.transactions,
    };

_$PeriodImpl _$$PeriodImplFromJson(Map<String, dynamic> json) => _$PeriodImpl(
      periodType: json['periodType'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$PeriodImplToJson(_$PeriodImpl instance) =>
    <String, dynamic>{
      'periodType': instance.periodType,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };
