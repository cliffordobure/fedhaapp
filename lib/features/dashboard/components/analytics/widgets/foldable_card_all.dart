import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/features/dashboard/components/analytics/top_transactions/top_transactions.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_trends/trrends_graph.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FoldableCardAll extends StatelessWidget {
  final double income;
  final double expense;
  final String currency;
  final String accountName;
  final double spendings;
  final double budget;
  final String periodType;
  final Period? period;
  final List<Wallet> wallets;

  const FoldableCardAll({
    super.key,
    required this.income,
    required this.accountName,
    required this.expense,
    required this.spendings,
    required this.budget,
    required this.currency,
    required this.wallets,
    required this.periodType,
    this.period,
  });

  String get _resolvedPeriod => periodType;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      symbol: currency.isEmpty ? 'KES ' : '$currency ',
      decimalDigits: 0,
    );
    final flow = income + expense;
    final incomeShare = flow <= 0 ? 0.5 : (income / flow).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ExpansionTileCard(
          elevation: 0,
          shadowColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: _stackedAvatars(),
          expandedTextColor: AppColors.darkBlueColor,
          expandedColor: AppColors.scaffoldBackground.withValues(alpha: 0.55),
          baseColor: AppColors.whiteColor,
          initiallyExpanded: false,
          title: Text(
            accountName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In ${money.format(income)}  ·  Out ${money.format(expense)}',
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: incomeShare,
                    minHeight: 5,
                    backgroundColor:
                        AppColors.dangerColor.withValues(alpha: 0.18),
                    valueColor:
                        AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          label: 'Income',
                          value: money.format(income),
                          color: AppColors.primaryColor,
                          icon: Icons.trending_up_rounded,
                          onTap: () => _openReport(context, isIncome: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricTile(
                          label: 'Expense',
                          value: money.format(expense),
                          color: AppColors.dangerColor,
                          icon: Icons.trending_down_rounded,
                          onTap: () => _openReport(context, isIncome: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TrendLineGraphWidget(
                    period: _resolvedPeriod,
                    startDate: period?.start,
                    endDate: period?.end,
                    showHeader: true,
                    embedded: true,
                  ),
                  ToopTrends(
                    period: _resolvedPeriod,
                    startDate: period?.start,
                    endDate: period?.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stackedAvatars() {
    final logos = wallets.take(3).toList();
    return SizedBox(
      width: 48,
      height: 36,
      child: Stack(
        children: logos.asMap().entries.map((entry) {
          final idx = entry.key;
          final wallet = entry.value;
          return Positioned(
            left: idx * 12.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ClipOval(
                child: BankLogoImage(
                  name: wallet.name,
                  shortname: wallet.shortname,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  fallbackIconSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _openReport(BuildContext context, {required bool isIncome}) {
    final amount = isIncome ? income : expense;
    if (amount <= 0) {
      showSnackBar(
        context,
        content:
            'Record more transactions to unlock detailed ${isIncome ? 'income' : 'expense'} analytics',
        bgColor: AppColors.darkBlueColor,
      );
      return;
    }

    final queryParams = <String, String>{
      'type': isIncome ? 'income' : 'expense',
      'title': isIncome ? 'Income Report' : 'Expense Report',
      'period': periodType,
    };
    if (period?.start != null && period?.end != null) {
      queryParams['startDate'] = period!.start!.toIso8601String();
      queryParams['endDate'] = period!.end!.toIso8601String();
    }

    context.goNamed(
      Routes.transactionCategoryanalytics,
      queryParameters: queryParams,
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.fadeBlackColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, size: 16, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
