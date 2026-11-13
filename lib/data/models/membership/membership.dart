import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@freezed
class MembershipResponse with _$MembershipResponse {
  factory MembershipResponse({
    @Default("Basic")
    @JsonKey(name: "current_user_plan")
    String currentUserPlan,
    @JsonKey(name: "data") required List<MembershipOptions> data,
  }) = _MembershipResponse;

  factory MembershipResponse.fromJson(Map<String, dynamic> json) =>
      _$MembershipResponseFromJson(json);
}

@freezed
class MembershipOptions with _$MembershipOptions {
  factory MembershipOptions({
    required int id,
    required String name,
    @JsonKey(fromJson: _priceFromJson) @Default(0) double price,
    @Default(1) int status,
    @Default([]) List<MembershipFeature> features,
  }) = _MembershipOptions;

  factory MembershipOptions.fromJson(Map<String, dynamic> json) =>
      _$MembershipOptionsFromJson(json);
}

/// API may send `price: null` and put the value in `amount` instead.
double _priceFromJson(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

@freezed
class MembershipFeature with _$MembershipFeature {
  factory MembershipFeature({
    required int id,
    @JsonKey(name: "packages_id") required int packagesId,
    required String feature,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _MembershipFeature;

  factory MembershipFeature.fromJson(Map<String, dynamic> json) =>
      _$MembershipFeatureFromJson(json);
}
