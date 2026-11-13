// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_subscriptions.freezed.dart';
part 'user_subscriptions.g.dart';

@freezed
class UserSubscriptions with _$UserSubscriptions {
  const factory UserSubscriptions({
    @JsonKey(name: 'Daily') required SubscriptionSpan daily,
    @JsonKey(name: 'Weekly') required SubscriptionSpan weekly,
    @JsonKey(name: 'Monthly') required SubscriptionSpan monthly,
    @JsonKey(name: 'Annually') required SubscriptionSpan annually,
  }) = _UserSubscriptions;

  factory UserSubscriptions.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionsFromJson(json);
}

@freezed
class SubscriptionSpan with _$SubscriptionSpan {
  const factory SubscriptionSpan({
    @JsonKey(name: 'total_amount') required int totalAmount,
    required List<Subscription> subscriptions,
  }) = _SubscriptionSpan;

  factory SubscriptionSpan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSpanFromJson(json);
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required int id,
    required String name,
    required String img,
    required int amount,
    required String wallet,
    @JsonKey(name: 'payment_date') required DateTime paymentDate,
    @JsonKey(name: 'next_payment_date') required DateTime nextPaymentDate,
    required int status,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
