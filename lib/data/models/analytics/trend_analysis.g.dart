// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrendAnalysisResponseImpl _$$TrendAnalysisResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TrendAnalysisResponseImpl(
      status: (json['status'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      period: json['period'] as String,
    );

Map<String, dynamic> _$$TrendAnalysisResponseImplToJson(
        _$TrendAnalysisResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'period': instance.period,
    };

_$TrendDataImpl _$$TrendDataImplFromJson(Map<String, dynamic> json) =>
    _$TrendDataImpl(
      month: json['month'] as String?,
      week: json['week'] as String?,
      income: json['income'] as String,
      expense: json['expense'] as String,
      net: json['net'] as String,
    );

Map<String, dynamic> _$$TrendDataImplToJson(_$TrendDataImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'week': instance.week,
      'income': instance.income,
      'expense': instance.expense,
      'net': instance.net,
    };
