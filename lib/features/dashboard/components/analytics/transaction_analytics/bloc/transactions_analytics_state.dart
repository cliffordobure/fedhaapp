part of 'transactions_analytics_bloc.dart';

class TransactionAnalyticsState extends Equatable {
  final ServiceStatus status; // To handle loading, success, failure states
  final TransactionAnalytics? analyticsData; // To store the analytics response
  final ApplicationMessage? message; // To handle any error or success messages
  final DateTime? startDate; // Custom period start date
  final DateTime? endDate; // Custom period end date
  final String? type; // income or expense

  const TransactionAnalyticsState({
    this.status = ServiceStatus.initial,
    this.analyticsData,
    this.message,
    this.startDate,
    this.endDate,
    this.type,
  });

  // Copy method to update the state with new values
  TransactionAnalyticsState copyWith({
    ServiceStatus? status,
    TransactionAnalytics? analyticsData,
    ApplicationMessage? message,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) {
    return TransactionAnalyticsState(
      status: status ?? this.status,
      analyticsData: analyticsData ?? this.analyticsData,
      message: message ?? this.message,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        status,
        analyticsData,
        message,
        startDate,
        endDate,
        type,
      ];
}
