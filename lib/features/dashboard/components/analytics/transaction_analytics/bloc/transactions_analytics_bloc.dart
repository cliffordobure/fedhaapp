import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/service.dart';
part 'transactions_analytics_event.dart';
part 'transactions_analytics_state.dart';

class TransactionsAnalyticsBloc
    extends Bloc<TransactionsAnalyticsEvent, TransactionAnalyticsState> {
  TransactionsAnalyticsBloc() : super(const TransactionAnalyticsState()) {
    // No actions are triggered on bloc initialization
    on<FetchAnalytics>(_onFetchAnalytics);
  }

  Future<void> _onFetchAnalytics(
      FetchAnalytics event, Emitter<TransactionAnalyticsState> emit) async {
    emit(state.copyWith(status: ServiceStatus.loading));

    final res = await AnalyticsService().getTransactionsAnalytics(
        event.type, event.period, event.startDate, event.endDate);

    res.when(
      onError: (error) {
        emit(state.copyWith(
            status: ServiceStatus.loadingFailure,
            message: ApplicationMessage.error(error.error)));
      },
      onSuccess: (data) {
        emit(state.copyWith(
            status: ServiceStatus.loadingSuccess,
            analyticsData: data,
            startDate: event.startDate,
            endDate: event.endDate,
            type: event.type));
      },
    );
  }
}
