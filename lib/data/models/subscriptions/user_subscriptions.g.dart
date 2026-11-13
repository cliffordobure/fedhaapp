// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscriptions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSubscriptionsImpl _$$UserSubscriptionsImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSubscriptionsImpl(
      daily: SubscriptionSpan.fromJson(json['Daily'] as Map<String, dynamic>),
      weekly: SubscriptionSpan.fromJson(json['Weekly'] as Map<String, dynamic>),
      monthly:
          SubscriptionSpan.fromJson(json['Monthly'] as Map<String, dynamic>),
      annually:
          SubscriptionSpan.fromJson(json['Annually'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserSubscriptionsImplToJson(
        _$UserSubscriptionsImpl instance) =>
    <String, dynamic>{
      'Daily': instance.daily,
      'Weekly': instance.weekly,
      'Monthly': instance.monthly,
      'Annually': instance.annually,
    };

_$SubscriptionSpanImpl _$$SubscriptionSpanImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionSpanImpl(
      totalAmount: (json['total_amount'] as num).toInt(),
      subscriptions: (json['subscriptions'] as List<dynamic>)
          .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SubscriptionSpanImplToJson(
        _$SubscriptionSpanImpl instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount,
      'subscriptions': instance.subscriptions,
    };

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String,
      amount: (json['amount'] as num).toInt(),
      wallet: json['wallet'] as String,
      paymentDate: DateTime.parse(json['payment_date'] as String),
      nextPaymentDate: DateTime.parse(json['next_payment_date'] as String),
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'amount': instance.amount,
      'wallet': instance.wallet,
      'payment_date': instance.paymentDate.toIso8601String(),
      'next_payment_date': instance.nextPaymentDate.toIso8601String(),
      'status': instance.status,
    };
