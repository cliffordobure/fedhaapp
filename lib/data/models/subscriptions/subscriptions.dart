import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriptions.freezed.dart';
part 'subscriptions.g.dart';

@freezed
class FormSubscriptionSpans with _$FormSubscriptionSpans {
  const factory FormSubscriptionSpans({
    required int id,
    required String name,
    required int status,
  }) = _FormSubscriptionSpans;

  factory FormSubscriptionSpans.fromJson(Map<String, dynamic> json) =>
      _$FormSubscriptionSpansFromJson(json);
}

@freezed
class FormSubscription with _$FormSubscription {
  const factory FormSubscription({
    required int id,
    required String name,
    String? img,
    int? status,
    int? amount,
    String? wallet,
    DateTime? paymentDate,
    DateTime? nextPaymentDate,
  }) = _FormSubscription;

  factory FormSubscription.fromJson(Map<String, dynamic> json) =>
      _$FormSubscriptionFromJson(json);
}
