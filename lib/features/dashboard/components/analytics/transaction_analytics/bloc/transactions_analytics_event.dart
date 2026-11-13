part of 'transactions_analytics_bloc.dart';

abstract class TransactionsAnalyticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAnalytics extends TransactionsAnalyticsEvent {
  final String type;
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;
  FetchAnalytics(this.type, this.period, this.startDate, this.endDate);

  @override
  List<Object?> get props => [type, period, startDate, endDate];
}
