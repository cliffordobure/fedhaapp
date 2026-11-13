// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank.freezed.dart';
part 'bank.g.dart';

enum BankMode { BANK, PHONE }

@freezed
class Bank with _$Bank {
  const factory Bank({
    required int id,
    required String name,
    required String shortname,
    required String img,
    required int status,
    @JsonKey(name: "mode") @Default(BankMode.BANK) BankMode mode,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
}
