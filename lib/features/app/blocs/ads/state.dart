part of 'bloc.dart';

class AdsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<Ads> ads;

  const AdsState({
    this.status = ServiceStatus.initial,
    this.message,
    this.ads = const [],
  });

  AdsState copyWith({
    ServiceStatus? status,
    ApplicationMessage? message,
    List<Ads>? ads,
  }) {
    return AdsState(
      status: status ?? this.status,
      message: message,
      ads: ads ?? this.ads,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        ads,
      ];
}
