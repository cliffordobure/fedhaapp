part of 'bloc.dart';

abstract class TuitorialEvent extends Equatable {
  const TuitorialEvent();

  @override
  List<Object?> get props => [];
}

class CheckTuitorialEvent extends TuitorialEvent {
  final BuildContext context;

  const CheckTuitorialEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class ShowTuitorialEvent extends TuitorialEvent {
  final BuildContext context;
  final bool force;
  const ShowTuitorialEvent({required this.context, this.force = false});
  @override
  List<Object?> get props => [context, force];
}

class ReShowTuitorialEvent extends TuitorialEvent {
  final BuildContext context;
  const ReShowTuitorialEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
