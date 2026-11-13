part of 'search_bank_bloc.dart';

abstract class SearchBankEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchEvent extends SearchBankEvent {
  final String searchValue;
  SearchEvent({required this.searchValue});
}

class RadioSelectEvent extends SearchBankEvent {
  final int index;
  RadioSelectEvent({required this.index});
}
