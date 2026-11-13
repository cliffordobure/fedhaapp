import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verify_request.freezed.dart';
part 'otp_verify_request.g.dart';

@freezed
class OtpVerifyRequest with _$OtpVerifyRequest {
  const factory OtpVerifyRequest({
    required String otp,
    required String phone,
  }) = _OtpVerifyRequest;

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestFromJson(json);
}

@freezed
class EmailOtpRequest with _$EmailOtpRequest {
  const factory EmailOtpRequest({
    required String otp,
    required String email,
  }) = _EmailOtpRequest;

  factory EmailOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailOtpRequestFromJson(json);
}
