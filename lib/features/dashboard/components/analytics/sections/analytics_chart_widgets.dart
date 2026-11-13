import 'package:fedha/features/dashboard/components/analytics/sections/analytics_compute.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(14, 14, 14, 14),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AnalyticsSectionHeader extends StatelessWidget {
  const AnalyticsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: HomeDesign.text(size: 11, color: HomeDesign.muted),
                ),
              ],
            ],
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              '$action →',
              style: HomeDesign.text(
                size: 11.5,
                weight: FontWeight.w600,
                color: HomeDesign.green,
              ),
            ),
          ),
      ],
    );
  }
}

class AnalyticsInsightChips extends StatelessWidget {
  const AnalyticsInsightChips({super.key, required this.items});

  final List<(IconData, String, String)> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = items[i];
          return Container(
            width: 148,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8ECEA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.$1, size: 15, color: HomeDesign.green),
                const Spacer(),
                Text(
                  item.$2,
                  style: HomeDesign.text(size: 10.5, color: HomeDesign.muted),
                ),
                Text(
                  item.$3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AnalyticsKpiRow extends StatelessWidget {
  const AnalyticsKpiRow({
    super.key,
    required this.income,
    required this.expense,
    required this.incomeChange,
    required this.expenseChange,
  });

  final double income;
  final double expense;
  final double incomeChange;
  final double expenseChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Kpi(
            label: 'Total Income',
            value: income,
            change: incomeChange,
            color: HomeDesign.income,
            bg: HomeDesign.mint,
            icon: LucideIcons.trendingUp,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Kpi(
            label: 'Total Expense',
            value: expense,
            change: expenseChange,
            color: HomeDesign.expense,
            bg: const Color(0xFFFFECEC),
            icon: LucideIcons.trendingDown,
          ),
        ),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.label,
    required this.value,
    required this.change,
    required this.color,
    required this.bg,
    required this.icon,
  });

  final String label;
  final double value;
  final double change;
  final Color color;
  final Color bg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: HomeDesign.text(size: 11.5, color: HomeDesign.muted)),
          const SizedBox(height: 4),
          Text(
            formatAnalyticsMoney(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HomeDesign.text(
              size: 16,
              weight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}% vs last',
            style: HomeDesign.text(
              size: 10.5,
              weight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsDonutCard extends StatelessWidget {
  const AnalyticsDonutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slices,
    required this.centerLabel,
    required this.centerValue,
    this.centerHint,
    this.centerHintColor,
  });

  final String title;
  final String subtitle;
  final List<CategorySlice> slices;
  final String centerLabel;
  final String centerValue;
  final String? centerHint;
  final Color? centerHintColor;

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<double>(0, (s, e) => s + e.amount);
    return AnalyticsCard(
      child: Column(
        children: [
          AnalyticsSectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 8),
          if (slices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Text(
                'No data in this period yet',
                style: HomeDesign.text(size: 12, color: HomeDesign.muted),
              ),
            )
          else
            SizedBox(
              height: 170,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: <CircularSeries<CategorySlice, String>>[
                        DoughnutSeries<CategorySlice, String>(
                          dataSource: slices,
                          xValueMapper: (d, _) => d.name,
                          yValueMapper: (d, _) => d.amount,
                          pointColorMapper: (d, _) => d.color,
                          innerRadius: '68%',
                          radius: '90%',
                          strokeWidth: 3,
                          strokeColor: Colors.white,
                          animationDuration: 850,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                        ),
                      ],
                      annotations: [
                        CircularChartAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                centerLabel,
                                style: HomeDesign.text(
                                  size: 9.5,
                                  color: HomeDesign.muted,
                                ),
                              ),
                              Text(
                                centerValue,
                                style: HomeDesign.text(
                                  size: 12,
                                  weight: FontWeight.w800,
                                  color: HomeDesign.ink,
                                ),
                              ),
                              if (centerHint != null)
                                Text(
                                  centerHint!,
                                  style: HomeDesign.text(
                                    size: 10,
                                    weight: FontWeight.w600,
                                    color: centerHintColor ?? HomeDesign.muted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final s in slices.take(4)) ...[
                          _Legend(
                            color: s.color,
                            label: s.name,
                            value: formatAnalyticsMoney(s.amount),
                            pct: total <= 0 ? 0 : s.amount / total,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    required this.value,
    required this.pct,
  });

  final Color color;
  final String label;
  final String value;
  final double pct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HomeDesign.text(size: 11, color: HomeDesign.muted),
              ),
            ),
            Text(
              '${(pct * 100).round()}%',
              style: HomeDesign.text(
                size: 10,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: HomeDesign.text(
            size: 12,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
      ],
    );
  }
}

class AnalyticsCompareBars extends StatelessWidget {
  const AnalyticsCompareBars({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buckets,
    this.showIncome = true,
    this.showExpense = true,
    this.showNet = false,
  });

  final String title;
  final String subtitle;
  final List<TimeBucket> buckets;
  final bool showIncome;
  final bool showExpense;
  final bool showNet;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsSectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 4),
          SizedBox(
            height: 210,
            child: buckets.every((b) => b.income <= 0 && b.expense <= 0)
                ? Center(
                    child: Text(
                      'No activity to chart yet',
                      style:
                          HomeDesign.text(size: 12, color: HomeDesign.muted),
                    ),
                  )
                : SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    margin: const EdgeInsets.only(top: 8, right: 4),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      labelStyle: HomeDesign.text(
                        size: 10,
                        color: HomeDesign.muted,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.compact(),
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      majorGridLines: const MajorGridLines(
                        width: 0.7,
                        dashArray: <double>[4, 4],
                        color: Color(0xFFE5E7EB),
                      ),
                      labelStyle: HomeDesign.text(
                        size: 10,
                        color: HomeDesign.muted,
                      ),
                    ),
                    legend: const Legend(isVisible: false),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<TimeBucket, String>>[
                      if (showIncome)
                        ColumnSeries<TimeBucket, String>(
                          name: 'Income',
                          dataSource: buckets,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.income,
                          color: HomeDesign.income,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                          width: 0.4,
                          spacing: 0.15,
                          animationDuration: 800,
                        ),
                      if (showExpense)
                        ColumnSeries<TimeBucket, String>(
                          name: 'Expense',
                          dataSource: buckets,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.expense,
                          color: HomeDesign.expense,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                          width: 0.4,
                          spacing: 0.15,
                          animationDuration: 850,
                        ),
                      if (showNet)
                        SplineSeries<TimeBucket, String>(
                          name: 'Net',
                          dataSource: buckets,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.net,
                          color: const Color(0xFF2E86AB),
                          width: 2.4,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            height: 6,
                            width: 6,
                          ),
                          animationDuration: 950,
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 8),
          AnalyticsMetricLegend(
            items: [
              if (showIncome)
                (label: 'Income', color: HomeDesign.income),
              if (showExpense)
                (label: 'Expense', color: HomeDesign.expense),
              if (showNet)
                (label: 'Net', color: const Color(0xFF2E86AB)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Spaced Income / Expense / Net legend chips for analytics charts.
class AnalyticsMetricLegend extends StatelessWidget {
  const AnalyticsMetricLegend({super.key, required this.items});

  final List<({String label, Color color})> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 28,
        runSpacing: 10,
        children: [
          for (final item in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: HomeDesign.text(
                    size: 12,
                    weight: FontWeight.w600,
                    color: HomeDesign.ink,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AnalyticsRankedBars extends StatelessWidget {
  const AnalyticsRankedBars({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slices,
  });

  final String title;
  final String subtitle;
  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final max = slices.isEmpty
        ? 1.0
        : slices.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return AnalyticsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsSectionHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 12),
          if (slices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No categories yet',
                style: HomeDesign.text(size: 12, color: HomeDesign.muted),
              ),
            )
          else
            for (final s in slices) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w600,
                        color: HomeDesign.ink,
                      ),
                    ),
                  ),
                  Text(
                    formatAnalyticsMoney(s.amount),
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (s.amount / max).clamp(0.04, 1.0),
                  minHeight: 8,
                  backgroundColor: const Color(0xFFF0F2F1),
                  valueColor: AlwaysStoppedAnimation(s.color),
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class AnalyticsTopTxList extends StatelessWidget {
  const AnalyticsTopTxList({
    super.key,
    required this.title,
    required this.items,
    required this.accent,
  });

  final String title;
  final List<TxBrief> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsSectionHeader(
            title: title,
            subtitle: 'Largest in this period',
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No transactions yet',
                style: HomeDesign.text(size: 12, color: HomeDesign.muted),
              ),
            )
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: Color(0xFFF0F1F3)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.receipt, size: 15, color: accent),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        items[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeDesign.text(
                          size: 12.5,
                          weight: FontWeight.w600,
                          color: HomeDesign.ink,
                        ),
                      ),
                    ),
                    Text(
                      formatAnalyticsMoney(items[i].amount, compact: false),
                      style: HomeDesign.text(
                        size: 12.5,
                        weight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}
