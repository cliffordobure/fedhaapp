import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_sign_in.freezed.dart';
part 'social_sign_in.g.dart';

@freezed
abstract class SocialSignInRequest with _$SocialSignInRequest {
  const factory SocialSignInRequest({
    required String name,
    required String email,
    String? role,
    required String phone_number,
    required String token,
    required bool email_verified,
  }) = _SocialSignInRequest;

  factory SocialSignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialSignInRequestFromJson(json);
}

@freezed
abstract class SocialSignInResponse with _$SocialSignInResponse {
  const factory SocialSignInResponse({
    required User user,
    required String token,
  }) = _SocialSignInResponse;

  factory SocialSignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SocialSignInResponseFromJson(json);
}
