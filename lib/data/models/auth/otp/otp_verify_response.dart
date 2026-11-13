// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verify_response.freezed.dart';
part 'otp_verify_response.g.dart';

@freezed
class OtpVerifyResponse with _$OtpVerifyResponse {
  factory OtpVerifyResponse({
    String? message,
    bool? success,
  }) = _OtpVerifyResponse;

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyResponseFromJson(json);
}
