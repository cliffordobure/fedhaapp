// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormSubscriptionSpansImpl _$$FormSubscriptionSpansImplFromJson(
        Map<String, dynamic> json) =>
    _$FormSubscriptionSpansImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$$FormSubscriptionSpansImplToJson(
        _$FormSubscriptionSpansImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
    };

_$FormSubscriptionImpl _$$FormSubscriptionImplFromJson(
        Map<String, dynamic> json) =>
    _$FormSubscriptionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      status: (json['status'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      wallet: json['wallet'] as String?,
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      nextPaymentDate: json['nextPaymentDate'] == null
          ? null
          : DateTime.parse(json['nextPaymentDate'] as String),
    );

Map<String, dynamic> _$$FormSubscriptionImplToJson(
        _$FormSubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'status': instance.status,
      'amount': instance.amount,
      'wallet': instance.wallet,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'nextPaymentDate': instance.nextPaymentDate?.toIso8601String(),
    };
