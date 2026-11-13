part of 'bloc.dart';

class BanksState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<Bank> banks;
  final List<int> selected;
  final bool banksSaved;

  const BanksState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.banks = const [],
      this.selected = const [],
      this.banksSaved = false});

  BanksState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      List<Bank>? banks,
      List<int>? selected,
      bool? banksSaved}) {
    return BanksState(
      status: status ?? this.status,
      message: message,
      banks: banks ?? this.banks,
      selected: selected ?? this.selected,
      banksSaved: banksSaved ?? this.banksSaved,
    );
  }

  @override
  List<Object?> get props => [status, message, banks, selected, banksSaved];
}
