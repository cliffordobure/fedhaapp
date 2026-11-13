// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpVerifyRequestImpl _$$OtpVerifyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpVerifyRequestImpl(
      otp: json['otp'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$OtpVerifyRequestImplToJson(
        _$OtpVerifyRequestImpl instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'phone': instance.phone,
    };

_$EmailOtpRequestImpl _$$EmailOtpRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailOtpRequestImpl(
      otp: json['otp'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$EmailOtpRequestImplToJson(
        _$EmailOtpRequestImpl instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'email': instance.email,
    };
