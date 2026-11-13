// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions.freezed.dart';
part 'transactions.g.dart';

@freezed
class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int status,
    required bool success,
    required String message,
    @JsonKey(name: "total_amount", fromJson: _parseDouble) double? totalAmount,
    required List<Transaction> data,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "prev_page_url") String? previousPageUrl,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final items = <Transaction>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is! Map) continue;
        try {
          items.add(Transaction.fromJson(Map<String, dynamic>.from(e)));
        } catch (_) {
          // Skip malformed cloud rows so one bad tx cannot blank Home.
        }
      }
    }
    return TransactionResponse(
      status: (json['status'] as num?)?.toInt() ?? 200,
      success: json['success'] == true || json['success'] == 1,
      message: '${json['message'] ?? ''}',
      totalAmount: _parseDouble(json['total_amount']),
      data: items,
      nextPageUrl: json['next_page_url'] as String?,
      previousPageUrl: json['prev_page_url'] as String?,
    );
  }
}

enum TransactionType { debit, credit }

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @Default(-1) int id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'subcategory_id', fromJson: _parseInt) int? subcategoryId,
    @JsonKey(name: 'wallet_id') int? walletId,
    @JsonKey(name: 'transaction_id') required String transactionId,
    @JsonKey(fromJson: _parseTransactionType) required TransactionType type,
    @JsonKey(fromJson: _parseDouble) required double amount,
    @Default("") String narration,
    @JsonKey(fromJson: _parseDouble) double? charges,
    @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
    DateTime? date,
    @JsonKey(fromJson: _parseDouble) double? balance,
    @Default("KES") String? currency,
    @JsonKey(
        name: 'created_at',
        toJson: _dateTimeToString,
        fromJson: _dateTimeFromString)
    DateTime? createdAt,
    @JsonKey(
        name: 'updated_at',
        toJson: _dateTimeToString,
        fromJson: _dateTimeFromString)
    DateTime? updatedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    // Cloud may send user_wallet_id (user_wallets.id) and wallet_id
    // (banks/wallets catalog). Local SQLite + UI join on user wallet row id.
    final userWallet = normalized['user_wallet_id'];
    if (userWallet != null) {
      normalized['wallet_id'] = userWallet;
    }
    if (normalized['transaction_id'] == null &&
        normalized['transaction_code'] != null) {
      normalized['transaction_id'] = normalized['transaction_code'];
    }
    final code = normalized['transaction_id'];
    if (code == null) {
      normalized['transaction_id'] = '';
    } else if (code is! String) {
      normalized['transaction_id'] = '$code';
    }
    return _$TransactionFromJson(normalized);
  }
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    @Default('') String description,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class IncomeType with _$IncomeType {
  const factory IncomeType({
    required int id,
    required String name,
    int? status,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
    DateTime? updatedAt,
  }) = _IncomeType;

  factory IncomeType.fromJson(Map<String, dynamic> json) =>
      _$IncomeTypeFromJson(json);
}

@freezed
class TransactionData with _$TransactionData {
  const factory TransactionData({
    @JsonKey(name: "category_id") int? categoryId,
    @JsonKey(name: "subcategory_id", fromJson: _parseInt) int? subcategoryId,
    required String name,
    @JsonKey(name: "wallet_id") required int wallet,
    @JsonKey(fromJson: _parseDouble) required double amount,
    @JsonKey(fromJson: _parseDouble) required double charges,
    @JsonKey(name: "date", fromJson: _dateTimeFromString) DateTime? datetime,
    @JsonKey(name: "transaction_id") required String code,
    required String type,
    @Default('KES') String? currency,
  }) = _TransactionData;

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    // Prefer user_wallet_id for local outbox / SQLite (user_wallets.id).
    final userWallet = normalized['user_wallet_id'];
    if (userWallet != null) {
      normalized['wallet_id'] = userWallet;
    }
    final code = normalized['transaction_id'];
    if (code != null && code is! String) {
      normalized['transaction_id'] = '$code';
    }
    return _$TransactionDataFromJson(normalized);
  }
}

// Helper functions
TransactionType _parseTransactionType(dynamic value) {
  if (value is String) {
    return value.toLowerCase() == 'credit'
        ? TransactionType.credit
        : TransactionType.debit;
  }
  return TransactionType.debit; // Default value
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String _dateTimeToString(DateTime? dateTime) =>
    dateTime?.toIso8601String() ?? '';

DateTime? _dateTimeFromString(String? dateTimeString) =>
    dateTimeString == null ? null : DateTime.tryParse(dateTimeString);

//MARK:  Grouped Transactions by date

@freezed
class GroupedTransactionsResponse with _$GroupedTransactionsResponse {
  const factory GroupedTransactionsResponse({
    required bool status,
    required String message,
    required GroupedTransactionsData data,
  }) = _GroupedTransactionsResponse;

  factory GroupedTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupedTransactionsResponseFromJson(json);
}

@freezed
class GroupedTransactionsData with _$GroupedTransactionsData {
  const factory GroupedTransactionsData({
    @JsonKey(name: 'current_page') required int currentPage,
    required List<GroupedTransaction> data,
    @JsonKey(name: 'first_page_url') required String firstPageUrl,
    required int from,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'last_page_url') required String lastPageUrl,
    required List<PageLink> links,
    @JsonKey(name: 'next_page_url') String? nextPageUrl,
    required String path,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'prev_page_url') String? prevPageUrl,
    required int to,
    required int total,
  }) = _GroupedTransactionsData;

  factory GroupedTransactionsData.fromJson(Map<String, dynamic> json) =>
      _$GroupedTransactionsDataFromJson(json);
}

@freezed
class GroupedTransaction with _$GroupedTransaction {
  const factory GroupedTransaction({
    required String date,
    required List<Transaction> transactions,
  }) = _GroupedTransaction;

  factory GroupedTransaction.fromJson(Map<String, dynamic> json) =>
      _$GroupedTransactionFromJson(json);
}

@freezed
class PageLink with _$PageLink {
  const factory PageLink({
    String? url,
    required String label,
    required bool active,
  }) = _PageLink;

  factory PageLink.fromJson(Map<String, dynamic> json) =>
      _$PageLinkFromJson(json);
}
