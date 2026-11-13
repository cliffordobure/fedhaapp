part of 'bloc.dart';

abstract class DataEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartDataBloc extends DataEvent {}

class RefreshData extends DataEvent {}

/// Recompute donut totals from the same transactions shown on home.
class SyncCardDataFromTransactions extends DataEvent {
  final List<Transaction> transactions;
  final List<Wallet>? wallets;

  SyncCardDataFromTransactions({
    required this.transactions,
    this.wallets,
  });

  @override
  List<Object?> get props => [transactions, wallets];
}
