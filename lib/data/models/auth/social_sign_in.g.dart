// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_sign_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialSignInRequestImpl _$$SocialSignInRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialSignInRequestImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      phone_number: json['phone_number'] as String,
      token: json['token'] as String,
      email_verified: json['email_verified'] as bool,
    );

Map<String, dynamic> _$$SocialSignInRequestImplToJson(
        _$SocialSignInRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'phone_number': instance.phone_number,
      'token': instance.token,
      'email_verified': instance.email_verified,
    };

_$SocialSignInResponseImpl _$$SocialSignInResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialSignInResponseImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$$SocialSignInResponseImplToJson(
        _$SocialSignInResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };
