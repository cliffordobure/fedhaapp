part of 'bloc.dart';

abstract class FaqsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartFaqBloc extends FaqsEvent {}

class SearchFaqs extends FaqsEvent {
  final String? keyword;

  SearchFaqs({this.keyword});
  @override
  List<Object?> get props => [keyword];
}
