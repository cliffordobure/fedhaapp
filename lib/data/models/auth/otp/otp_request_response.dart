import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_request_response.freezed.dart';
part 'otp_request_response.g.dart';

@freezed
class OtpRequestResponse with _$OtpRequestResponse {
  const factory OtpRequestResponse({
    required bool success,
    required String message,
    required int code,
    required String response,
  }) = _OtpRequestResponse;

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestResponseFromJson(json);
}
