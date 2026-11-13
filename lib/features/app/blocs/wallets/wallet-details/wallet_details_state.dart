part of 'wallet_details_bloc.dart';

class WallletDetailState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final WalletDetailData? walletdetails;

  const WallletDetailState({
    this.status = ServiceStatus.initial,
    this.message,
    required this.walletdetails,
  });

  WallletDetailState copyWith({
    ServiceStatus? status,
    ApplicationMessage? message,
    WalletDetailData? walletdetails,
  }) {
    return WallletDetailState(
      status: status ?? this.status,
      message: message,
      walletdetails: walletdetails,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        walletdetails,
      ];
}
