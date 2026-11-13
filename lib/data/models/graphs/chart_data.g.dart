// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartResponseImpl _$$ChartResponseImplFromJson(Map<String, dynamic> json) =>
    _$ChartResponseImpl(
      dateRange: json['date_range'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChartResponseImplToJson(_$ChartResponseImpl instance) =>
    <String, dynamic>{
      'date_range': instance.dateRange,
      'data': instance.data,
    };

_$DonutDataImpl _$$DonutDataImplFromJson(Map<String, dynamic> json) =>
    _$DonutDataImpl(
      x: json['x'] as String,
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$DonutDataImplToJson(_$DonutDataImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

_$ChartDataImpl _$$ChartDataImplFromJson(Map<String, dynamic> json) =>
    _$ChartDataImpl(
      label: json['label'] as String,
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );

Map<String, dynamic> _$$ChartDataImplToJson(_$ChartDataImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'income': instance.income,
      'expense': instance.expense,
    };
