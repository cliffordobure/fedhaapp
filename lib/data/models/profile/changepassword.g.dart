// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changepassword.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangepasswordImpl _$$ChangepasswordImplFromJson(Map<String, dynamic> json) =>
    _$ChangepasswordImpl(
      json['current_password'] as String,
      json['new_password'] as String,
    );

Map<String, dynamic> _$$ChangepasswordImplToJson(
        _$ChangepasswordImpl instance) =>
    <String, dynamic>{
      'current_password': instance.currentPassword,
      'new_password': instance.newPassword,
    };
