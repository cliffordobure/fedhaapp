part of 'grouped_transactions_bloc.dart';

class GroupedTransactionsState extends Equatable {
  final ServiceStatus status;
  final GroupedTransactionsData? groupedTransactionData;
  final ApplicationMessage? message;
  // Add additional fields here

  const GroupedTransactionsState({
    this.status = ServiceStatus.initial,
    this.groupedTransactionData,
    this.message,
    // Add additional fields to constructor
  });

  GroupedTransactionsState copyWith({
    ServiceStatus? status,
    GroupedTransactionsData? groupedTransactionData,
    ApplicationMessage? message,
    // Add additional fields to copyWith
  }) {
    return GroupedTransactionsState(
      status: status ?? this.status,
      groupedTransactionData:
          groupedTransactionData ?? this.groupedTransactionData,
      message: message ?? this.message,
      // Add additional fields to return statement
    );
  }

  @override
  List get props => [
        status,
        groupedTransactionData,
        message,
        // Add additional fields to props
      ];
}
