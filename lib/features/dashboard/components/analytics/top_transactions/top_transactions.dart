import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/analytics/top_transactions/bloc/top_transactions_bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/transaction_list_view.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToopTrends extends StatelessWidget {
  const ToopTrends({
    super.key,
    required this.period,
    this.walletId,
    this.startDate,
    this.endDate,
  });

  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    // Own bloc per section — shared TopTransactionsBloc was overwritten by each card.
    return BlocProvider(
      create: (_) => TopTransactionsBloc()
        ..add(FetchtransactionsEvent(
          period,
          walletId,
          startDate: startDate,
          endDate: endDate,
        )),
      child: _TopTrendsView(
        period: period,
        walletId: walletId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }
}

class _TopTrendsView extends StatefulWidget {
  const _TopTrendsView({
    required this.period,
    this.walletId,
    this.startDate,
    this.endDate,
  });

  final String period;
  final int? walletId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  State<_TopTrendsView> createState() => _TopTrendsViewState();
}

class _TopTrendsViewState extends State<_TopTrendsView> {
  @override
  void didUpdateWidget(covariant _TopTrendsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period ||
        oldWidget.walletId != widget.walletId ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      context.read<TopTransactionsBloc>().add(FetchtransactionsEvent(
            widget.period,
            widget.walletId,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopTransactionsBloc, TopTransactionsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state.status == ServiceStatus.loadingFailure) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Text(
                  state.message?.message ?? 'Could not load top transactions',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.fadeBlackColor),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<TopTransactionsBloc>().add(
                            FetchtransactionsEvent(
                              widget.period,
                              widget.walletId,
                              startDate: widget.startDate,
                              endDate: widget.endDate,
                            ),
                          ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final incomes = state.data?.data.topIncomes ?? const [];
        final expenses = state.data?.data.topExpenses ?? const [];
        if (incomes.isEmpty && expenses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text(
              'No top transactions for this period yet',
              style: TextStyle(
                color: AppColors.fadeBlackColor,
                fontSize: 12,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (incomes.isNotEmpty) ...[
                _sectionTitle(context, 'Top income'),
                const SizedBox(height: 8),
                TransactionListView(transactions: incomes),
                const SizedBox(height: 16),
              ],
              if (expenses.isNotEmpty) ...[
                _sectionTitle(context, 'Top expense'),
                const SizedBox(height: 8),
                TransactionListView(transactions: expenses),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.darkBlueColor,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
