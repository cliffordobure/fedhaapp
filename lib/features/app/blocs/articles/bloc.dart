import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/articles/articles.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  late ArticleService articleService;
  ArticlesBloc() : super(const ArticlesState()) {
    articleService = service<ArticleService>();

    on<StartArticlesBloc>(
        (ArticlesEvent event, Emitter<ArticlesState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      //
      final res = await articleService.fetchArticles();
      res.when(onError: (error) {
        emit(
          state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        final all = ArticleCategory(
            id: -1,
            name: "All",
            status: -1,
            articles: data.expand((element) => element.articles).toList());
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          articles: [all, ...data],
          selected: all
        ));
        add(
          UpdateSelected(category: all),
        );
      });
    });

    on<StartBookMarkedArticles>(
        (ArticlesEvent event, Emitter<ArticlesState> emit) async {
      emit(
        state.copyWith(
          bookMarkedStatus: ServiceStatus.loading,
        ),
      );
      //
      final res = await articleService.fetchBookmarked();
      res.when(onError: (error) {
        emit(
          state.copyWith(
              bookMarkedStatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        emit(state.copyWith(
            bookMarkedStatus: ServiceStatus.loadingSuccess,
            bookmarked: data,
            bookmarkedFiltered: data));
      });
    });

    // search bookmarked
    on<SearchBookmarked>((event, emit) {
      if (event.keyword == null || event.keyword!.trim().isEmpty) {
        emit(state.copyWith(bookmarkedFiltered: state.bookmarked));
      } else {
        emit(state.copyWith(
            bookmarkedFiltered: state.bookmarked
                .where((element) => element
                    .toString()
                    .toLowerCase()
                    .contains(event.keyword!.trim().toLowerCase()))
                .toList()));
      }
    });

    on<UpdateSelected>(
        (event, emit) => emit(state.copyWith(selected: event.category)));

    on<SearchEvent>((event, emit) {
      var all = ArticleCategory(
          id: -1,
          name: "All",
          status: -1,
          articles: state.articles
              .firstWhere((element) => element.id == -1)
              .articles);
      if (event.keyword != null && event.keyword!.isNotEmpty) {
        all = ArticleCategory(
            id: -1,
            name: "All",
            status: -1,
            articles: state.articles
                .firstWhere((element) => element.id == -1)
                .articles
                .where((element) =>
                    element.toJson().toString().contains(event.keyword!))
                .toList());
      }
      emit(state.copyWith(selected: all));
    });
  }
}
