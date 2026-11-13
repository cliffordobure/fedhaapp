import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_chart_widgets.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_compute.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_trends/trrends_graph.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AnalyticsSectionArgs {
  const AnalyticsSectionArgs({
    required this.transactions,
    required this.wallets,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.onOpenAccounts,
    this.accountPreview = const [],
  });

  final List<Transaction> transactions;
  final List<Wallet> wallets;
  final DateTime? startDate;
  final DateTime? endDate;
  final String period;
  final VoidCallback onOpenAccounts;
  final List<Widget> accountPreview;
}

/// Overview — composition + trend + highlights.
class OverviewAnalyticsSection extends StatelessWidget {
  const OverviewAnalyticsSection({super.key, required this.args});
  final AnalyticsSectionArgs args;

  @override
  Widget build(BuildContext context) {
    final cur = totalsFor(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final prev = previousPeriodTotals(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final months = monthlyBuckets(txs: args.transactions, count: 6);
    final days = analyticsRange(args.startDate, args.endDate)
            .end
            .difference(analyticsRange(args.startDate, args.endDate).start)
            .inDays +
        1;
    final avgDaily = days <= 0 ? 0.0 : cur.expense / days;
    final mix = <CategorySlice>[
      if (cur.income > 0.009)
        CategorySlice(
          id: 1,
          name: 'Income',
          amount: cur.income,
          color: HomeDesign.income,
        ),
      if (cur.expense > 0.009)
        CategorySlice(
          id: 2,
          name: 'Expense',
          amount: cur.expense,
          color: HomeDesign.expense,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnalyticsKpiRow(
          income: cur.income,
          expense: cur.expense,
          incomeChange: pctChange(cur.income, prev.income),
          expenseChange: pctChange(cur.expense, prev.expense),
        ),
        const SizedBox(height: 12),
        AnalyticsInsightChips(
          items: [
            (
              LucideIcons.piggyBank,
              'Savings rate',
              '${(cur.savingsRate * 100).toStringAsFixed(0)}%',
            ),
            (
              LucideIcons.activity,
              'Avg daily spend',
              formatAnalyticsMoney(avgDaily),
            ),
            (
              LucideIcons.wallet,
              'Accounts',
              '${args.wallets.length}',
            ),
            (
              LucideIcons.scale,
              'Net',
              formatAnalyticsMoney(cur.net),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AnalyticsDonutCard(
          title: 'Cashflow overview',
          subtitle: 'See how your money is moving',
          slices: mix,
          centerLabel: 'Net cashflow',
          centerValue: formatAnalyticsMoney(cur.net.abs()),
          centerHint: cur.net < 0 ? '(Deficit)' : '(Surplus)',
          centerHintColor:
              cur.net < 0 ? HomeDesign.expense : HomeDesign.income,
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: '6-month snapshot',
          subtitle: 'Income vs expense at a glance',
          buckets: months,
          showNet: true,
        ),
        const SizedBox(height: 14),
        AnalyticsCard(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSectionHeader(
                title: 'Trend over time',
                subtitle: 'How your money moved this period',
              ),
              const SizedBox(height: 4),
              TrendLineGraphWidget(
                key: ValueKey(
                  'ov-${args.period}-${args.startDate}-${args.endDate}',
                ),
                period: args.period,
                startDate: args.startDate,
                endDate: args.endDate,
                showHeader: false,
                embedded: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
              'By account',
              style: HomeDesign.text(
                size: 15,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: args.onOpenAccounts,
              child: Text(
                'View all accounts →',
                style: HomeDesign.text(
                  size: 12,
                  weight: FontWeight.w600,
                  color: HomeDesign.green,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...args.accountPreview,
      ],
    );
  }
}

/// Cashflow — movement, patterns, net trajectory.
class CashflowAnalyticsSection extends StatelessWidget {
  const CashflowAnalyticsSection({super.key, required this.args});
  final AnalyticsSectionArgs args;

  @override
  Widget build(BuildContext context) {
    final cur = totalsFor(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final prev = previousPeriodTotals(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final months = monthlyBuckets(txs: args.transactions, count: 6);
    final weekdays = weekdaySpend(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final mix = <CategorySlice>[
      if (cur.income > 0.009)
        CategorySlice(
            id: 1, name: 'Income', amount: cur.income, color: HomeDesign.income),
      if (cur.expense > 0.009)
        CategorySlice(
            id: 2,
            name: 'Expense',
            amount: cur.expense,
            color: HomeDesign.expense),
    ];
    final best = months.isEmpty
        ? null
        : months.reduce((a, b) => a.net >= b.net ? a : b);
    final worst = months.isEmpty
        ? null
        : months.reduce((a, b) => a.net <= b.net ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnalyticsInsightChips(
          items: [
            (
              LucideIcons.piggyBank,
              'Savings rate',
              '${(cur.savingsRate * 100).toStringAsFixed(0)}%',
            ),
            (
              LucideIcons.arrowUpCircle,
              'Best month',
              best == null
                  ? '—'
                  : '${best.label} ${formatAnalyticsMoney(best.net)}',
            ),
            (
              LucideIcons.arrowDownCircle,
              'Tightest month',
              worst == null
                  ? '—'
                  : '${worst.label} ${formatAnalyticsMoney(worst.net)}',
            ),
            (
              LucideIcons.scale,
              'vs last period',
              '${pctChange(cur.net, prev.net) >= 0 ? '↑' : '↓'} ${pctChange(cur.net, prev.net).abs().toStringAsFixed(1)}%',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                label: 'Money in',
                value: formatAnalyticsMoney(cur.income),
                color: HomeDesign.income,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniStat(
                label: 'Money out',
                value: formatAnalyticsMoney(cur.expense),
                color: HomeDesign.expense,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MiniStat(
                label: 'Net',
                value: formatAnalyticsMoney(cur.net),
                color: cur.net >= 0 ? HomeDesign.income : HomeDesign.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AnalyticsCard(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSectionHeader(
                title: 'Cashflow trend',
                subtitle: 'Track money in and out over time',
              ),
              TrendLineGraphWidget(
                key: ValueKey(
                  'cf-${args.period}-${args.startDate}-${args.endDate}',
                ),
                period: args.period,
                startDate: args.startDate,
                endDate: args.endDate,
                showHeader: false,
                embedded: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: 'Monthly net path',
          subtitle: 'Bars for income & expense, line for net',
          buckets: months,
          showNet: true,
        ),
        const SizedBox(height: 14),
        AnalyticsDonutCard(
          title: 'In vs out',
          subtitle: 'Share of total money movement',
          slices: mix,
          centerLabel: 'Flow',
          centerValue: formatAnalyticsMoney(cur.flow),
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: 'Spend by weekday',
          subtitle: 'Where expenses cluster during the week',
          buckets: weekdays,
          showIncome: false,
          showExpense: true,
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: HomeDesign.text(size: 10.5, color: HomeDesign.muted)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HomeDesign.text(
              size: 13,
              weight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Income — sources, trend, top credits.
class IncomeAnalyticsSection extends StatefulWidget {
  const IncomeAnalyticsSection({super.key, required this.args});
  final AnalyticsSectionArgs args;

  @override
  State<IncomeAnalyticsSection> createState() => _IncomeAnalyticsSectionState();
}

class _IncomeAnalyticsSectionState extends State<IncomeAnalyticsSection> {
  Map<int, String> _names = const {};

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final cache = service<LocalDataCache>();
    final income = await cache.loadIncomeCategories() ?? const [];
    final expense = await cache.loadExpenseCategories();
    final map = <int, String>{};
    for (final c in income) {
      map[c.id] = c.name;
    }
    for (final c in expense?.data ?? const []) {
      map[c.id] = c.name;
    }
    if (!mounted) return;
    setState(() => _names = map);
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final cur = totalsFor(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final prev = previousPeriodTotals(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final cats = categoryBreakdown(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
      type: TransactionType.credit,
      categoryNames: _names,
    );
    final months = monthlyBuckets(txs: args.transactions, count: 6);
    final top = topTransactions(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
      type: TransactionType.credit,
    );
    final change = pctChange(cur.income, prev.income);
    final days = analyticsRange(args.startDate, args.endDate)
            .end
            .difference(analyticsRange(args.startDate, args.endDate).start)
            .inDays +
        1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnalyticsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: HomeDesign.mint,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(LucideIcons.trendingUp,
                        size: 17, color: HomeDesign.income),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Total income',
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: HomeDesign.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatAnalyticsMoney(cur.income, compact: false),
                style: HomeDesign.text(
                  size: 28,
                  weight: FontWeight.w700,
                  color: HomeDesign.income,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}% vs previous period',
                style: HomeDesign.text(
                  size: 12,
                  weight: FontWeight.w600,
                  color: HomeDesign.income,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnalyticsInsightChips(
          items: [
            (
              LucideIcons.calendar,
              'Avg / day',
              formatAnalyticsMoney(days <= 0 ? 0 : cur.income / days),
            ),
            (
              LucideIcons.layers,
              'Sources',
              '${cats.length}',
            ),
            (
              LucideIcons.percent,
              'Of cashflow',
              '${(cur.incomeShare * 100).round()}%',
            ),
          ],
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: 'Income over months',
          subtitle: 'How credits have grown',
          buckets: months,
          showIncome: true,
          showExpense: false,
        ),
        const SizedBox(height: 14),
        AnalyticsDonutCard(
          title: 'Income by category',
          subtitle: 'Where money is coming from',
          slices: cats,
          centerLabel: 'Income',
          centerValue: formatAnalyticsMoney(cur.income),
        ),
        const SizedBox(height: 14),
        AnalyticsRankedBars(
          title: 'Top income sources',
          subtitle: 'Ranked by amount this period',
          slices: cats,
        ),
        const SizedBox(height: 14),
        AnalyticsTopTxList(
          title: 'Largest credits',
          items: top,
          accent: HomeDesign.income,
        ),
      ],
    );
  }
}

/// Expense — categories, burn, top debits.
class ExpenseAnalyticsSection extends StatefulWidget {
  const ExpenseAnalyticsSection({super.key, required this.args});
  final AnalyticsSectionArgs args;

  @override
  State<ExpenseAnalyticsSection> createState() =>
      _ExpenseAnalyticsSectionState();
}

class _ExpenseAnalyticsSectionState extends State<ExpenseAnalyticsSection> {
  Map<int, String> _names = const {};

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final cache = service<LocalDataCache>();
    final income = await cache.loadIncomeCategories() ?? const [];
    final expense = await cache.loadExpenseCategories();
    final map = <int, String>{};
    for (final c in income) {
      map[c.id] = c.name;
    }
    for (final c in expense?.data ?? const []) {
      map[c.id] = c.name;
    }
    if (!mounted) return;
    setState(() => _names = map);
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final cur = totalsFor(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final prev = previousPeriodTotals(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final cats = categoryBreakdown(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
      type: TransactionType.debit,
      categoryNames: _names,
    );
    final months = monthlyBuckets(txs: args.transactions, count: 6);
    final weekdays = weekdaySpend(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
    );
    final top = topTransactions(
      txs: args.transactions,
      start: args.startDate,
      end: args.endDate,
      type: TransactionType.debit,
    );
    final change = pctChange(cur.expense, prev.expense);
    final range = analyticsRange(args.startDate, args.endDate);
    final days = range.end.difference(range.start).inDays + 1;
    final burn = days <= 0 ? 0.0 : cur.expense / days;
    final projected = burn * DateTime(range.end.year, range.end.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnalyticsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(LucideIcons.trendingDown,
                        size: 17, color: HomeDesign.expense),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Total expense',
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: HomeDesign.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatAnalyticsMoney(cur.expense, compact: false),
                style: HomeDesign.text(
                  size: 28,
                  weight: FontWeight.w700,
                  color: HomeDesign.expense,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}% vs previous period',
                style: HomeDesign.text(
                  size: 12,
                  weight: FontWeight.w600,
                  color: HomeDesign.expense,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnalyticsInsightChips(
          items: [
            (
              LucideIcons.flame,
              'Daily burn',
              formatAnalyticsMoney(burn),
            ),
            (
              LucideIcons.calendarRange,
              'Month pace',
              formatAnalyticsMoney(projected),
            ),
            (
              LucideIcons.pieChart,
              'Of cashflow',
              '${(cur.expenseShare * 100).round()}%',
            ),
          ],
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: 'Expense over months',
          subtitle: 'Spending trajectory',
          buckets: months,
          showIncome: false,
          showExpense: true,
        ),
        const SizedBox(height: 14),
        AnalyticsDonutCard(
          title: 'Expense by category',
          subtitle: 'Where money is going',
          slices: cats,
          centerLabel: 'Spent',
          centerValue: formatAnalyticsMoney(cur.expense),
        ),
        const SizedBox(height: 14),
        AnalyticsRankedBars(
          title: 'Top spending categories',
          subtitle: 'Ranked by amount this period',
          slices: cats,
        ),
        const SizedBox(height: 14),
        AnalyticsCompareBars(
          title: 'Weekday spending',
          subtitle: 'Which days cost you more',
          buckets: weekdays,
          showIncome: false,
          showExpense: true,
        ),
        const SizedBox(height: 14),
        AnalyticsTopTxList(
          title: 'Largest expenses',
          items: top,
          accent: HomeDesign.expense,
        ),
      ],
    );
  }
}

/// Goals — progress portfolio with charts.
class GoalsAnalyticsSection extends StatefulWidget {
  const GoalsAnalyticsSection({super.key});

  @override
  State<GoalsAnalyticsSection> createState() => _GoalsAnalyticsSectionState();
}

class _GoalsAnalyticsSectionState extends State<GoalsAnalyticsSection> {
  @override
  void initState() {
    super.initState();
    context.read<GoalsBloc>().add(FetchAllGoalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final goals = state.goals ?? const <Goals>[];
        final active = goals
            .where((g) => (g.status ?? 'active').toLowerCase() != 'achieved')
            .toList();
        final achieved = goals
            .where((g) => (g.status ?? '').toLowerCase() == 'achieved')
            .toList();
        final target =
            goals.fold<double>(0, (s, g) => s + (g.targetAmount ?? 0));
        final saved =
            goals.fold<double>(0, (s, g) => s + (g.amountSaved ?? 0));
        final remaining = (target - saved).clamp(0, double.infinity);
        final ratio = target <= 0 ? 0.0 : (saved / target).clamp(0.0, 1.0);

        final slices = <CategorySlice>[
          if (saved > 0.009)
            CategorySlice(
              id: 1,
              name: 'Saved',
              amount: saved,
              color: HomeDesign.income,
            ),
          if (remaining > 0.009)
            CategorySlice(
              id: 2,
              name: 'Remaining',
              amount: remaining.toDouble(),
              color: const Color(0xFFD1D5DB),
            ),
        ];

        if (goals.isEmpty) {
          return AnalyticsCard(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: HomeDesign.mint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.target,
                      color: HomeDesign.green, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  'No goals yet',
                  style: HomeDesign.text(
                    size: 16,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create a savings goal to track progress here.',
                  textAlign: TextAlign.center,
                  style: HomeDesign.text(size: 12.5, color: HomeDesign.muted),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pushNamed(Routes.goals),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HomeDesign.greenDeep,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Create a goal',
                      style: HomeDesign.text(
                        size: 13,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnalyticsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goals portfolio',
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: HomeDesign.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(ratio * 100).toStringAsFixed(0)}% funded',
                    style: HomeDesign.text(
                      size: 26,
                      weight: FontWeight.w700,
                      color: HomeDesign.greenDeep,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ratio.clamp(0.02, 1.0),
                      minHeight: 10,
                      backgroundColor: const Color(0xFFE8ECF0),
                      valueColor:
                          const AlwaysStoppedAnimation(HomeDesign.green),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          label: 'Target',
                          value: formatAnalyticsMoney(target),
                          color: HomeDesign.ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniStat(
                          label: 'Saved',
                          value: formatAnalyticsMoney(saved),
                          color: HomeDesign.income,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniStat(
                          label: 'Left',
                          value: formatAnalyticsMoney(remaining.toDouble()),
                          color: HomeDesign.expense,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnalyticsInsightChips(
              items: [
                (LucideIcons.flag, 'Active', '${active.length}'),
                (LucideIcons.trophy, 'Achieved', '${achieved.length}'),
                (
                  LucideIcons.target,
                  'Goals',
                  '${goals.length}',
                ),
              ],
            ),
            const SizedBox(height: 14),
            AnalyticsDonutCard(
              title: 'Funding mix',
              subtitle: 'Saved vs remaining across all goals',
              slices: slices,
              centerLabel: 'Progress',
              centerValue: '${(ratio * 100).round()}%',
            ),
            const SizedBox(height: 14),
            AnalyticsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AnalyticsSectionHeader(
                    title: 'Goal progress',
                    subtitle: 'Each goal toward its target',
                  ),
                  const SizedBox(height: 12),
                  for (final g in goals) ...[
                    _GoalProgressRow(goal: g),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pushNamed(Routes.goals),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HomeDesign.greenDeep,
                        side: const BorderSide(color: HomeDesign.greenDeep),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Open My Goals',
                        style: HomeDesign.text(
                          size: 13,
                          weight: FontWeight.w700,
                          color: HomeDesign.greenDeep,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GoalProgressRow extends StatelessWidget {
  const _GoalProgressRow({required this.goal});
  final Goals goal;

  @override
  Widget build(BuildContext context) {
    final target = goal.targetAmount ?? 0;
    final saved = goal.amountSaved ?? 0;
    final ratio = target <= 0 ? 0.0 : (saved / target).clamp(0.0, 1.0);
    final name = goal.name?.trim().isNotEmpty == true ? goal.name! : 'Goal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HomeDesign.text(
                  size: 13,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                ),
              ),
            ),
            Text(
              '${(ratio * 100).round()}%',
              style: HomeDesign.text(
                size: 12,
                weight: FontWeight.w700,
                color: HomeDesign.greenDeep,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${formatAnalyticsMoney(saved)} of ${formatAnalyticsMoney(target)}',
          style: HomeDesign.text(size: 11, color: HomeDesign.muted),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.02, 1.0),
            minHeight: 8,
            backgroundColor: const Color(0xFFE8ECF0),
            valueColor: const AlwaysStoppedAnimation(HomeDesign.green),
          ),
        ),
      ],
    );
  }
}
