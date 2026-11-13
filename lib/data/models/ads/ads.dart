// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ads.freezed.dart';
part 'ads.g.dart';

@freezed
class Ads with _$Ads {
  const factory Ads({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'image_path') required String imagePath,
    required int status,
    @JsonKey(name: 'payment_status') required int paymentStatus,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'url') String? link,
    @JsonKey(name: 'media_type') required String mediaType,
    @JsonKey(name: 'media_path') required String mediaPath,
    required bool autoplay,
  }) = _Ads;

  factory Ads.fromJson(Map<String, dynamic> json) => _$AdsFromJson(json);
}
