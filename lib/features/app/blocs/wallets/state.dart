part of 'bloc.dart';

class WalletsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<Wallet> wallets;
  final List<Bank> banks;
  final List<Bank> filteredBanks;
  final List<Bank> supportedBanks;
  final int? selectedIndex;
  final bool smsUploaded;
  final List<Currency> currencies;
  final WalletDetail? walletDetails;
  final dynamic formBudgetSpans;

  const WalletsState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.formBudgetSpans,
      this.smsUploaded = false,
      this.wallets = const [],
      this.currencies = const [],
      this.banks = const [],
      this.filteredBanks = const [],
      this.supportedBanks = const [],
      this.selectedIndex,
      this.walletDetails});

  WalletsState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      List<Wallet>? wallets,
      List<Bank>? banks,
      List<Bank>? filteredBanks,
      List<Bank>? supportedBanks,
      dynamic formBudgetSpans,
      bool? smsUploaded,
      WalletDetail? walletDetails,
      int? selectedIndex,
      List<Currency>? currencies}) {
    return WalletsState(
        status: status ?? this.status,
        message: message,
        smsUploaded: smsUploaded ?? this.smsUploaded,
        wallets: wallets ?? this.wallets,
        currencies: currencies ?? this.currencies,
        banks: banks ?? this.banks,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        filteredBanks: filteredBanks ?? this.filteredBanks,
        supportedBanks:
            supportedBanks ?? this.supportedBanks, // Add supportedBanks
        formBudgetSpans: formBudgetSpans ?? this.formBudgetSpans,
        walletDetails: walletDetails);
  }

  @override
  List<Object?> get props => [
        status,
        message,
        wallets,
        currencies,
        banks,
        walletDetails,
        smsUploaded,
        filteredBanks,
        supportedBanks,
        selectedIndex,
        formBudgetSpans
      ];
}
