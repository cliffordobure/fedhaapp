part of 'blocs.dart';

class AnalyticsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final FinancialData? data;
  final FinancialSpan span;
  final FinancialInfo? selected;
  final double? balance;
  final double totals;

  const AnalyticsState(
      {this.message,
      this.status = ServiceStatus.initial,
      this.data,
      this.span = FinancialSpan.weekly,
      this.selected,
      this.balance,
      this.totals = 0});

  AnalyticsState copyWith(
      {ApplicationMessage? message,
      ServiceStatus? status,
      FinancialData? data,
      FinancialSpan? span,
      FinancialInfo? selected,
      double? balance,
      double? totals}) {
    return AnalyticsState(
      message: message,
      status: status ?? this.status,
      data: data ?? this.data,
      span: span ?? this.span,
      totals: totals ?? this.totals,
      balance: balance ?? this.balance,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [message,balance, status, data, span, totals, selected];
}
