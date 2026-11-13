part of 'bloc.dart';

abstract class AdsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartAdsBloc extends AdsEvent {}
class RefreshAds extends AdsEvent {}
