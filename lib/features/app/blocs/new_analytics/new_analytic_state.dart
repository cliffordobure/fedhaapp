part of 'new_analytic_bloc.dart';

enum NewAnalyticStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == NewAnalyticStatus.initial;
  bool get isLoading => this == NewAnalyticStatus.loading;
  bool get isSuccess => this == NewAnalyticStatus.success;
  bool get isFailure => this == NewAnalyticStatus.failure;
}

@freezed
class NewAnalyticState with _$NewAnalyticState {
  const factory NewAnalyticState({
    @Default(NewAnalyticStatus.initial) NewAnalyticStatus status,
    @Default([]) List<FinancialWallet> wallets,
    Failure? failure,
  }) = _NewAnalyticState;
}
