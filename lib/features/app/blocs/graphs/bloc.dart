import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/graphs/chart_data.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part "state.dart";
part 'event.dart';

class GraphsBloc extends Bloc<GraphsEvent, GraphsState> {
  late GraphsService graphsService;
  late LocalDataCache localCache;

  GraphsBloc() : super(const GraphsState()) {
    graphsService = service<GraphsService>();
    localCache = service<LocalDataCache>();

    on<FetchWeekly>((GraphsEvent event, Emitter<GraphsState> emit) async {
      final cached = await localCache.loadWeeklyGraphs();
      if (cached != null && cached.data.isNotEmpty) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          data: cached.data,
          dateRange: cached.dateRange,
        ));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await graphsService.fetchWeeklyGraphData();
      res.when(
        onError: (error) {
          if (state.data.isEmpty) {
            emit(
              state.copyWith(
                  status: ServiceStatus.loadingFailure,
                  message: ApplicationMessage.fromFailure(error)),
            );
          }
        },
        onSuccess: (data) {
          emit(
            state.copyWith(
              status: ServiceStatus.loadingSuccess,
              data: data.data,
              dateRange: data.dateRange,
            ),
          );
          localCache.saveWeeklyGraphs(data.data, data.dateRange);
        },
      );
    });

    // RefreshGraphs
    on<RefreshGraphs>((GraphsEvent event, Emitter<GraphsState> emit) async {
      if (state.data.isEmpty) {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      if (state.selectedTab == 0) {
        // fetch weekly data
        final resWeekly = await graphsService.fetchWeeklyGraphData();

        // Handle weekly
        resWeekly.when(onError: (error) {
          if (state.data.isEmpty) {
            emit(
              state.copyWith(
                  status: ServiceStatus.loadingFailure,
                  message: ApplicationMessage.fromFailure(error)),
            );
          }
        }, onSuccess: (data) {
          emit(
            state.copyWith(
                data: data.data,
                dateRange: data.dateRange,
                status: ServiceStatus.loadingSuccess),
          );
          localCache.saveWeeklyGraphs(data.data, data.dateRange);
        });
      } else {
        final resMonthly = await graphsService.fetchMonthlyGraphData();
        // Handle monthly
        resMonthly.when(onError: (error) {
          showError(error.error);
          emit(state.copyWith(status: ServiceStatus.loadingFailure));
        }, onSuccess: (data) {
          if (state.selectedTab != 0) {
            emit(
              state.copyWith(
                  status: ServiceStatus.loadingSuccess,
                  data: data.data,
                  dateRange: data.dateRange),
            );
          }
        });
      }
    });

    on<FetchMonthly>((GraphsEvent event, Emitter<GraphsState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      // fetch weekly data
      final res = await graphsService.fetchMonthlyGraphData();
      res.when(
        onError: (error) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) => emit(
          state.copyWith(
              status: ServiceStatus.loadingSuccess,
              data: data.data,
              dateRange: data.dateRange),
        ),
      );
    });

    on<FetchCustomData>((event, emit) async {
      showLoading("Fetching data...");
      final res = await graphsService.fetchCustomGraphData(
          event.startDate, event.endDate);

      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        EasyLoading.dismiss();
        emit(
          state.copyWith(
              status: ServiceStatus.loadingSuccess,
              data: data.data,
              dateRange: data.dateRange),
        );
      });
    });

    on<TabChanged>((event, emit) {
      final tabs = <bool>[true, false, false];

      for (int i = 0; i < tabs.length; i++) {
        tabs[i] = i == event.selected;
      }
      emit(
        state.copyWith(selectedTab: event.selected, tabs: tabs),
      );

      if (event.selected == 0) {
        add(FetchWeekly());
      } else if (event.selected == 1) {
        add(FetchMonthly());
      }
    });
  }
}
