import 'dart:math' as math;

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/analytics/financial_wallet.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/features/app/blocs/new_analytics/new_analytic_bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_report_sheet.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_sections.dart';
import 'package:fedha/features/dashboard/components/analytics/widgets/error_state.dart';
import 'package:fedha/features/dashboard/components/analytics/widgets/foldable_card.dart';
import 'package:fedha/features/dashboard/components/analytics/widgets/foldable_card_all.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/utils/analytics_period.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with AutomaticKeepAliveClientMixin<AnalyticsScreen> {
  String _selectedPeriod = 'this_month';
  DateTime? startDate;
  DateTime? endDate;
  late List<DateTime?> _dates;

  /// 0 = Overview, 1 = By account
  int _scopeTab = 0;

  /// Overview | Cashflow | Income | Expense | Goals
  int _sectionTab = 0;

  final _money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
  final _compact =
      NumberFormat.compactCurrency(symbol: 'KES ', decimalDigits: 1);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setMonthDateRange();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    context.read<TransactionsBloc>().add(RefreshTransactions());
    context.read<NewAnalyticBloc>().add(
          NewAnalyticEvent.fetched(
            period: _selectedPeriod,
            startDate: startDate,
            endDate: endDate,
          ),
        );
  }

  String get _chartPeriod =>
      _selectedPeriod == 'custom' ? 'custom' : _selectedPeriod;

  String get _periodLabel {
    switch (_selectedPeriod) {
      case 'this_day':
        return 'Day';
      case 'this_week':
        return 'Week';
      case 'this_year':
        return 'Year';
      case 'custom':
        return 'Custom range';
      case 'this_month':
      default:
        return 'Month';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(minScaleFactor: 0.95, maxScaleFactor: 1.0),
        ),
        child: RefreshIndicator(
          color: HomeDesign.green,
          displacement: 48,
          onRefresh: _fetchAnalytics,
          child: BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (context, txState) {
              return BlocBuilder<NewAnalyticBloc, NewAnalyticState>(
                builder: (context, state) {
                  final hasLocal = txState.transactions.isNotEmpty;
                  if (state.status == NewAnalyticStatus.loading && !hasLocal) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == NewAnalyticStatus.failure &&
                      !hasLocal &&
                      context.read<WalletsBloc>().state.wallets.isEmpty) {
                    return buildErrorState(
                      context,
                      state.failure?.error ?? 'Error loading data',
                      _fetchAnalytics,
                    );
                  }
                  return _buildDashboard(
                    state,
                    txState.transactions,
                    topPad,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    NewAnalyticState state,
    List<Transaction> transactions,
    double topPad,
  ) {
    final overview = _totalsFor(transactions, null);
    final previous = _previousPeriodTotals(transactions);
    final wallets = context.read<WalletsBloc>().state.wallets;
    final net = overview.income - overview.expense;
    final netChange = _pctChange(net, previous.income - previous.expense);
    final incomeChange = _pctChange(overview.income, previous.income);
    final expenseChange = _pctChange(overview.expense, previous.expense);
    final monthBars = _lastThreeMonthNets(transactions);
    final showNetHero = _scopeTab == 0 && (_sectionTab == 0 || _sectionTab == 1);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 8, 20, 0),
            child: _buildPageHeader(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: _buildScopeToggle(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTabs(),
              const SizedBox(height: 12),
              _buildFilterRow(),
              const SizedBox(height: 14),
              if (showNetHero) ...[
                _NetCashflowHero(
                  net: net,
                  changePct: netChange,
                  bars: monthBars,
                  money: _money,
                ),
                const SizedBox(height: 14),
              ],
              if (_scopeTab == 1) ...[
                _buildIncomeExpenseRow(
                  overview,
                  incomeChange,
                  expenseChange,
                ),
                const SizedBox(height: 18),
                _sectionLinkHeader(
                  title: 'By account',
                  action: 'View all accounts',
                  onTap: null,
                ),
                const SizedBox(height: 10),
                if (wallets.isEmpty && state.wallets.isEmpty)
                  _buildEmptyWallets()
                else ...[
                  ..._buildWalletsList(state, wallets, transactions),
                  _buildAllWalletsCard(state, wallets, overview),
                ],
              ] else
                _buildSectionBody(
                  state: state,
                  transactions: transactions,
                  wallets: wallets,
                ),
              const SizedBox(height: 16),
              _GenerateReportCard(
                transactions: transactions,
                wallets: wallets,
                startDate: startDate,
                endDate: endDate,
                periodLabel: _periodLabel,
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionBody({
    required NewAnalyticState state,
    required List<Transaction> transactions,
    required List<Wallet> wallets,
  }) {
    final args = AnalyticsSectionArgs(
      transactions: transactions,
      wallets: wallets,
      startDate: startDate,
      endDate: endDate,
      period: _chartPeriod,
      onOpenAccounts: () => setState(() => _scopeTab = 1),
      accountPreview: _buildAccountPreview(state, wallets, transactions),
    );

    switch (_sectionTab) {
      case 1:
        return CashflowAnalyticsSection(args: args);
      case 2:
        return IncomeAnalyticsSection(args: args);
      case 3:
        return ExpenseAnalyticsSection(args: args);
      case 4:
        return const GoalsAnalyticsSection();
      case 0:
      default:
        return OverviewAnalyticsSection(args: args);
    }
  }

  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics',
                style: HomeDesign.text(
                  size: 26,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Understand your money, make better decisions',
                style: HomeDesign.text(
                  size: 12.5,
                  color: HomeDesign.muted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: _showPeriodMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.calendarDays,
                      size: 14, color: HomeDesign.greenDeep),
                  const SizedBox(width: 6),
                  Text(
                    _periodLabel,
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronDown,
                      size: 14, color: HomeDesign.muted),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPeriodMenu() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              for (final item in [
                ...kCashFlowPeriods.map((e) => (e.key, e.label)),
                ('custom', 'Custom range'),
              ])
                ListTile(
                  title: Text(
                    item.$2,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                  trailing: _selectedPeriod == item.$1
                      ? const Icon(LucideIcons.check,
                          color: HomeDesign.green, size: 18)
                      : null,
                  onTap: () => Navigator.pop(ctx, item.$1),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (choice == null) return;
    await _onPeriodTap(choice);
  }

  Widget _buildScopeToggle() {
    return Row(
      children: [
        Expanded(
          child: _ScopeChip(
            label: 'Overview',
            icon: LucideIcons.barChart3,
            selected: _scopeTab == 0,
            onTap: () => setState(() => _scopeTab = 0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ScopeChip(
            label: 'By account',
            icon: LucideIcons.user,
            selected: _scopeTab == 1,
            onTap: () => setState(() => _scopeTab = 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTabs() {
    const tabs = ['Overview', 'Cashflow', 'Income', 'Expense', 'Goals'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, i) {
          final selected = _sectionTab == i;
          return GestureDetector(
            onTap: () => setState(() => _sectionTab = i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tabs[i],
                  style: HomeDesign.text(
                    size: 13.5,
                    weight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? HomeDesign.ink : HomeDesign.muted,
                  ),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2.5,
                  width: selected ? 22 : 0,
                  decoration: BoxDecoration(
                    color: HomeDesign.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterRow() {
    final startStr = startDate != null
        ? DateFormat('d MMM yyyy').format(startDate!)
        : 'Start';
    final endStr =
        endDate != null ? DateFormat('d MMM yyyy').format(endDate!) : 'End';

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await _showCustomDatePicker();
                setState(() => _selectedPeriod = 'custom');
                _fetchAnalytics();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar,
                        size: 15, color: HomeDesign.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$startStr  →  $endStr',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeDesign.text(
                          size: 12,
                          weight: FontWeight.w600,
                          color: HomeDesign.ink,
                        ),
                      ),
                    ),
                    const Icon(LucideIcons.chevronDown,
                        size: 14, color: HomeDesign.muted),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _showPeriodMenu,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.slidersHorizontal,
                      size: 15, color: HomeDesign.muted),
                  const SizedBox(width: 6),
                  Text(
                    'Filters',
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseRow(
    ({double income, double expense}) overview,
    double incomeChange,
    double expenseChange,
  ) {
    return Row(
      children: [
        Expanded(
          child: _KpiMiniCard(
            label: 'Total Income',
            value: overview.income,
            changePct: incomeChange,
            accent: HomeDesign.income,
            iconBg: HomeDesign.mint,
            icon: LucideIcons.trendingUp,
            money: _money,
            compact: _compact,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiMiniCard(
            label: 'Total Expense',
            value: overview.expense,
            changePct: expenseChange,
            accent: HomeDesign.expense,
            iconBg: const Color(0xFFFFECEC),
            icon: LucideIcons.trendingDown,
            money: _money,
            compact: _compact,
          ),
        ),
      ],
    );
  }

  Widget _sectionLinkHeader({
    required String title,
    required String action,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const Spacer(),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              '$action →',
              style: HomeDesign.text(
                size: 12,
                weight: FontWeight.w600,
                color: HomeDesign.green,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildAccountPreview(
    NewAnalyticState state,
    List<Wallet> wallets,
    List<Transaction> transactions,
  ) {
    if (wallets.isEmpty) {
      return [_buildEmptyWallets()];
    }
    final preview = wallets.take(3).toList();
    return [
      for (final w in preview)
        _AccountSummaryTile(
          wallet: w,
          totals: _resolveWalletTotals(
            transactions,
            w.id,
            _apiWalletFor(state, w.bankId),
          ),
          money: _money,
          onTap: () => setState(() => _scopeTab = 1),
        ),
    ];
  }

  FinancialWallet? _apiWalletFor(NewAnalyticState state, int bankId) {
    for (final w in state.wallets) {
      if (w.bankId == bankId) return w;
    }
    return null;
  }

  Widget _buildEmptyWallets() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.wallet,
              size: 28, color: HomeDesign.muted.withValues(alpha: 0.8)),
          const SizedBox(height: 10),
          Text(
            'No wallets available',
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a wallet to start tracking your finances',
            textAlign: TextAlign.center,
            style: HomeDesign.text(size: 12, color: HomeDesign.muted),
          ),
        ],
      ),
    );
  }

  Future<void> _onPeriodTap(String period) async {
    if (period == 'custom') {
      if (_selectedPeriod != 'custom') {
        setState(() => _selectedPeriod = period);
      }
      await _showCustomDatePicker();
    } else {
      setState(() => _selectedPeriod = period);
      _applyPeriodRange(period);
    }
    _fetchAnalytics();
  }

  void _applyPeriodRange(String period) {
    final range = cashFlowPeriodRange(period);
    setState(() {
      startDate = range.start;
      endDate = range.end;
      _dates = [startDate, endDate];
    });
  }

  void _setMonthDateRange() => _applyPeriodRange('this_month');

  Future<void> _showCustomDatePicker() async {
    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    );

    if (result != null && result.length == 2) {
      setState(() {
        startDate = result[0];
        endDate = result[1];
        _dates = result;
      });
    }
  }

  List<Widget> _buildWalletsList(
    NewAnalyticState state,
    List<Wallet> walletsState,
    List<Transaction> transactions,
  ) {
    final displayedBankIds = <String>{};
    if (walletsState.isEmpty) return const <Widget>[];

    return walletsState.map((walletData) {
      final bankId = walletData.bankId.toString();
      final showImage = !displayedBankIds.contains(bankId);
      displayedBankIds.add(bankId);
      final apiWallet = _apiWalletFor(state, walletData.bankId);
      final totals =
          _resolveWalletTotals(transactions, walletData.id, apiWallet);

      return FoldableCard(
        wallet: walletData,
        income: totals.income,
        accountName: walletData.institutionName?.isNotEmpty == true
            ? walletData.institutionName!
            : walletData.name,
        expense: totals.expense,
        spendings: 1,
        budget: 1,
        currency: walletData.currency ?? 'KES',
        showImage: showImage,
        period: Period(start: startDate, end: endDate),
        periodType: _selectedPeriod,
      );
    }).toList();
  }

  Widget _buildAllWalletsCard(
    NewAnalyticState state,
    List<Wallet> walletsState,
    ({double income, double expense}) overview,
  ) {
    if (walletsState.isEmpty && state.wallets.isEmpty) {
      return const SizedBox.shrink();
    }
    return FoldableCardAll(
      income: overview.income,
      accountName: 'All wallets',
      expense: overview.expense,
      spendings: 1,
      budget: 1,
      currency: 'KES',
      wallets: walletsState,
      periodType: _selectedPeriod,
      period: Period(start: startDate, end: endDate),
    );
  }

  ({double income, double expense}) _resolveWalletTotals(
    List<Transaction> transactions,
    int walletId,
    FinancialWallet? wallet,
  ) {
    if (transactions.isNotEmpty) {
      return _totalsFor(transactions, walletId);
    }
    final apiIncome = wallet?.data.data[_selectedPeriod]?.totalIncome ?? 0.0;
    final apiExpense = wallet?.data.data[_selectedPeriod]?.totalExpense ?? 0.0;
    return (income: apiIncome, expense: apiExpense);
  }

  ({double income, double expense}) _totalsFor(
    List<Transaction> txs,
    int? walletId, {
    DateTime? from,
    DateTime? to,
  }) {
    final rangeStart = from ??
        startDate ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    final rangeEndDay = to ?? endDate ?? DateTime.now();
    final rangeEnd = DateTime(
      rangeEndDay.year,
      rangeEndDay.month,
      rangeEndDay.day,
      23,
      59,
      59,
    );

    var income = 0.0;
    var expense = 0.0;
    for (final t in txs) {
      if (walletId != null && t.walletId != walletId) continue;
      if (narrationIsInternalTransfer(t.narration)) continue;
      final date = t.date ?? t.createdAt;
      if (date != null) {
        if (date.isBefore(rangeStart) || date.isAfter(rangeEnd)) continue;
      }
      if (t.type == TransactionType.credit) {
        income += t.amount;
      } else {
        expense += t.amount + (t.charges ?? 0);
      }
    }
    return (income: income, expense: expense);
  }

  ({double income, double expense}) _previousPeriodTotals(
    List<Transaction> txs,
  ) {
    final start = startDate ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    final end = endDate ?? DateTime.now();
    final days = end.difference(start).inDays + 1;
    final prevEnd = start.subtract(const Duration(days: 1));
    final prevStart = prevEnd.subtract(Duration(days: days - 1));
    return _totalsFor(txs, null, from: prevStart, to: prevEnd);
  }

  double _pctChange(double current, double previous) {
    if (previous.abs() < 0.009) {
      if (current.abs() < 0.009) return 0;
      return 100;
    }
    return ((current - previous) / previous.abs()) * 100;
  }

  List<_MonthBar> _lastThreeMonthNets(List<Transaction> txs) {
    final now = DateTime.now();
    final bars = <_MonthBar>[];
    for (var i = 2; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final end = DateTime(month.year, month.month + 1, 0);
      final t = _totalsFor(txs, null, from: month, to: end);
      bars.add(
        _MonthBar(
          label: DateFormat('MMM').format(month),
          value: (t.income - t.expense).abs(),
          signed: t.income - t.expense,
          highlight: i == 0,
        ),
      );
    }
    return bars;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI pieces
// ─────────────────────────────────────────────────────────────────────────────

class _MonthBar {
  const _MonthBar({
    required this.label,
    required this.value,
    required this.signed,
    required this.highlight,
  });
  final String label;
  final double value;
  final double signed;
  final bool highlight;
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? HomeDesign.green : const Color(0xFFE5E7EB),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? HomeDesign.green : HomeDesign.muted,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: HomeDesign.text(
                  size: 13,
                  weight: FontWeight.w600,
                  color: selected ? HomeDesign.ink : HomeDesign.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetCashflowHero extends StatelessWidget {
  const _NetCashflowHero({
    required this.net,
    required this.changePct,
    required this.bars,
    required this.money,
  });

  final double net;
  final double changePct;
  final List<_MonthBar> bars;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final ahead = net >= 0;
    final maxBar = bars.fold<double>(1, (m, b) => math.max(m, b.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A3326),
            Color(0xFF0B3D2E),
            Color(0xFF0F5C3D),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: HomeDesign.greenDeep.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Net cashflow',
                      style: HomeDesign.text(
                        size: 12.5,
                        weight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      LucideIcons.info,
                      size: 13,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  money.format(net),
                  style: HomeDesign.text(
                    size: 24,
                    weight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${changePct >= 0 ? '↑' : '↓'} ${changePct.abs().toStringAsFixed(1)}% vs last month',
                  style: HomeDesign.text(
                    size: 11.5,
                    weight: FontWeight.w500,
                    color: const Color(0xFF9AF0B5),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ahead
                            ? LucideIcons.trendingUp
                            : LucideIcons.trendingDown,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          ahead
                              ? "You're ahead of spending."
                              : "You're ahead of income.",
                          style: HomeDesign.text(
                            size: 10.5,
                            weight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 110,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _MiniAxis(max: maxBar),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (final b in bars) ...[
                                Expanded(
                                  child: _MiniBarColumn(
                                    bar: b,
                                    max: maxBar,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAxis extends StatelessWidget {
  const _MiniAxis({required this.max});
  final double max;

  @override
  Widget build(BuildContext context) {
    final top = max <= 0 ? '0' : NumberFormat.compact().format(max);
    final mid = max <= 0 ? '0' : NumberFormat.compact().format(max / 2);
    return SizedBox(
      width: 22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(top,
              style: HomeDesign.text(
                  size: 8, color: Colors.white.withValues(alpha: 0.55))),
          Text(mid,
              style: HomeDesign.text(
                  size: 8, color: Colors.white.withValues(alpha: 0.55))),
          Text('0',
              style: HomeDesign.text(
                  size: 8, color: Colors.white.withValues(alpha: 0.55))),
        ],
      ),
    );
  }
}

class _MiniBarColumn extends StatelessWidget {
  const _MiniBarColumn({required this.bar, required this.max});
  final _MonthBar bar;
  final double max;

  @override
  Widget build(BuildContext context) {
    final h = max <= 0 ? 0.08 : (bar.value / max).clamp(0.08, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: h,
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: bar.highlight
                        ? Colors.white
                        : const Color(0xFF9AF0B5).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bar.label,
            style: HomeDesign.text(
              size: 9,
              weight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiMiniCard extends StatelessWidget {
  const _KpiMiniCard({
    required this.label,
    required this.value,
    required this.changePct,
    required this.accent,
    required this.iconBg,
    required this.icon,
    required this.money,
    required this.compact,
  });

  final String label;
  final double value;
  final double changePct;
  final Color accent;
  final Color iconBg;
  final IconData icon;
  final NumberFormat money;
  final NumberFormat compact;

  @override
  Widget build(BuildContext context) {
    final text = value >= 100000 ? compact.format(value) : money.format(value);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: HomeDesign.text(size: 11.5, color: HomeDesign.muted),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HomeDesign.text(
              size: 16,
              weight: FontWeight.w700,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${changePct >= 0 ? '↑' : '↓'} ${changePct.abs().toStringAsFixed(1)}% vs last month',
            style: HomeDesign.text(
              size: 10.5,
              weight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}


class _AccountSummaryTile extends StatelessWidget {
  const _AccountSummaryTile({
    required this.wallet,
    required this.totals,
    required this.money,
    required this.onTap,
  });

  final Wallet wallet;
  final ({double income, double expense}) totals;
  final NumberFormat money;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = wallet.institutionName?.isNotEmpty == true
        ? wallet.institutionName!
        : wallet.name;
    final net = totals.income - totals.expense;
    final flow = totals.income + totals.expense;
    final expenseShare =
        flow <= 0 ? 0.0 : (totals.expense / flow).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: BankLogoImage(
                      name: wallet.name,
                      shortname: wallet.shortname,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: HomeDesign.text(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: HomeDesign.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Income ${money.format(totals.income)} · Expense ${money.format(totals.expense)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeDesign.text(
                          size: 10.5,
                          color: HomeDesign.muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: expenseShare <= 0 ? 0.02 : expenseShare,
                          minHeight: 4,
                          backgroundColor: HomeDesign.mint,
                          valueColor: const AlwaysStoppedAnimation(
                            HomeDesign.expense,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${net < 0 ? '-' : ''}${money.format(net.abs())}',
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w700,
                        color: net < 0 ? HomeDesign.expense : HomeDesign.income,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(LucideIcons.chevronDown,
                        size: 16, color: HomeDesign.muted),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenerateReportCard extends StatelessWidget {
  const _GenerateReportCard({
    required this.transactions,
    required this.wallets,
    required this.startDate,
    required this.endDate,
    required this.periodLabel,
  });

  final List<Transaction> transactions;
  final List<Wallet> wallets;
  final DateTime? startDate;
  final DateTime? endDate;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F6EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.fileText,
              size: 18,
              color: HomeDesign.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generate detailed reports',
                  style: HomeDesign.text(
                    size: 12.5,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Download detailed insights in PDF or Excel',
                  style: HomeDesign.text(size: 10.5, color: HomeDesign.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton.icon(
            onPressed: () => showAnalyticsReportSheet(
              context: context,
              transactions: transactions,
              wallets: wallets,
              startDate: startDate,
              endDate: endDate,
              periodLabel: periodLabel,
            ),
            icon: const Icon(LucideIcons.barChart2, size: 14),
            label: Text(
              'Generate report',
              style: HomeDesign.text(
                size: 11,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeDesign.greenDeep,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
