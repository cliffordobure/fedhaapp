// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannedPaymentRequestImpl _$$PlannedPaymentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PlannedPaymentRequestImpl(
      name: json['name'] as String,
      categoryId: (json['category_id'] as num).toInt(),
      subcategoryId: (json['subcategory_id'] as num).toInt(),
      amount: json['amount'] as String,
      paymentDate: json['payment_date'] as String,
      frequency: json['frequency'] as String,
    );

Map<String, dynamic> _$$PlannedPaymentRequestImplToJson(
        _$PlannedPaymentRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category_id': instance.categoryId,
      'subcategory_id': instance.subcategoryId,
      'amount': instance.amount,
      'payment_date': instance.paymentDate,
      'frequency': instance.frequency,
    };
