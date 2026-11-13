// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialWalletImpl _$$FinancialWalletImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialWalletImpl(
      userId: json['user_id'] as num,
      accountId: json['account_id'] as String?,
      institutionName: json['institution_name'] as String?,
      accountName: json['account_name'] as String?,
      accountNumber: json['account_number'] as String?,
      accountType: json['account_type'] as String?,
      bankId: (json['bank_id'] as num?)?.toInt(),
      balance: json['balance'] as String?,
      currency: json['currency'] as String?,
      data:
          FinancialAnalyticsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FinancialWalletImplToJson(
        _$FinancialWalletImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'institution_name': instance.institutionName,
      'account_name': instance.accountName,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
      'bank_id': instance.bankId,
      'balance': instance.balance,
      'currency': instance.currency,
      'data': instance.data,
    };

_$FinancialAnalyticsDataImpl _$$FinancialAnalyticsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialAnalyticsDataImpl(
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, FinancialTimeSpanData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$FinancialAnalyticsDataImplToJson(
        _$FinancialAnalyticsDataImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$FinancialTimeSpanDataImpl _$$FinancialTimeSpanDataImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialTimeSpanDataImpl(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$FinancialTimeSpanDataImplToJson(
        _$FinancialTimeSpanDataImpl instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
    };
