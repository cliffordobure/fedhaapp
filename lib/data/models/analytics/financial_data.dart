import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_data.freezed.dart';
part 'financial_data.g.dart';

enum FinancialSpan { daily, weekly, monthly, yearly }

extension FinancialSpanExtension on FinancialSpan {
  String get toStringValue {
    switch (this) {
      case FinancialSpan.daily:
        return "Today";
      case FinancialSpan.weekly:
        return "This week";
      case FinancialSpan.monthly:
        return "This month";
      case FinancialSpan.yearly:
        return "This year";
      default:
        return "";
    }
  }
}

@freezed
class FinancialData with _$FinancialData {
  const factory FinancialData({
    required FinancialInfo today,
    required FinancialInfo weekly,
    required FinancialInfo monthly,
    required FinancialInfo yearly,
  }) = _FinancialData;

  factory FinancialData.fromJson(Map<String, dynamic> json) =>
      _$FinancialDataFromJson(json);
}

@freezed
class FinancialInfo with _$FinancialInfo {
  const factory FinancialInfo({
    required double income,
    required double expense,
    required double charges,
    required double balance,
  }) = _FinancialInfo;

  factory FinancialInfo.fromJson(Map<String, dynamic> json) =>
      _$FinancialInfoFromJson(json);
}

// this is used to pass data about chart values to the widget
class PieChartData {
  const PieChartData(this.color, this.percent);

  final Color color;
  final double percent;
}

@freezed
class TransactionAnalytics with _$TransactionAnalytics {
  const factory TransactionAnalytics({
    required String message,
    required AnalyticsData data,
  }) = _TransactionAnalytics;

  factory TransactionAnalytics.fromJson(Map<String, dynamic> json) =>
      _$TransactionAnalyticsFromJson(json);
}

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    @JsonKey(name: 'total_amount') required int totalAmount,
    @JsonKey(name: 'top_categories') required List<TopCategory> topCategories,
    required Period period,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}

@freezed
class TopCategory with _$TopCategory {
  const factory TopCategory({
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'total_amount') required int totalAmount,
    required List<Transaction> transactions,
  }) = _TopCategory;

  factory TopCategory.fromJson(Map<String, dynamic> json) =>
      _$TopCategoryFromJson(json);
}

@freezed
class Period with _$Period {
  const factory Period({
    String? periodType,
    required DateTime? start,
    required DateTime? end,
  }) = _Period;

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);
}
