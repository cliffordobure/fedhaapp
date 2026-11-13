part of 'bloc.dart';

abstract class GraphsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeekly extends GraphsEvent {}

class FetchMonthly extends GraphsEvent {}

class RefreshGraphs extends GraphsEvent {}

class FetchCustomData extends GraphsEvent {
  final String startDate;
  final String endDate;

  FetchCustomData({required this.startDate, required this.endDate});
}

class TabChanged extends GraphsEvent {
  final int selected;

  TabChanged({required this.selected});
}