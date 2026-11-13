part of 'bloc.dart';

abstract class BanksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartBanksBloc extends BanksEvent {}

class RefreshBanks extends BanksEvent {}

class ToggleSelected extends BanksEvent {
  final int id;

  ToggleSelected(this.id);

  @override
  List<Object?> get props => [id];
}

class SaveSelectedBanks extends BanksEvent {}