part of 'bloc.dart';

class GraphsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final List<ChartData> data;
  final String dateRange;
  final int selectedTab;
  final List<bool> tabs;

  const GraphsState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.data = const [],
      this.selectedTab = 0,
      this.dateRange = "",
      this.tabs = const <bool>[true, false, false]});

  GraphsState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      List<ChartData>? data,
      int? selectedTab,
      String? dateRange,
      List<bool>? tabs}) {
    return GraphsState(
        status: status ?? this.status,
        message: message,
        selectedTab: selectedTab ?? this.selectedTab,
        data: data ?? this.data,
        dateRange: dateRange ?? this.dateRange,
        tabs: tabs ?? this.tabs);
  }

  @override
  List<Object?> get props =>
      [message, selectedTab, data, tabs, status, dateRange];
}
