part of 'bloc.dart';

class AccountState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final User? user;
  final String? accessToken;
  final bool verifyOtp;
  final bool verificationSuccess;
  final bool resetRequestSuccess;

  const AccountState({
    this.status = ServiceStatus.initial,
    this.user,
    this.message,
    this.verifyOtp = false,
    this.accessToken,
    this.verificationSuccess = false,
    this.resetRequestSuccess = false,
  });

  AccountState copyWith(
      {ServiceStatus? status,
      String? accessToken,
      User? user,
      ApplicationMessage? message,
      bool? verifyOtp,
      bool? verificationSuccess,
      bool? resetRequestSuccess}) {
    return AccountState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
      verifyOtp: verifyOtp ?? false,
      accessToken: accessToken ?? this.accessToken,
      verificationSuccess: verificationSuccess ?? false,
      resetRequestSuccess: resetRequestSuccess ?? false,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        message,
        verifyOtp,
        accessToken,
        verificationSuccess,
        resetRequestSuccess,
      ];
}
