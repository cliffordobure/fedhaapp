part of 'bloc.dart';

class ArticlesState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final ServiceStatus bookMarkedStatus;
  final List<ArticleCategory> articles;
  final List<Article> bookmarked;
  final List<Article> bookmarkedFiltered;
  final ArticleCategory? selected;

  const ArticlesState(
      {this.status = ServiceStatus.initial,
      this.bookMarkedStatus = ServiceStatus.initial,
      this.message,
      this.articles = const [],
      this.bookmarked = const [],
      this.bookmarkedFiltered = const [],
      this.selected});

  ArticlesState copyWith({
    ServiceStatus? status,
    ServiceStatus? bookMarkedStatus,
    ApplicationMessage? message,
    List<ArticleCategory>? articles,
    ArticleCategory? selected,
    List<Article>? bookmarked,
    List<Article>? bookmarkedFiltered,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      message: message,
      articles: articles ?? this.articles,
      selected: selected ?? this.selected,
      bookmarked: bookmarked ?? this.bookmarked,
      bookmarkedFiltered: bookmarkedFiltered ?? this.bookmarkedFiltered,
      bookMarkedStatus: bookMarkedStatus ?? this.bookMarkedStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        articles,
        selected,
        bookmarked,
        bookmarkedFiltered,
        bookMarkedStatus
      ];
}
