part of 'wallet_details_bloc.dart';

abstract class WalletDetailEvent {}

class FetchWalletDetails extends WalletDetailEvent {
  final int walletId;

  FetchWalletDetails({required this.walletId});
}

class FetchMoreTransactions extends WalletDetailEvent {
  final int walletId;
  final int nextPage;
  FetchMoreTransactions({required this.walletId, required this.nextPage});
}

class ClearWalletDetails extends WalletDetailEvent {}
