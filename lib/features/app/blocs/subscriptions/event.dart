part of 'bloc.dart';

abstract class SubscriptionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartSubscriptionsBloc extends SubscriptionsEvent {}

class RefreshSubscriptions extends SubscriptionsEvent {}

class SubscriptionsSpanSelected extends SubscriptionsEvent {
  final FinancialSpan span;

  SubscriptionsSpanSelected(this.span);

  @override
  List<Object?> get props => [span];
}

class StartSubscriptionForm extends SubscriptionsEvent {}

class NewSubscription extends SubscriptionsEvent {
  final Map<String, dynamic> data;

  NewSubscription(this.data);

  @override
  List<Object?> get props => [data];
}

class CancelSubscriptions extends SubscriptionsEvent {
  final int id;

  CancelSubscriptions(this.id);

  @override
  List<Object?> get props => [id];
}

// Create a new budget type
class NewSubscriptionType extends SubscriptionsEvent {
  final String name;

  NewSubscriptionType({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}


class RefreshSubscriptionTypes extends SubscriptionsEvent {
  
}