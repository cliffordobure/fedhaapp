part of 'top_transactions_bloc.dart';

abstract class TopTransactionsEvent extends Equatable {
  @override
  List get props => [];
}

class FetchtransactionsEvent extends TopTransactionsEvent {
  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;

  FetchtransactionsEvent(
    this.period,
    this.walletId, {
    this.startDate,
    this.endDate,
  });

  @override
  List get props => [period, walletId, startDate, endDate];
}
