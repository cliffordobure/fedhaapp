part of 'trends_bloc.dart';

abstract class TrendsEvent extends Equatable {
  @override
  List get props => [];
}

class FetchTrends extends TrendsEvent {
  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;

  FetchTrends(
    this.period,
    this.walletId, {
    this.startDate,
    this.endDate,
  });

  @override
  List get props => [period, walletId, startDate, endDate];
}
