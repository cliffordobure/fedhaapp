// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required User user,
    @JsonKey(name: "access_token") required String accessToken,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class User with _$User {
  const factory User(
          {required int id,
          required String name,
          required String email,
          @JsonKey(name: "phone_number") required String phoneNumber,
          int? role,
          int? status,
          @Default("Free") @JsonKey(name: "account_plan") String accountPlan}) =
      _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
