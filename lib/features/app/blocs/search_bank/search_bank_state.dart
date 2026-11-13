part of 'search_bank_bloc.dart';

class SearchBankState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<Bank> banks;
  final List<int> selected;
  final bool banksSaved;
  final int? selectedIndex;

  const SearchBankState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.selectedIndex,
      this.banks = const [],
      this.selected = const [],
      this.banksSaved = false});

  // @override
  // List<Object?> get props => [status, message, banks, selected, banksSaved];

  // SearchBankState copyWith({
  //   int? selectedIndex,
  //   List<Bank>? banks,
  // }) {
  //   return SearchBankState(
  //     banks: banks ?? this.banks,
  //     selectedIndex: selectedIndex ?? this.selectedIndex,
  //   );
  // }
  @override
  List<Object?> get props => [selectedIndex, banks];

  SearchBankState copyWith({
    int? selectedIndex,
    List<Bank>? banks,
  }) {
    return SearchBankState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      banks: banks ?? this.banks,
    );
  }
}
