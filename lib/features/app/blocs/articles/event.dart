part of 'bloc.dart';

abstract class ArticlesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartArticlesBloc extends ArticlesEvent {}
class StartBookMarkedArticles extends ArticlesEvent {}

class UpdateSelected extends ArticlesEvent {
  final ArticleCategory? category;

  UpdateSelected({this.category});
  @override
  List<Object?> get props => [category];
}

class SearchEvent extends ArticlesEvent {
  final String? keyword;

  SearchEvent({this.keyword});
  @override
  List<Object?> get props => [keyword];
}

class SearchBookmarked extends ArticlesEvent {
  final String? keyword;

  SearchBookmarked({this.keyword});
  @override
  List<Object?> get props => [keyword];
}
