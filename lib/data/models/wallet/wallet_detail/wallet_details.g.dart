// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletDetailImpl _$$WalletDetailImplFromJson(Map<String, dynamic> json) =>
    _$WalletDetailImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      accountId: json['account_id'],
      institutionName: json['institution_name'] as String,
      bankCode: json['bank_code'] as String?,
      accountName: json['account_name'] as String?,
      accountNumber: json['account_number'] as String?,
      accountType: json['account_type'] as String?,
      balance: (json['balance'] as num).toInt(),
      currency: json['currency'] as String?,
      bvnLast4: json['bvn_last_4'] as String?,
      bankId: (json['bank_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$WalletDetailImplToJson(_$WalletDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'institution_name': instance.institutionName,
      'bank_code': instance.bankCode,
      'account_name': instance.accountName,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
      'balance': instance.balance,
      'currency': instance.currency,
      'bvn_last_4': instance.bvnLast4,
      'bank_id': instance.bankId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$PaginationLinkImpl _$$PaginationLinkImplFromJson(Map<String, dynamic> json) =>
    _$PaginationLinkImpl(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$$PaginationLinkImplToJson(
        _$PaginationLinkImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };

_$TransactionDetailsImpl _$$TransactionDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionDetailsImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['current_page'] as num).toInt(),
      firstPageUrl: json['first_page_url'] as String,
      lastPage: (json['last_page'] as num).toInt(),
      lastPageUrl: json['last_page_url'] as String,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      total: (json['total'] as num?)?.toInt() ?? 0,
      links: (json['links'] as List<dynamic>)
          .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransactionDetailsImplToJson(
        _$TransactionDetailsImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'current_page': instance.currentPage,
      'first_page_url': instance.firstPageUrl,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'next_page_url': instance.nextPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'total': instance.total,
      'links': instance.links,
    };

_$WalletDetailDataImpl _$$WalletDetailDataImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletDetailDataImpl(
      walletDetails:
          WalletDetail.fromJson(json['wallet_details'] as Map<String, dynamic>),
      transactions: TransactionDetails.fromJson(
          json['transactions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletDetailDataImplToJson(
        _$WalletDetailDataImpl instance) =>
    <String, dynamic>{
      'wallet_details': instance.walletDetails,
      'transactions': instance.transactions,
    };
