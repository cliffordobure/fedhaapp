import 'package:freezed_annotation/freezed_annotation.dart';

part 'faqs.freezed.dart';
part 'faqs.g.dart';

@freezed
abstract class FaQ with _$FaQ {
  const factory FaQ({
    required int id,
    required String question,
    required String answer,
  }) = _FaQ;

  factory FaQ.fromJson(Map<String, dynamic> json) => _$FaQFromJson(json);
}
