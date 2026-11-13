import 'package:freezed_annotation/freezed_annotation.dart';

part 'goals.freezed.dart';
part 'goals.g.dart';

@freezed
abstract class Goals with _$Goals {
  const factory Goals({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    String? name,
    @JsonKey(name: 'desired_date') DateTime? desiredDate,
    @JsonKey(name: 'target_amount') double? targetAmount,
    @JsonKey(name: 'amount_saved') double? amountSaved,
    String? color,
    String? icon,
    String? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Goals;

  factory Goals.fromJson(Map<String, dynamic> json) => _$GoalsFromJson(json);
}
