// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillTypeImpl _$$BillTypeImplFromJson(Map<String, dynamic> json) =>
    _$BillTypeImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$BillTypeImplToJson(_$BillTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
