import 'package:fedha/data/local/planned_payment_progress.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _Slice {
  const _Slice(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color;
}

/// Home section: pie of Goals / Budgets / Bills / Planned payments + advice.
class PlanningOverviewCard extends StatelessWidget {
  const PlanningOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, goalsState) {
        return BlocBuilder<UserBudgetBloc, UserBudgetState>(
          builder: (context, budgetState) {
            return BlocBuilder<BillsBloc, BillsState>(
              builder: (context, billsState) {
                return BlocBuilder<PlannedPaymentBloc, PlannedPaymentState>(
                  builder: (context, plannedState) {
                    final summary = _buildSummary(
                      goalsState: goalsState,
                      budgetState: budgetState,
                      billsState: billsState,
                      plannedState: plannedState,
                    );

                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkColor.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Money plan snapshot',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () =>
                                    context.pushNamed(Routes.planning),
                                child: Text(
                                  'Planning',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Goals, budgets, bills & planned payments',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.fadeBlackColor),
                          ),
                          if (summary.total <= 0) ...[
                            const SizedBox(height: 20),
                            _EmptyPlanningHint(
                              onTap: () => context.pushNamed(Routes.planning),
                            ),
                          ] else ...[
                            SizedBox(
                              height: 210,
                              child: SfCircularChart(
                                margin: EdgeInsets.zero,
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  textStyle: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                                series: <CircularSeries<_Slice, String>>[
                                  DoughnutSeries<_Slice, String>(
                                    dataSource: summary.slices,
                                    xValueMapper: (d, _) => d.label,
                                    yValueMapper: (d, _) => d.value,
                                    pointColorMapper: (d, _) => d.color,
                                    innerRadius: '62%',
                                    radius: '85%',
                                    dataLabelSettings:
                                        const DataLabelSettings(isVisible: false),
                                  ),
                                ],
                                annotations: <CircularChartAnnotation>[
                                  CircularChartAnnotation(
                                    widget: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'KES',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.fadeBlackColor,
                                          ),
                                        ),
                                        Text(
                                          formatAmount(summary.total),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.darkBlueColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            _AdviceBanner(advice: summary.advice),
                            const SizedBox(height: 10),
                            _MiniStatsRow(summary: summary),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  _PlanningSummary _buildSummary({
    required GoalsState goalsState,
    required UserBudgetState budgetState,
    required BillsState billsState,
    required PlannedPaymentState plannedState,
  }) {
    double goalsRemaining = 0;
    double goalsSaved = 0;
    double goalsTarget = 0;
    for (final g in goalsState.goals ?? const []) {
      final target = g.targetAmount ?? 0;
      final saved = g.amountSaved ?? 0;
      goalsTarget += target;
      goalsSaved += saved;
      goalsRemaining +=
          (target - saved).clamp(0, double.infinity).toDouble();
    }

    double budgetLimit = 0;
    double budgetSpent = 0;
    for (final b in budgetState.userBudgets?.budgets ?? const []) {
      final limit =
          double.tryParse((b.budgetLimitAmount ?? '0').replaceAll(',', '')) ??
              0;
      final spent =
          double.tryParse(b.amount.replaceAll(',', '')) ?? 0;
      budgetLimit += limit > 0 ? limit : spent;
      if (limit > 0) budgetSpent += spent;
    }
    final budgetRemaining =
        (budgetLimit - budgetSpent).clamp(0, double.infinity).toDouble();

    final billsTotal =
        (billsState.bill?.monthly.totalAmount ??
                billsState.selected?.totalAmount ??
                0)
            .toDouble()
            .clamp(0, double.infinity)
            .toDouble();

    double plannedRemaining = 0;
    double plannedTotal = 0;
    double plannedPaid = 0;
    for (final p in plannedState.plannedPayments) {
      final progress = progressForPlannedPayment(payment: p);
      plannedTotal += progress.targetAmount;
      plannedPaid += progress.paidAmount;
      plannedRemaining += progress.remaining;
    }

    final slices = <_Slice>[
      if (goalsRemaining > 0.009)
        _Slice('Goals left', goalsRemaining, AppColors.darkBlueColor),
      if (budgetRemaining > 0.009)
        _Slice('Budget left', budgetRemaining, AppColors.primaryColor),
      if (billsTotal > 0.009)
        _Slice('Bills', billsTotal, const Color(0xFFE8A838)),
      if (plannedRemaining > 0.009)
        _Slice(
            'Planned left', plannedRemaining, const Color(0xFF5B8DEF)),
    ];

    // If everything is fully funded, still show positive commitments.
    if (slices.isEmpty) {
      if (goalsTarget > 0.009) {
        slices.add(_Slice('Goals', goalsTarget, AppColors.darkBlueColor));
      }
      if (budgetLimit > 0.009) {
        slices.add(_Slice('Budgets', budgetLimit, AppColors.primaryColor));
      }
      if (billsTotal > 0.009) {
        slices.add(_Slice('Bills', billsTotal, const Color(0xFFE8A838)));
      }
      if (plannedTotal > 0.009) {
        slices.add(
            _Slice('Planned', plannedTotal, const Color(0xFF5B8DEF)));
      }
    }

    final total = slices.fold<double>(0, (s, e) => s + e.value);
    final advice = _composeAdvice(
      total: total,
      goalsRemaining: goalsRemaining,
      goalsSaved: goalsSaved,
      goalsTarget: goalsTarget,
      budgetRemaining: budgetRemaining,
      budgetLimit: budgetLimit,
      budgetSpent: budgetSpent,
      billsTotal: billsTotal,
      plannedRemaining: plannedRemaining,
      plannedTotal: plannedTotal,
      plannedPaid: plannedPaid,
    );

    return _PlanningSummary(
      slices: slices,
      total: total,
      advice: advice,
      goalsRemaining: goalsRemaining,
      budgetRemaining: budgetRemaining,
      billsTotal: billsTotal,
      plannedRemaining: plannedRemaining,
    );
  }

  String _composeAdvice({
    required double total,
    required double goalsRemaining,
    required double goalsSaved,
    required double goalsTarget,
    required double budgetRemaining,
    required double budgetLimit,
    required double budgetSpent,
    required double billsTotal,
    required double plannedRemaining,
    required double plannedTotal,
    required double plannedPaid,
  }) {
    if (total <= 0) {
      return 'Add a goal, budget, bill or planned payment to see how your money is split.';
    }

    final parts = <String>[];

    // Biggest slice
    final map = <String, double>{
      'goals still to fund': goalsRemaining,
      'budget room left': budgetRemaining,
      'monthly bills': billsTotal,
      'planned payments left': plannedRemaining,
    };
    final biggest = map.entries.reduce((a, b) => a.value >= b.value ? a : b);
    if (biggest.value > 0.009) {
      parts.add(
        '${_capitalize(biggest.key)} are your largest commitment '
        '(KES ${formatAmount(biggest.value)}).',
      );
    }

    if (goalsTarget > 0) {
      final pct = ((goalsSaved / goalsTarget) * 100).clamp(0, 100).round();
      if (pct >= 80) {
        parts.add('Goals look strong — you are about $pct% there.');
      } else if (pct >= 40) {
        parts.add('Goals are halfway-ish at $pct%. Keep the streak going.');
      } else if (goalsSaved > 0) {
        parts.add('Goals are at $pct% — small top-ups will move the needle.');
      } else {
        parts.add('No savings linked to goals yet. Start with a small transfer.');
      }
    }

    if (budgetLimit > 0) {
      final used = (budgetSpent / budgetLimit).clamp(0.0, 1.5);
      if (used >= 1) {
        parts.add('Budgets are fully used — watch spending for the rest of the period.');
      } else if (used >= 0.8) {
        parts.add('Budgets are nearly maxed (${(used * 100).round()}% used).');
      } else {
        parts.add(
          'You still have KES ${formatAmount(budgetRemaining)} of budget headroom.',
        );
      }
    }

    if (plannedTotal > 0 && plannedPaid + 0.009 >= plannedTotal) {
      parts.add('Planned payments are covered — nice work.');
    } else if (billsTotal > 0 && billsTotal >= total * 0.45) {
      parts.add('Bills dominate this month — pay those first to avoid late fees.');
    }

    return parts.take(2).join(' ');
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _PlanningSummary {
  const _PlanningSummary({
    required this.slices,
    required this.total,
    required this.advice,
    required this.goalsRemaining,
    required this.budgetRemaining,
    required this.billsTotal,
    required this.plannedRemaining,
  });

  final List<_Slice> slices;
  final double total;
  final String advice;
  final double goalsRemaining;
  final double budgetRemaining;
  final double billsTotal;
  final double plannedRemaining;
}

class _AdviceBanner extends StatelessWidget {
  const _AdviceBanner({required this.advice});
  final String advice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline,
              size: 18, color: AppColors.darkGreenColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              advice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.darkColor,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatsRow extends StatelessWidget {
  const _MiniStatsRow({required this.summary});
  final _PlanningSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Goals', summary.goalsRemaining, AppColors.darkBlueColor),
        _chip('Budget', summary.budgetRemaining, AppColors.primaryColor),
        _chip('Bills', summary.billsTotal, const Color(0xFFE8A838)),
        _chip('Planned', summary.plannedRemaining, const Color(0xFF5B8DEF)),
      ],
    );
  }

  Widget _chip(String label, double value, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.fadeBlackColor),
            ),
            Text(
              formatAmount(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPlanningHint extends StatelessWidget {
  const _EmptyPlanningHint({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline,
                color: AppColors.fadeBlackColor, size: 28),
            const SizedBox(height: 8),
            Text(
              'Nothing planned yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Create a goal, budget, bill or planned payment to unlock this chart.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.fadeBlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
