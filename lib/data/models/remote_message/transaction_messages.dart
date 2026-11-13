import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_messages.freezed.dart';
part 'transaction_messages.g.dart';

@freezed
class TransactionMessage with _$TransactionMessage {
  const factory TransactionMessage({
    String? reference,
    dynamic amount,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? datetime,
    String? type,
    String? from,
    String? to,
    dynamic balance,
    dynamic cost,
    dynamic fulizaAmount,
    dynamic interest,
    dynamic outstanding,
    dynamic mShwariBalance,
    String? account,
    @Default('KES') String? currency,
  }) = _TransactionMessage;

  factory TransactionMessage.fromJson(Map<String, dynamic> json) =>
      _$TransactionMessageFromJson(json);
}

@freezed
class TransactionMessageList with _$TransactionMessageList {
  const factory TransactionMessageList({
    required List<TransactionMessage> transactions,
  }) = _TransactionsList;

  factory TransactionMessageList.fromJson(Map<String, dynamic> json) =>
      _$TransactionMessageListFromJson(json);
}

// Custom function to deserialize DateTime from JSON
DateTime? _dateTimeFromJson(dynamic json) {
  if (json is String) {
    try {
      return DateTime.parse(json);
    } catch (e) {
      print('Failed to parse date: $json');
      return null;
    }
  }
  return json as DateTime?;
}

// Custom function to serialize DateTime to JSON
String? _dateTimeToJson(DateTime? datetime) {
  return datetime?.toIso8601String();
}
