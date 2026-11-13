import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/data/error/failure.dart';
import 'package:fedha/data/models/analytics/financial_wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_analytic_bloc.freezed.dart';
part 'new_analytic_event.dart';
part 'new_analytic_state.dart';

class NewAnalyticBloc extends Bloc<NewAnalyticEvent, NewAnalyticState> {
  late AnalyticsService _analyticsService;
  NewAnalyticBloc() : super(const NewAnalyticState()) {
    _analyticsService = service<AnalyticsService>();
    on<_NewAnalyticFetched>((event, emit) async {
      emit(const NewAnalyticState(status: NewAnalyticStatus.loading));

      var analyticsRes = await _analyticsService.fetchAnalyticsData(
          period: event.period,
          startDate: event.startDate,
          endDate: event.endDate);

      analyticsRes.when(onError: (error) {
        emit(NewAnalyticState(
            status: NewAnalyticStatus.failure, failure: error));
      }, onSuccess: (wallets) {
        emit(NewAnalyticState(
            status: NewAnalyticStatus.success, wallets: wallets));
      });
    });
  }
}
