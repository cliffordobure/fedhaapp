import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_analysis.freezed.dart';
part 'trend_analysis.g.dart';

@freezed
class TrendAnalysisResponse with _$TrendAnalysisResponse {
  const factory TrendAnalysisResponse({
    required int status,
    required bool success,
    required String message,
    required List<TrendData> data,
    required String period,
  }) = _TrendAnalysisResponse;

  factory TrendAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendAnalysisResponseFromJson(json);
}

@freezed
class TrendData with _$TrendData {
  const factory TrendData({
    String? month,
    String? week,
    required String income,
    required String expense,
    required String net,
  }) = _TrendData;

  factory TrendData.fromJson(Map<String, dynamic> json) =>
      _$TrendDataFromJson(json);
}
