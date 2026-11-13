// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_histories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentHistoryImpl _$$PaymentHistoryImplFromJson(Map<String, dynamic> json) =>
    _$PaymentHistoryImpl(
      id: (json['id'] as num?)?.toInt(),
      plannedPaymentId: (json['planned_payments_id'] as num?)?.toInt(),
      amountPaid: json['amount_paid'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$PaymentHistoryImplToJson(
        _$PaymentHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planned_payments_id': instance.plannedPaymentId,
      'amount_paid': instance.amountPaid,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
