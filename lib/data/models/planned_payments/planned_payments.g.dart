// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_payments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannedPaymentsImpl _$$PlannedPaymentsImplFromJson(
        Map<String, dynamic> json) =>
    _$PlannedPaymentsImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      category: json['category'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      paymentDate: json['payment_date'] as String?,
      frequency: json['frequency'] as String?,
      paymentHistories: (json['paymentHistories'] as List<dynamic>?)
          ?.map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: (json['user_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$PlannedPaymentsImplToJson(
        _$PlannedPaymentsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'amount': instance.amount,
      'payment_date': instance.paymentDate,
      'frequency': instance.frequency,
      'paymentHistories': instance.paymentHistories,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
