part of 'bloc.dart';

class DataState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final Map<String, dynamic> data;
  final double totals;

  const DataState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.totals = 0,
      this.data = const <String, int>{}});

  DataState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      Map<String, dynamic>? data,
      double? totals}) {
    return DataState(
        status: status ?? this.status,
        message: message,
        totals: totals ?? this.totals,
        data: data ?? this.data);
  }

  @override
  List<Object?> get props => [status, message, data, totals];
}
