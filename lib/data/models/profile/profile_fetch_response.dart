// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_fetch_response.freezed.dart';
part 'profile_fetch_response.g.dart';

@freezed
class ProfileResponse with _$ProfileResponse {
  factory ProfileResponse({
    @JsonKey(name: "data") User? user,
    @JsonKey(name: "account_complete") bool? accountComplete,
    List<String>? section,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

@freezed
class User with _$User {
  factory User(
      {int? id,
      @Default("Anonymous") @JsonKey(name: "first_name") String? firstName,
      @Default("") @JsonKey(name: "last_name") String? lastName,
      @JsonKey(name: "phone_number") String? phoneNumber,
      @Default("email unspecified") String? email,
      String? avatar,
      @JsonKey(name: "active_status") String? activeStatus,
      @JsonKey(name: "id_number") String? idNumber,
      List? services, // TODO! Check what is returned and decode
      UserProfile? profile}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  factory UserProfile({
    String? type,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "business_name") String? businessName,
    @JsonKey(name: "business_phone_number") String? businessPhoneNumber,
    @JsonKey(name: "business_email") String? businessEmail,
    @JsonKey(name: "business_registration_certificate")
    String? businessRegistrationCertificate,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
