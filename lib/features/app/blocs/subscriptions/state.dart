part of 'bloc.dart';

class SubscriptionsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final ServiceStatus formStatus;
  final List<FormSubscription> formSubscriptions;
  final List<FormSubscriptionSpans> formSubscriptionSpans;
  final UserSubscriptions? subscriptions;
  final FinancialSpan? span;
  final SubscriptionSpan? selected;

  const SubscriptionsState(
      {this.status = ServiceStatus.initial,
      this.formStatus = ServiceStatus.initial,
      this.message,
      this.formSubscriptions = const [],
      this.formSubscriptionSpans = const [],
      this.subscriptions,
      this.span,
      this.selected});

  SubscriptionsState copyWith(
      {ServiceStatus? status,
      ServiceStatus? formStatus,
      ApplicationMessage? message,
      List<FormSubscription>? formSubscriptions,
      List<FormSubscriptionSpans>? formSubscriptionSpans,
      FinancialSpan? span,
      UserSubscriptions? subscriptions,
      SubscriptionSpan? selected}) {
    return SubscriptionsState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      message: message,
      formSubscriptions: formSubscriptions ?? this.formSubscriptions,
      formSubscriptionSpans:
          formSubscriptionSpans ?? this.formSubscriptionSpans,
      subscriptions: subscriptions ?? this.subscriptions,
      span: span ?? this.span,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        formSubscriptions,
        formSubscriptionSpans,
        subscriptions,
        span,
        selected,
        formStatus
      ];
}
