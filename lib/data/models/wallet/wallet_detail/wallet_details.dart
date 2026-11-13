import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_details.freezed.dart';
part 'wallet_details.g.dart';

@freezed
abstract class WalletDetail with _$WalletDetail {
  const factory WalletDetail({
    required int id,
    @JsonKey(name: "user_id") required int userId,
    @JsonKey(name: "account_id") dynamic accountId,
    @JsonKey(name: "institution_name") required String institutionName,
    @JsonKey(name: "bank_code") String? bankCode,
    @JsonKey(name: "account_name") String? accountName,
    @JsonKey(name: "account_number") String? accountNumber,
    @JsonKey(name: "account_type") String? accountType,
    required int balance, // Changed from String? to int
    String? currency,
    @JsonKey(name: "bvn_last_4") String? bvnLast4,
    @JsonKey(name: "bank_id") required int bankId,
    @JsonKey(name: "created_at") required String createdAt,
    @JsonKey(name: "updated_at") required String updatedAt,
  }) = _WalletDetail;

  factory WalletDetail.fromJson(Map<String, dynamic> json) =>
      _$WalletDetailFromJson(json);
}

@freezed
abstract class PaginationLink with _$PaginationLink {
  const factory PaginationLink({
    String? url,
    required String label,
    required bool active,
  }) = _PaginationLink;

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);
}

@freezed
abstract class TransactionDetails with _$TransactionDetails {
  const factory TransactionDetails({
    @Default([]) List<Transaction> data, // Added default empty list
    @JsonKey(name: "current_page") required int currentPage,
    @JsonKey(name: "first_page_url") required String firstPageUrl,
    @JsonKey(name: "last_page") required int lastPage,
    @JsonKey(name: "last_page_url") required String lastPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @Default(0) int total, // Added default value
    required List<PaginationLink> links,
  }) = _TransactionDetails;

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailsFromJson(json);
}

@freezed
abstract class WalletDetailData with _$WalletDetailData {
  const factory WalletDetailData({
    @JsonKey(name: "wallet_details") required WalletDetail walletDetails,
    required TransactionDetails transactions,
  }) = _WalletDetailData;

  factory WalletDetailData.fromJson(Map<String, dynamic> json) =>
      _$WalletDetailDataFromJson(json);
}
