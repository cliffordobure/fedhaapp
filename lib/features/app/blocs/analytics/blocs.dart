import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "events.dart";
part 'state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsService analyticsService = service<AnalyticsService>();

  AnalyticsBloc() : super(const AnalyticsState()) {
    on<StartAnalytics>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: ServiceStatus.loading,
          ),
        );

        final requests = await analyticsService.fetchData();
        requests.when(
          onError: (error) {
            emit(
              state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error),
              ),
            );
            print("Analytics Error: ${error.toString()}");
          },
          onSuccess: (data) {
            emit(
              state.copyWith(
                  status: ServiceStatus.loadingSuccess,
                  data: data,
                  selected: data.weekly,
                  balance: data.weekly.balance.toDouble(),
                  totals: (data.weekly.income) +
                      (data.weekly.expense) +
                      (data.weekly.charges) +
                      data.weekly.balance.toDouble()),
            );
            print("Analytics Data: ${data.toJson()}");
          },
        );
      },
    );

    // RefreshAnalytics
    on<RefreshAnalytics>(
      (event, emit) async {
        final requests = await analyticsService.fetchData();
        print("Refresh hass been called");
        requests.when(
          onError: (error) {
            showError(error.error);
          },
          onSuccess: (data) => {
            emit(
              state.copyWith(
                  data: data,
                  selected: data.weekly,
                  balance: data.weekly.balance.toDouble(),
                  totals: (data.weekly.income) +
                      (data.weekly.expense) +
                      (data.weekly.charges) +
                      data.weekly.balance.toDouble()),
            )
          },
        );
      },
    );

    on<SpanSelected>((event, emit) {
      emit(state.copyWith(span: event.span));
      // Update data
      if (event.span == FinancialSpan.daily) {
        emit(state.copyWith(
            selected: state.data!.today,
            totals: (state.data?.today.income ?? 0) +
                (state.data?.today.expense ?? 0) +
                (state.data?.today.charges ?? 0) +
                state.balance!));
      } else if (event.span == FinancialSpan.weekly) {
        emit(state.copyWith(
            selected: state.data!.weekly,
            totals: (state.data?.weekly.income ?? 0) +
                (state.data?.weekly.expense ?? 0) +
                (state.data?.weekly.charges ?? 0) +
                state.balance!));
      } else if (event.span == FinancialSpan.monthly) {
        emit(state.copyWith(
            selected: state.data!.monthly,
            totals: (state.data?.monthly.income ?? 0) +
                (state.data?.monthly.expense ?? 0) +
                (state.data?.monthly.charges ?? 0) +
                (state.balance ?? 0)));
      } else {
        emit(
          state.copyWith(
            selected: state.data!.yearly,
            totals: (state.data?.yearly.income ?? 0) +
                (state.data?.yearly.expense ?? 0) +
                (state.data?.yearly.charges ?? 0) +
                state.balance!,
          ),
        );
      }
    });
  }
}
