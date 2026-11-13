part of 'bloc.dart';

abstract class MembershipEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartMemberShip extends MembershipEvent {}
class RefreshMemberShip extends MembershipEvent {}

class Subscribe extends MembershipEvent {
  final int plan;

  Subscribe({required this.plan});

  @override
  List<Object?> get props => [plan];
}
