import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_data.freezed.dart';
part 'chart_data.g.dart';

@freezed
abstract class ChartResponse with _$ChartResponse {
  const factory ChartResponse({
    @JsonKey(name: "date_range") required String dateRange,
    required List<ChartData> data,
  }) = _ChartResponse;

  factory ChartResponse.fromJson(Map<String, dynamic> json) =>
      _$ChartResponseFromJson(json);
}

@freezed
abstract class DonutData with _$DonutData {
  const factory DonutData({required String x, required double y}) = _DonutData;

  factory DonutData.fromJson(Map<String, dynamic> json) =>
      _$DonutDataFromJson(json);
}

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    required String label,
    required double income,
    required double expense,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);
}

@freezed
abstract class IncomeData with _$IncomeData {
  const factory IncomeData({
    required String x,
    required double y,
  }) = _IncomeData;
}
