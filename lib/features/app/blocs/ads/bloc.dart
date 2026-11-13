import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/ads/ads.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  late AdsService adsService;
  late LocalDataCache localCache;

  AdsBloc() : super(const AdsState()) {
    adsService = service<AdsService>();
    localCache = service<LocalDataCache>();

    on<StartAdsBloc>((AdsEvent event, Emitter<AdsState> emit) async {
      // Local-first: show cached slides immediately, then refresh from API.
      final cached = await localCache.loadAds();
      if (cached != null && cached.isNotEmpty) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          ads: cached,
        ));
      } else {
        emit(state.copyWith(status: ServiceStatus.loading));
      }

      final res = await adsService.fetchAds();
      await res.when(onError: (error) async {
        if (cached == null || cached.isEmpty) {
          emit(
            state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error),
            ),
          );
        }
        // Keep cached ads visible when network fails.
      }, onSuccess: (data) async {
        await localCache.saveAds(data);
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          ads: data,
        ));
      });
    });

    on<RefreshAds>((AdsEvent event, Emitter<AdsState> emit) async {
      final res = await adsService.fetchAds();
      await res.when(onError: (error) async {
        if (state.ads.isEmpty) {
          showError(error.error);
        }
      }, onSuccess: (data) async {
        await localCache.saveAds(data);
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          ads: data,
        ));
      });
    });
  }
}
