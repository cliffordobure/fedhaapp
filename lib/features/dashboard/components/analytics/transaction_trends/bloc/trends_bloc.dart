import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/trend_analysis.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trends_event.dart';
part 'trends_state.dart';

class TrendsBloc extends Bloc<TrendsEvent, TrendsState> {
  TrendsBloc() : super(const TrendsState()) {
    on<FetchTrends>(_onFetchTrends);
  }

  Future _onFetchTrends(
    FetchTrends event,
    Emitter<TrendsState> emit,
  ) async {
    emit(state.copyWith(status: ServiceStatus.loading, period: event.period));

    final res = await AnalyticsService().fetchTransactionsTrends(
      period: event.period,
      walletId: event.walletId,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    res.when(
      onError: (error) {
        // Avoid noisy global toasts; show inline error instead.
        emit(state.copyWith(
          status: ServiceStatus.loadingFailure,
          message: ApplicationMessage.error(error.error),
          period: event.period,
        ));
      },
      onSuccess: (data) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          data: data,
          period: event.period,
        ));
      },
    );
  }
}
