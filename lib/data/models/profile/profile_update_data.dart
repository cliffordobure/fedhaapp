// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_update_data.freezed.dart';
part 'profile_update_data.g.dart';

@freezed
class ProfileUpdateData with _$ProfileUpdateData {
  factory ProfileUpdateData({
    @JsonKey(name: "name") String? name,
    String? email,
    @JsonKey(name: "phone_number") String? phone,
  }) = _ProfileUpdateData;

  factory ProfileUpdateData.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDataFromJson(json);
}
