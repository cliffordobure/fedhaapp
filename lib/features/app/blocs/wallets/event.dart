part of 'bloc.dart';

abstract class WalletsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartWalletBloc extends WalletsEvent {}

class UpdateWalletSms extends WalletsEvent {}

class RefreshWallets extends WalletsEvent {}

class InitMono extends WalletsEvent {
  final BuildContext context;

  InitMono({required this.context});
}

class ExchangeBankToken extends WalletsEvent {
  final String token;
  ExchangeBankToken({required this.token});
}

class CreateManualWallet extends WalletsEvent {
  final Map<String, dynamic> data;
  CreateManualWallet({required this.data});
}

class CreateAutomaticWallet extends WalletsEvent {
  final Bank bank;
  CreateAutomaticWallet({required this.bank});

  @override
  List<Object?> get props => [bank];
}

class UpdateManualWallet extends WalletsEvent {
  final Map<String, dynamic> data;
  final int walletId;
  UpdateManualWallet({required this.walletId, required this.data});
}

class DeleteWallet extends WalletsEvent {
  final int wallletId;
  DeleteWallet({required this.wallletId});
}

class FilterBanks extends WalletsEvent {
  final String query;
  FilterBanks({required this.query});
}

class RadioSelectEvent extends WalletsEvent {
  final int index;
  RadioSelectEvent({required this.index});
}
