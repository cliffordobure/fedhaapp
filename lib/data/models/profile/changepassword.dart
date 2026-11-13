import 'package:freezed_annotation/freezed_annotation.dart';

part 'changepassword.freezed.dart';
part 'changepassword.g.dart';

@freezed
class Changepassword with _$Changepassword {
  factory Changepassword(
    @JsonKey(name: "current_password") String currentPassword,
    @JsonKey(name: "new_password") String newPassword,
  ) = _Changepassword;

  factory Changepassword.fromJson(Map<String, dynamic> json) =>
      _$ChangepasswordFromJson(json);
}
