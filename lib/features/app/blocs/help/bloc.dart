import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/faqs/faqs.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class FaqsBloc extends Bloc<FaqsEvent, FaqsState> {
  late ProfileService faqsService;
  FaqsBloc() : super(const FaqsState()) {
    faqsService = service<ProfileService>();

    on<StartFaqBloc>((FaqsEvent event, Emitter<FaqsState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      //
      final res = await faqsService.fetchFaqs();
      res.when(onError: (error) {
        emit(
          state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        emit(state.copyWith(
            faqs: data, filtered: data, status: ServiceStatus.loadingSuccess));
      });
    });

    on<SearchFaqs>((event, emit) {
      if (event.keyword != null && event.keyword!.isNotEmpty) {
        // do something
        emit(state.copyWith(
            filtered: state.faqs
                .where((element) => element
                    .toJson()
                    .toString()
                    .toLowerCase()
                    .contains(event.keyword!.toLowerCase()))
                .toList()));
      } else {
        emit(state.copyWith(filtered: state.faqs));
      }
    });
  }
}
