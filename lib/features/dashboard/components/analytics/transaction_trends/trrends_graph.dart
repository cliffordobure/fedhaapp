import 'package:fedha/data/models/analytics/trend_analysis.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_chart_widgets.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_trends/bloc/trends_bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendLineGraphWidget extends StatelessWidget {
  const TrendLineGraphWidget({
    super.key,
    required this.period,
    this.walletId,
    this.startDate,
    this.endDate,
    this.showHeader = true,
    this.embedded = false,
  });

  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showHeader;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    // Own bloc per graph — shared TrendsBloc was overwriting every wallet card.
    return BlocProvider(
      create: (_) => TrendsBloc()
        ..add(FetchTrends(
          period,
          walletId,
          startDate: startDate,
          endDate: endDate,
        )),
      child: _TrendGraphView(
        period: period,
        walletId: walletId,
        startDate: startDate,
        endDate: endDate,
        showHeader: showHeader,
        embedded: embedded,
      ),
    );
  }
}

class _TrendGraphView extends StatefulWidget {
  const _TrendGraphView({
    required this.period,
    this.walletId,
    this.startDate,
    this.endDate,
    required this.showHeader,
    required this.embedded,
  });

  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showHeader;
  final bool embedded;

  @override
  State<_TrendGraphView> createState() => _TrendGraphViewState();
}

class _TrendGraphViewState extends State<_TrendGraphView> {
  @override
  void didUpdateWidget(covariant _TrendGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period ||
        oldWidget.walletId != widget.walletId ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      context.read<TrendsBloc>().add(FetchTrends(
            widget.period,
            widget.walletId,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendsBloc, TrendsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return SizedBox(
            height: widget.embedded ? 220 : 260,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state.status == ServiceStatus.loadingFailure) {
          return _GraphShell(
            embedded: widget.embedded,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message?.message ?? 'Could not load chart',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.fadeBlackColor),
                ),
                TextButton(
                  onPressed: () => context.read<TrendsBloc>().add(FetchTrends(
                        widget.period,
                        widget.walletId,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                      )),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final points = state.data?.data ?? const <TrendData>[];
        if (points.isEmpty) {
          return _GraphShell(
            embedded: widget.embedded,
            child: Center(
              child: Text(
                'No activity in this period yet',
                style: TextStyle(color: AppColors.fadeBlackColor),
              ),
            ),
          );
        }

        final resolvedPeriod = state.data?.period ?? widget.period;
        final isYear = resolvedPeriod == 'this_year' ||
            (resolvedPeriod == 'custom' &&
                (widget.startDate == null ||
                    widget.endDate == null ||
                    widget.endDate!
                            .difference(widget.startDate!)
                            .inDays >
                        60));
        final hasSignal = points.any((p) {
          final income = double.tryParse(p.income) ?? 0;
          final expense = double.tryParse(p.expense) ?? 0;
          return income > 0 || expense > 0;
        });

        return _GraphShell(
          embedded: widget.embedded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showHeader) ...[
                Text(
                  'Income vs Expense',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasSignal
                      ? 'Based on your transactions this period'
                      : 'No recorded amounts yet — chart will fill as you transact',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.fadeBlackColor,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: const EdgeInsets.only(top: 8, right: 4, bottom: 0),
                  enableAxisAnimation: true,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.fadeBlackColor,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.compact(),
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    majorGridLines: MajorGridLines(
                      width: 0.7,
                      dashArray: const <double>[4, 4],
                      color: AppColors.greyColor.withValues(alpha: 0.55),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: AppColors.fadeBlackColor,
                    ),
                  ),
                  legend: const Legend(isVisible: false),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    canShowMarker: true,
                    header: '',
                    format: 'point.x\npoint.y',
                  ),
                  series: <CartesianSeries<TrendData, String>>[
                    ColumnSeries<TrendData, String>(
                      name: 'Income',
                      dataSource: points,
                      animationDuration: 900,
                      xValueMapper: (d, _) => _label(d, isYear),
                      yValueMapper: (d, _) =>
                          double.tryParse(d.income) ?? 0.0,
                      color: const Color(0xFF03A63C),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      width: 0.42,
                      spacing: 0.18,
                    ),
                    ColumnSeries<TrendData, String>(
                      name: 'Expense',
                      dataSource: points,
                      animationDuration: 950,
                      xValueMapper: (d, _) => _label(d, isYear),
                      yValueMapper: (d, _) =>
                          double.tryParse(d.expense) ?? 0.0,
                      color: const Color(0xFFD64550),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      width: 0.42,
                      spacing: 0.18,
                    ),
                    SplineSeries<TrendData, String>(
                      name: 'Net',
                      dataSource: points,
                      animationDuration: 1100,
                      xValueMapper: (d, _) => _label(d, isYear),
                      yValueMapper: (d, _) => double.tryParse(d.net) ?? 0.0,
                      color: const Color(0xFF2E86AB),
                      width: 2.4,
                      splineType: SplineType.monotonic,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 6,
                        width: 6,
                        borderWidth: 2,
                        borderColor: Color(0xFF2E86AB),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const AnalyticsMetricLegend(
                items: [
                  (label: 'Income', color: Color(0xFF03A63C)),
                  (label: 'Expense', color: Color(0xFFD64550)),
                  (label: 'Net', color: Color(0xFF2E86AB)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _label(TrendData point, bool isYear) {
    if (isYear) {
      final month = point.month ?? '';
      return month.length > 3 ? month.substring(0, 3) : month;
    }
    return point.week ?? point.month ?? '';
  }
}

class _GraphShell extends StatelessWidget {
  const _GraphShell({
    required this.child,
    this.embedded = false,
  });

  final Widget child;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      margin: embedded
          ? const EdgeInsets.fromLTRB(4, 4, 4, 8)
          : const EdgeInsets.fromLTRB(12, 4, 12, 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
      decoration: embedded
          ? null
          : BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.35)),
            ),
      child: child,
    );
  }
}
