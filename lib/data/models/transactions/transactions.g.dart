// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionResponseImpl _$$TransactionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionResponseImpl(
      status: (json['status'] as num).toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      totalAmount: _parseDouble(json['total_amount']),
      data: (json['data'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      previousPageUrl: json['prev_page_url'] as String?,
    );

Map<String, dynamic> _$$TransactionResponseImplToJson(
        _$TransactionResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'success': instance.success,
      'message': instance.message,
      'total_amount': instance.totalAmount,
      'data': instance.data,
      'next_page_url': instance.nextPageUrl,
      'prev_page_url': instance.previousPageUrl,
    };

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num?)?.toInt() ?? -1,
      userId: (json['user_id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      subcategoryId: _parseInt(json['subcategory_id']),
      walletId: (json['wallet_id'] as num?)?.toInt(),
      transactionId: json['transaction_id'] as String,
      type: _parseTransactionType(json['type']),
      amount: _parseDouble(json['amount']),
      narration: json['narration'] as String? ?? "",
      charges: _parseDouble(json['charges']),
      date: _dateTimeFromString(json['date'] as String?),
      balance: _parseDouble(json['balance']),
      currency: json['currency'] as String? ?? "KES",
      createdAt: _dateTimeFromString(json['created_at'] as String?),
      updatedAt: _dateTimeFromString(json['updated_at'] as String?),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'subcategory_id': instance.subcategoryId,
      'wallet_id': instance.walletId,
      'transaction_id': instance.transactionId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'narration': instance.narration,
      'charges': instance.charges,
      'date': _dateTimeToString(instance.date),
      'balance': instance.balance,
      'currency': instance.currency,
      'created_at': _dateTimeToString(instance.createdAt),
      'updated_at': _dateTimeToString(instance.updatedAt),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.debit: 'debit',
  TransactionType.credit: 'credit',
};

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

_$IncomeTypeImpl _$$IncomeTypeImplFromJson(Map<String, dynamic> json) =>
    _$IncomeTypeImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: (json['status'] as num?)?.toInt(),
      createdAt: _dateTimeFromString(json['created_at'] as String?),
      updatedAt: _dateTimeFromString(json['updated_at'] as String?),
    );

Map<String, dynamic> _$$IncomeTypeImplToJson(_$IncomeTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$TransactionDataImpl _$$TransactionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionDataImpl(
      categoryId: (json['category_id'] as num?)?.toInt(),
      subcategoryId: _parseInt(json['subcategory_id']),
      name: json['name'] as String,
      wallet: (json['wallet_id'] as num).toInt(),
      amount: _parseDouble(json['amount']),
      charges: _parseDouble(json['charges']),
      datetime: _dateTimeFromString(json['date'] as String?),
      code: json['transaction_id'] as String,
      type: json['type'] as String,
      currency: json['currency'] as String? ?? 'KES',
    );

Map<String, dynamic> _$$TransactionDataImplToJson(
        _$TransactionDataImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'subcategory_id': instance.subcategoryId,
      'name': instance.name,
      'wallet_id': instance.wallet,
      'amount': instance.amount,
      'charges': instance.charges,
      'date': instance.datetime?.toIso8601String(),
      'transaction_id': instance.code,
      'type': instance.type,
      'currency': instance.currency,
    };

_$GroupedTransactionsResponseImpl _$$GroupedTransactionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupedTransactionsResponseImpl(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: GroupedTransactionsData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GroupedTransactionsResponseImplToJson(
        _$GroupedTransactionsResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_$GroupedTransactionsDataImpl _$$GroupedTransactionsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupedTransactionsDataImpl(
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => GroupedTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: (json['from'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => PageLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$GroupedTransactionsDataImplToJson(
        _$GroupedTransactionsDataImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'data': instance.data,
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'links': instance.links,
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

_$GroupedTransactionImpl _$$GroupedTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupedTransactionImpl(
      date: json['date'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GroupedTransactionImplToJson(
        _$GroupedTransactionImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'transactions': instance.transactions,
    };

_$PageLinkImpl _$$PageLinkImplFromJson(Map<String, dynamic> json) =>
    _$PageLinkImpl(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$$PageLinkImplToJson(_$PageLinkImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
