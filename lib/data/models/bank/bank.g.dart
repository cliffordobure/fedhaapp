// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankImpl _$$BankImplFromJson(Map<String, dynamic> json) => _$BankImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      shortname: json['shortname'] as String,
      img: json['img'] as String,
      status: (json['status'] as num).toInt(),
      mode:
          $enumDecodeNullable(_$BankModeEnumMap, json['mode']) ?? BankMode.BANK,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$BankImplToJson(_$BankImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortname': instance.shortname,
      'img': instance.img,
      'status': instance.status,
      'mode': _$BankModeEnumMap[instance.mode]!,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$BankModeEnumMap = {
  BankMode.BANK: 'BANK',
  BankMode.PHONE: 'PHONE',
};
