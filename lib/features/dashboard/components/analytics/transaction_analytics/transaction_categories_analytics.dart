import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_analytics/bloc/transactions_analytics_bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/widgets/app_bar.dart';
import 'package:fedha/features/dashboard/components/analytics/widgets/error_state.dart';
import 'package:fedha/features/dashboard/components/home/widgets/transaction_list_view.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Professional palette — brand-aligned, readable on white cards.
const List<Color> _kAnalyticsPalette = [
  Color(0xFF012340),
  Color(0xFF03A63C),
  Color(0xFF2E86AB),
  Color(0xFFE8A838),
  Color(0xFF5B8DEF),
  Color(0xFF027333),
  Color(0xFFD64550),
  Color(0xFF7B6CF6),
  Color(0xFF14B8A6),
  Color(0xFFF97316),
];

class TransactionCategoryAnalytics extends StatefulWidget {
  const TransactionCategoryAnalytics({
    super.key,
    required this.title,
    required this.type,
    required this.period,
    this.dateRange,
  });

  final String title;
  final String type;
  final String period;
  final Period? dateRange;

  @override
  // ignore: library_private_types_in_public_api
  _TransactionCategoryAnalytics createState() =>
      _TransactionCategoryAnalytics();
}

class _TransactionCategoryAnalytics
    extends State<TransactionCategoryAnalytics> {
  final _money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    context.read<TransactionsAnalyticsBloc>().add(
          FetchAnalytics(widget.type, widget.period, widget.dateRange?.start,
              widget.dateRange?.end),
        );
  }

  bool get _isIncome => widget.type.toLowerCase() == 'income';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: buildAppBar(context, widget.title),
      body: BlocBuilder<TransactionsAnalyticsBloc, TransactionAnalyticsState>(
        buildWhen: (previousState, state) {
          return previousState.status != state.status ||
              previousState.analyticsData != state.analyticsData ||
              previousState.message != state.message;
        },
        builder: (context, state) {
          if (state.status == ServiceStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ServiceStatus.loadingFailure) {
            return buildErrorState(
              context,
              state.message?.message ?? 'Error loading data',
              () {
                context.read<TransactionsAnalyticsBloc>().add(
                      FetchAnalytics(widget.type, widget.period,
                          widget.dateRange?.start, widget.dateRange?.end),
                    );
              },
            );
          } else if (state.status == ServiceStatus.loadingSuccess) {
            return _buildSuccessState(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSuccessState(TransactionAnalyticsState state) {
    final chartData = _prepareChartData(state);
    final total = state.analyticsData?.data.totalAmount.toDouble() ?? 0;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        _combinedInsightCard(chartData, total),
        const SizedBox(height: 18),
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkBlueColor,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap a category to see its transactions',
          style: TextStyle(color: AppColors.fadeBlackColor, fontSize: 12),
        ),
        const SizedBox(height: 10),
        _foldableCategoryCard(state, chartData),
      ],
    );
  }

  Widget _combinedInsightCard(List<CategoryData> chartData, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isIncome ? 'Income by category' : 'Spend by category',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.darkBlueColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pie mix + ranking for this period',
                      style: TextStyle(
                        color: AppColors.fadeBlackColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (_isIncome
                          ? AppColors.primaryColor
                          : AppColors.dangerColor)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isIncome ? 'Income' : 'Expense',
                  style: TextStyle(
                    color: _isIncome
                        ? AppColors.primaryColor
                        : AppColors.dangerColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _money.format(total),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total ${_isIncome ? 'income' : 'expenses'}',
            style: TextStyle(
              color: AppColors.fadeBlackColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          if (chartData.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text(
                  'No category data for this period',
                  style: TextStyle(color: AppColors.fadeBlackColor),
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 210,
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x\nKES point.y',
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.right,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: TextStyle(
                    fontSize: 11,
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                series: <CircularSeries<CategoryData, String>>[
                  DoughnutSeries<CategoryData, String>(
                    dataSource: chartData,
                    xValueMapper: (d, _) => d.category,
                    yValueMapper: (d, _) => d.amount,
                    pointColorMapper: (d, _) => d.color,
                    innerRadius: '68%',
                    radius: '92%',
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                    animationDuration: 900,
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                  ),
                ],
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${chartData.length}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkBlueColor,
                          ),
                        ),
                        Text(
                          'groups',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.fadeBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Divider(color: AppColors.greyColor.withValues(alpha: 0.45)),
            const SizedBox(height: 8),
            Text(
              'Category ranking',
              style: TextStyle(
                color: AppColors.darkBlueColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: (48.0 * chartData.take(6).length).clamp(120.0, 280.0),
              child: SfCartesianChart(
                margin: const EdgeInsets.only(top: 4, right: 8),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkColor,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x\nKES point.y',
                ),
                series: <CartesianSeries<CategoryData, String>>[
                  BarSeries<CategoryData, String>(
                    dataSource: chartData.take(6).toList(),
                    xValueMapper: (d, _) =>
                        d.category.length > 14
                            ? '${d.category.substring(0, 14)}…'
                            : d.category,
                    yValueMapper: (d, _) => d.amount,
                    pointColorMapper: (d, _) => d.color,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(6),
                    ),
                    width: 0.55,
                    animationDuration: 950,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fadeBlackColor,
                      ),
                      builder: (dynamic data, dynamic point, dynamic series,
                          int pointIndex, int seriesIndex) {
                        final amount = (data as CategoryData).amount;
                        return Text(
                          NumberFormat.compact().format(amount),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fadeBlackColor,
                          ),
                        );
                      },
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

  List<CategoryData> _prepareChartData(TransactionAnalyticsState state) {
    final categories = state.analyticsData?.data.topCategories ?? const [];
    final chartData = <CategoryData>[];
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      chartData.add(CategoryData(
        category.categoryName,
        category.totalAmount.toDouble(),
        _kAnalyticsPalette[i % _kAnalyticsPalette.length],
      ));
    }
    chartData.sort((a, b) => b.amount.compareTo(a.amount));
    return chartData;
  }

  Widget _foldableCategoryCard(
    TransactionAnalyticsState state,
    List<CategoryData> chartData,
  ) {
    final colorByName = {
      for (final c in chartData) c.category: c.color,
    };
    final total = chartData.fold<double>(0, (s, e) => s + e.amount);

    return Column(
      children: state.analyticsData?.data.topCategories.map((category) {
            final color =
                colorByName[category.categoryName] ?? AppColors.primaryColor;
            final amount = category.totalAmount.toDouble();
            final share = total <= 0 ? 0.0 : (amount / total).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ExpansionTileCard(
                baseColor: Colors.white,
                expandedColor: Colors.white,
                shadowColor: AppColors.darkBlueColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                key: Key(category.categoryName),
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.categoryName,
                            style: TextStyle(
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(share * 100).toStringAsFixed(0)}% of total',
                            style: TextStyle(
                              color: AppColors.fadeBlackColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _money.format(amount),
                      style: TextStyle(
                        color: AppColors.darkColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: TransactionListView(
                        transactions: category.transactions),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }
}

class CategoryData {
  final String category;
  final double amount;
  final Color color;

  CategoryData(this.category, this.amount, this.color);
}
