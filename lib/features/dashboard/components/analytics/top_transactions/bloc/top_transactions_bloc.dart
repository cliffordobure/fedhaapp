import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/top_transactions.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_transactions_event.dart';
part 'top_transactions_state.dart';

class TopTransactionsBloc
    extends Bloc<TopTransactionsEvent, TopTransactionsState> {
  TopTransactionsBloc() : super(const TopTransactionsState()) {
    on<FetchtransactionsEvent>(_onFetchtransactionsEvent);
  }

  Future _onFetchtransactionsEvent(
    FetchtransactionsEvent event,
    Emitter<TopTransactionsState> emit,
  ) async {
    emit(state.copyWith(status: ServiceStatus.loading));

    final res = await AnalyticsService().fetchTopTransactions(
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
        ));
      },
      onSuccess: (data) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          data: data,
        ));
      },
    );
  }
}
