part of "blocs.dart";

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class StartAnalytics extends AnalyticsEvent {}

class RefreshAnalytics extends AnalyticsEvent {}

class SpanSelected extends AnalyticsEvent {
  final FinancialSpan span;

  const SpanSelected(this.span);

  @override
  List<Object?> get props => [span];
}
