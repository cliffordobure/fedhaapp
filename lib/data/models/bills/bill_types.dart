// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_types.freezed.dart';
part 'bill_types.g.dart';

@freezed
class BillType with _$BillType {
  const factory BillType({
    required int id,
    required String name,
    required int status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _BillType;

  factory BillType.fromJson(Map<String, dynamic> json) =>
      _$BillTypeFromJson(json);
}
