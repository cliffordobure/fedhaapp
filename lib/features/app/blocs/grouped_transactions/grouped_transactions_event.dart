part of 'grouped_transactions_bloc.dart';

abstract class GroupedTransactionsEvent extends Equatable {
  @override
  List get props => [];
}

class GetGroupedTransactionsEvent extends GroupedTransactionsEvent {
  // Add event properties here
  final int? days;
  final int? perPage;
  final int? page;

  GetGroupedTransactionsEvent(this.days, this.page, this.perPage);

  @override
  List get props => [days, perPage, page];
}
