// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      id: (json['id'] as num).toInt(),
      accountId: json['account_id'] as String? ?? "",
      institutionName: json['institution_name'] as String?,
      accountName: json['account_name'] as String?,
      accountNumber: json['account_number'] as String?,
      accountType: json['account_type'] as String?,
      balance: json['balance'] as String?,
      currency: json['currency'] as String?,
      bankId: (json['bank_id'] as num).toInt(),
      img: json['img_url'] as String? ?? "",
      name: json['name'] as String,
      shortname: json['shortname'] as String,
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_id': instance.accountId,
      'institution_name': instance.institutionName,
      'account_name': instance.accountName,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
      'balance': instance.balance,
      'currency': instance.currency,
      'bank_id': instance.bankId,
      'img_url': instance.img,
      'name': instance.name,
      'shortname': instance.shortname,
    };

_$WalletTypeImpl _$$WalletTypeImplFromJson(Map<String, dynamic> json) =>
    _$WalletTypeImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$WalletTypeImplToJson(_$WalletTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$CurrencyImpl _$$CurrencyImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$$CurrencyImplToJson(_$CurrencyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
    };
