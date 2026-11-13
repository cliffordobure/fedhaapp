// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalsImpl _$$GoalsImplFromJson(Map<String, dynamic> json) => _$GoalsImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      desiredDate: json['desired_date'] == null
          ? null
          : DateTime.parse(json['desired_date'] as String),
      targetAmount: (json['target_amount'] as num?)?.toDouble(),
      amountSaved: (json['amount_saved'] as num?)?.toDouble(),
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GoalsImplToJson(_$GoalsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'desired_date': instance.desiredDate?.toIso8601String(),
      'target_amount': instance.targetAmount,
      'amount_saved': instance.amountSaved,
      'color': instance.color,
      'icon': instance.icon,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
