import 'dart:math' as math;

import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_modal.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/utils/analytics_period.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeQuickNav extends StatelessWidget {
  const HomeQuickNav({super.key, this.selected = 0});

  final int selected;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        label: 'Overview',
        icon: LucideIcons.lineChart,
        onTap: () {},
      ),
      _NavItem(
        label: 'Budget',
        icon: LucideIcons.pieChart,
        onTap: () => context.pushNamed(Routes.budget),
      ),
      _NavItem(
        label: 'Transactions',
        icon: LucideIcons.wallet,
        onTap: () => context.pushNamed(Routes.transactions),
      ),
      _NavItem(
        label: 'Goals',
        icon: LucideIcons.target,
        onTap: () => context.pushNamed(Routes.goals),
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _QuickNavTile(
              item: items[i],
              active: i == selected,
            ),
          ),
        ],
      ],
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _QuickNavTile extends StatelessWidget {
  const _QuickNavTile({required this.item, required this.active});

  final _NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    // Mock: soft mint rounded squares + label underneath.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: HomeDesign.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: HomeDesign.greenDeep,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: HomeDesign.text(
                  size: 10,
                  weight: active ? FontWeight.w600 : FontWeight.w500,
                  color: HomeDesign.ink,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: active ? 20 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: HomeDesign.green,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeInsightCard extends StatelessWidget {
  const HomeInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        final income = _num(state, 'incomes');
        final expense = _num(state, 'expenses');
        String title = 'Great job!';
        String body;
        if (income <= 0 && expense <= 0) {
          title = 'Get started';
          body = 'Add wallets and sync SMS to see spending insights.';
        } else if (expense <= 0) {
          body = 'No expenses recorded this period yet.';
        } else if (income > 0 && expense < income) {
          final savedPct = ((1 - expense / income) * 100).clamp(0, 99);
          body =
              'You’ve spent ${savedPct.toStringAsFixed(0)}% less than last month.';
        } else if (income > 0) {
          title = 'Heads up';
          body = 'You’re spending more than you earned this period.';
        } else {
          title = 'Keep going';
          body = 'Track income and expenses to unlock smarter insights.';
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          decoration: BoxDecoration(
            color: HomeDesign.mintSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: HomeDesign.greenDeep,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.trendingUp,
                  size: 17,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$title ',
                        style: HomeDesign.text(
                          size: 12,
                          weight: FontWeight.w700,
                          color: HomeDesign.ink,
                          height: 1.35,
                        ),
                      ),
                      TextSpan(
                        text: body,
                        style: HomeDesign.text(
                          size: 12,
                          weight: FontWeight.w400,
                          color: HomeDesign.ink,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 48,
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned.fill(
                      child: CustomPaint(painter: _MiniBarsPainter()),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: HomeDesign.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.plus,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _num(DataState state, String key) {
    final v = state.data[key];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0;
    return 0;
  }
}

class _MiniBarsPainter extends CustomPainter {
  const _MiniBarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final heights = [0.35, 0.55, 0.42, 0.82, 0.6];
    final w = size.width / (heights.length * 1.55);
    for (var i = 0; i < heights.length; i++) {
      paint.color = Color.lerp(
            const Color(0xFFB8F5C8),
            HomeDesign.green,
            i / (heights.length - 1),
          ) ??
          HomeDesign.green;
      final h = size.height * heights[i];
      final x = i * (w * 1.5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, w, h),
          const Radius.circular(2.5),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeCashFlowCard extends StatefulWidget {
  const HomeCashFlowCard({super.key});

  @override
  State<HomeCashFlowCard> createState() => _HomeCashFlowCardState();
}

class _HomeCashFlowCardState extends State<HomeCashFlowCard> {
  String _period = 'this_month';

  Future<void> _pickPeriod() async {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cash flow period',
                    style: HomeDesign.text(
                      size: 15,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
                    ),
                  ),
                ),
              ),
              for (final item in kCashFlowPeriods)
                ListTile(
                  title: Text(
                    item.label,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                  subtitle: Text(
                    _periodHint(item.key),
                    style: HomeDesign.text(size: 12, color: HomeDesign.muted),
                  ),
                  trailing: _period == item.key
                      ? const Icon(LucideIcons.check,
                          color: HomeDesign.green, size: 18)
                      : null,
                  onTap: () => Navigator.pop(ctx, item.key),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (choice == null || !mounted) return;
    setState(() => _period = choice);
  }

  String _periodHint(String key) {
    switch (key) {
      case 'this_day':
        return 'Today only';
      case 'this_week':
        return 'Monday to today';
      case 'this_year':
        return 'January to today';
      case 'this_month':
      default:
        return 'From the 1st to today';
    }
  }

  ({double income, double expense}) _totalsFromTransactions(
    List<Transaction> transactions,
  ) {
    var income = 0.0;
    var expense = 0.0;
    for (final tx in transactions) {
      if (narrationIsInternalTransfer(tx.narration)) continue;
      final when = tx.date ?? tx.createdAt;
      if (!dateInCashFlowPeriod(when, _period)) continue;
      if (tx.type == TransactionType.credit) {
        income += tx.amount;
      } else {
        expense += tx.amount + (tx.charges ?? 0);
      }
    }
    return (income: income, expense: expense);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, txState) {
        return BlocBuilder<DataBloc, DataState>(
          builder: (context, state) {
            final fromTx = _totalsFromTransactions(txState.transactions);
            final effective = state.status == ServiceStatus.loadingSuccess
                ? state
                : state.copyWith(
                    data: state.data.isEmpty
                        ? LocalDataCache.emptyHomeCard()
                        : state.data,
                  );
            // Prefer live filtered transactions; fall back to card totals for month.
            final useTx = txState.transactions.isNotEmpty;
            final income = useTx ? fromTx.income : _num(effective, 'incomes');
            final expense = useTx ? fromTx.expense : _num(effective, 'expenses');
            final saved = income - expense;
            final total = (income + expense).clamp(1, double.infinity);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Cash Flow',
                      style: HomeDesign.text(
                        size: 15,
                        weight: FontWeight.w700,
                        color: HomeDesign.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: _pickPeriod,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE6E8EB)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cashFlowPeriodLabel(_period),
                                style: HomeDesign.text(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: HomeDesign.muted,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                LucideIcons.chevronDown,
                                size: 14,
                                color: HomeDesign.muted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 20, 14, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _legendRow(
                              color: HomeDesign.income,
                              label: 'Income',
                              value: formatHomeMoney(income),
                              valueColor: HomeDesign.income,
                            ),
                            const SizedBox(height: 20),
                            _legendRow(
                              color: HomeDesign.expense,
                              label: 'Expenses',
                              value: formatHomeMoney(expense),
                              valueColor: HomeDesign.expense,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CustomPaint(
                            painter: _CashFlowDonutPainter(
                              incomeRatio: income / total,
                              expenseRatio: expense / total,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        formatHomeMoney(saved),
                                        textAlign: TextAlign.center,
                                        style: HomeDesign.text(
                                          size: 11,
                                          weight: FontWeight.w700,
                                          color: HomeDesign.ink,
                                          height: 1.1,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Saved',
                                      style: HomeDesign.text(
                                        size: 10,
                                        weight: FontWeight.w500,
                                        color: HomeDesign.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      },
    );
  }

  Widget _legendRow({
    required Color color,
    required String label,
    required String value,
    required Color valueColor,
  }) {
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
            const SizedBox(width: 8),
            Text(
              label,
              style: HomeDesign.text(
                size: 12,
                weight: FontWeight.w500,
                color: HomeDesign.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            value,
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: valueColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }

  double _num(DataState state, String key) {
    final v = state.data[key];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0;
    return 0;
  }
}

class _CashFlowDonutPainter extends CustomPainter {
  _CashFlowDonutPainter({
    required this.incomeRatio,
    required this.expenseRatio,
  });

  final double incomeRatio;
  final double expenseRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final stroke = radius * 0.28;
    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);
    final bg = Paint()
      ..color = const Color(0xFFEEF1F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, bg);

    final income = incomeRatio.clamp(0.0, 1.0);
    final expense = expenseRatio.clamp(0.0, 1.0 - income);

    final incomePaint = Paint()
      ..color = HomeDesign.income
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;
    final expensePaint = Paint()
      ..color = HomeDesign.expense
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    const start = -math.pi / 2;
    canvas.drawArc(rect, start, income * math.pi * 2, false, incomePaint);
    canvas.drawArc(
      rect,
      start + income * math.pi * 2,
      expense * math.pi * 2,
      false,
      expensePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CashFlowDonutPainter oldDelegate) =>
      oldDelegate.incomeRatio != incomeRatio ||
      oldDelegate.expenseRatio != expenseRatio;
}

class HomeRecentTransactions extends StatelessWidget {
  const HomeRecentTransactions({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final items = transactions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Transactions',
              style: HomeDesign.text(
                size: 15,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
                letterSpacing: -0.2,
              ),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: HomeDesign.green,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => context.pushNamed(Routes.transactions),
              child: Text(
                'View all',
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
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'No recorded transactions',
              textAlign: TextAlign.center,
              style: HomeDesign.text(
                size: 13,
                color: HomeDesign.muted,
              ),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 4),
                _HomeTxRow(tx: items[i]),
              ],
            ],
          ),
      ],
    );
  }
}

class _HomeTxRow extends StatelessWidget {
  const _HomeTxRow({required this.tx});

  final Transaction tx;

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.type == TransactionType.credit;
    final amount = tx.amount.abs();
    final title = tx.narration.trim().isEmpty ? 'Transaction' : tx.narration;
    final category = isCredit ? 'Income' : _categoryHint(title);
    final style = _iconStyle(category, isCredit);

    return InkWell(
      onTap: () => showTransactionDetailsModal(context, tx),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: style.$1,
                shape: BoxShape.circle,
              ),
              child: Icon(style.$2, size: 18, color: style.$3),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category,
                    style: HomeDesign.text(
                      size: 11,
                      weight: FontWeight.w400,
                      color: HomeDesign.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${formatHomeMoney(amount)}',
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: isCredit ? HomeDesign.income : HomeDesign.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _relativeDate(tx.date ?? tx.createdAt),
                  style: HomeDesign.text(
                    size: 10,
                    weight: FontWeight.w400,
                    color: HomeDesign.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static (Color, IconData, Color) _iconStyle(String category, bool credit) {
    if (credit) {
      return (HomeDesign.mint, LucideIcons.banknote, HomeDesign.green);
    }
    final c = category.toLowerCase();
    if (c.contains('fuel') || c.contains('energy')) {
      return (
        const Color(0xFFFFECEC),
        LucideIcons.fuel,
        HomeDesign.expense,
      );
    }
    if (c.contains('groc') || c.contains('shop') || c.contains('food')) {
      return (HomeDesign.mint, LucideIcons.shoppingCart, HomeDesign.green);
    }
    return (
      const Color(0xFFF1F3F5),
      LucideIcons.arrowDownLeft,
      HomeDesign.muted,
    );
  }

  static String _categoryHint(String title) {
    final t = title.toLowerCase();
    if (t.contains('fuel') || t.contains('shell') || t.contains('total')) {
      return 'Fuel';
    }
    if (t.contains('naivas') ||
        t.contains('carrefour') ||
        t.contains('supermarket') ||
        t.contains('shop')) {
      return 'Groceries';
    }
    if (t.contains('salary') || t.contains('payroll')) return 'Income';
    return 'Expense';
  }

  static String _relativeDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return formatDate(date);
  }
}
