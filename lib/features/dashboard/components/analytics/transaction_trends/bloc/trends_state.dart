part of 'trends_bloc.dart';

class TrendsState extends Equatable {
  final ServiceStatus status;
  final TrendAnalysisResponse? data;
  final String? period;
  final ApplicationMessage? message;

  const TrendsState({
    this.status = ServiceStatus.initial,
    this.data,
    this.message,
    this.period,
  });

  TrendsState copyWith({
    ServiceStatus? status,
    TrendAnalysisResponse? data,
    ApplicationMessage? message,
    required String? period,
  }) {
    return TrendsState(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        period: period ?? this.period);
  }

  @override
  List get props => [status, data, message, period];
}
