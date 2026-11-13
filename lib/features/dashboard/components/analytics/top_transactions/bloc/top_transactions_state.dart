part of 'top_transactions_bloc.dart';

class TopTransactionsState extends Equatable {
  final ServiceStatus status;
  final TopTransactionsResponse? data;
  final ApplicationMessage? message;
  // Add additional fields here

  const TopTransactionsState({
    this.status = ServiceStatus.initial,
    this.data,
    this.message,
    // Add additional fields to constructor
  });

  TopTransactionsState copyWith({
    ServiceStatus? status,
    TopTransactionsResponse? data,
    ApplicationMessage? message,
    // Add additional fields to copyWith
  }) {
    return TopTransactionsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List get props => [
        status,
        data,
        message,
      ];
}
