// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpRequestResponseImpl _$$OtpRequestResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpRequestResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
      response: json['response'] as String,
    );

Map<String, dynamic> _$$OtpRequestResponseImplToJson(
        _$OtpRequestResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'code': instance.code,
      'response': instance.response,
    };
