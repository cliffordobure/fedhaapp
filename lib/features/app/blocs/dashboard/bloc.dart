import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardControllerBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardControllerBloc() : super(const DashboardState(position: 0)) {
    on<PositionEvent>(
        (event, emit) => emit(state.copyWith(position: event.position)));
  }
}

class DashboardState extends Equatable {
  final int position;
  final bool isMapView;

  const DashboardState({required this.position, this.isMapView = false});

  DashboardState copyWith({int? position, bool? isMapView}) {
    return DashboardState(
        position: position ?? this.position,
        isMapView: isMapView ?? this.isMapView);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [position];
}

// Create event
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class StartDashboardEvent extends DashboardEvent {}

class PositionEvent extends DashboardEvent {
  final int position;

  const PositionEvent(this.position);
}
