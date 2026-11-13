// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBillImpl _$$UserBillImplFromJson(Map<String, dynamic> json) =>
    _$UserBillImpl(
      allTotalAmount: (json['all_total_amount'] as num).toInt(),
      weekly: BillSpan.fromJson(json['Weekly'] as Map<String, dynamic>),
      monthly: BillSpan.fromJson(json['Monthly'] as Map<String, dynamic>),
      annually: BillSpan.fromJson(json['Annually'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserBillImplToJson(_$UserBillImpl instance) =>
    <String, dynamic>{
      'all_total_amount': instance.allTotalAmount,
      'Weekly': instance.weekly,
      'Monthly': instance.monthly,
      'Annually': instance.annually,
    };

_$BillSpanImpl _$$BillSpanImplFromJson(Map<String, dynamic> json) =>
    _$BillSpanImpl(
      totalAmount: (json['total_amount'] as num).toDouble(),
      bills: (json['bills'] as List<dynamic>)
          .map((e) => Bill.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BillSpanImplToJson(_$BillSpanImpl instance) =>
    <String, dynamic>{
      'total_amount': instance.totalAmount,
      'bills': instance.bills,
    };

_$BillImpl _$$BillImplFromJson(Map<String, dynamic> json) => _$BillImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String,
      wallet: json['wallet'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$$BillImplToJson(_$BillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'wallet': instance.wallet,
      'amount': instance.amount,
    };
