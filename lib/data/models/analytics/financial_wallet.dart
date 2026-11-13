import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_wallet.freezed.dart';
part 'financial_wallet.g.dart';

List<FinancialWallet> financialWalletsFromJson(dynamic str) =>
    List<FinancialWallet>.from(
      (str as List).map(
        (e) => FinancialWallet.fromJson(e as Map<String, dynamic>),
      ),
    );

@freezed
class FinancialWallet with _$FinancialWallet {
  const factory FinancialWallet({
    @JsonKey(name: 'user_id') required num userId,
    @JsonKey(name: 'account_id') String? accountId,
    @JsonKey(name: 'institution_name') String? institutionName,
    @JsonKey(name: 'account_name') String? accountName,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'account_type') String? accountType,
    @JsonKey(name: "bank_id") int? bankId,
    String? balance,
    String? currency,
    required FinancialAnalyticsData data,
  }) = _FinancialWallet;

  factory FinancialWallet.fromJson(Map<String, dynamic> json) =>
      _$FinancialWalletFromJson(json);
}

@freezed
class FinancialAnalyticsData with _$FinancialAnalyticsData {
  const factory FinancialAnalyticsData({
    @JsonKey(name: 'data') required Map<String, FinancialTimeSpanData> data,
  }) = _FinancialAnalyticsData;

  factory FinancialAnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$FinancialAnalyticsDataFromJson({'data': json});
}

@freezed
class FinancialTimeSpanData with _$FinancialTimeSpanData {
  const factory FinancialTimeSpanData({
    @JsonKey(name: 'totalIncome') @Default(0.0) double totalIncome,
    @JsonKey(name: 'totalExpense') @Default(0.0) double totalExpense,
  }) = _FinancialTimeSpanData;

  factory FinancialTimeSpanData.fromJson(Map<String, dynamic> json) =>
      _$FinancialTimeSpanDataFromJson(json);
}
