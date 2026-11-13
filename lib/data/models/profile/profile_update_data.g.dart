// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileUpdateDataImpl _$$ProfileUpdateDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileUpdateDataImpl(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone_number'] as String?,
    );

Map<String, dynamic> _$$ProfileUpdateDataImplToJson(
        _$ProfileUpdateDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phone,
    };
