import 'package:fedha/data/local/planned_payment_progress.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

AllocationCatalog allocationCatalogFromContext(BuildContext context) {
  final billsState = context.read<BillsBloc>().state;
  final bill = billsState.bill;
  final bills = <Bill>[
    if (bill != null) ...[
      ...bill.weekly.bills,
      ...bill.monthly.bills,
      ...bill.annually.bills,
    ],
  ];
  // Deduplicate by id.
  final uniqueBills = <int, Bill>{for (final b in bills) b.id: b};

  return AllocationCatalog(
    bills: uniqueBills.values.toList(),
    plannedPayments:
        context.read<PlannedPaymentBloc>().state.plannedPayments,
    budgets: context.read<UserBudgetBloc>().state.userBudgets?.budgets ??
        const [],
    goals: context.read<GoalsBloc>().state.goals ?? const [],
  );
}

Future<void> ensureAllocationCatalogLoaded(BuildContext context) async {
  final bills = context.read<BillsBloc>();
  if (bills.state.status == ServiceStatus.initial || bills.state.bill == null) {
    bills.add(StartBillsBloc());
  }
  final budgets = context.read<UserBudgetBloc>();
  if (budgets.state.status == ServiceStatus.initial ||
      budgets.state.userBudgets == null) {
    budgets.add(FetchAllUserBudgetsEvent());
  }
  final goals = context.read<GoalsBloc>();
  if (goals.state.status == ServiceStatus.initial || goals.state.goals == null) {
    goals.add(FetchAllGoalsEvent());
  }
  final planned = context.read<PlannedPaymentBloc>();
  if (planned.state.plannedPayments.isEmpty) {
    planned.add(const PlannedPaymentEvent.fetched());
  }
}

Future<void> showAllocationLinkSheet(
  BuildContext context,
  Transaction transaction, {
  List<AllocationMatchCandidate>? preferredMatches,
}) async {
  await ensureAllocationCatalogLoaded(context);
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _AllocationLinkSheet(
        transaction: transaction,
        preferredMatches: preferredMatches ?? const [],
      );
    },
  );
}

Future<bool?> showAllocationMatchConfirmDialog(
  BuildContext context, {
  required Transaction transaction,
  required AllocationMatchCandidate match,
}) {
  final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 2);
  final currency = (transaction.currency ?? 'KES').trim().isEmpty
      ? 'KES'
      : (transaction.currency ?? 'KES');
  final txMoney = NumberFormat.currency(
    symbol: '$currency ',
    decimalDigits: 2,
  );
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Link this payment?'),
      content: Text(
        'A ${match.entityType.label.toLowerCase()} amount matches this '
        'transaction:\n\n'
        '${match.entityType.label}: ${match.entityName}\n'
        'Expected: ${money.format(match.targetAmount)}\n'
        'Transaction: ${txMoney.format(transaction.amount)}\n\n'
        'Link it to keep your ${match.entityType.label.toLowerCase()} '
        'up to date? Tap No if this payment is unrelated.',
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'No',
            style: TextStyle(
              color: AppColors.fadeBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreenColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Yes, link'),
        ),
      ],
    ),
  );
}

Future<void> saveAllocationLink({
  required Transaction transaction,
  required AllocationMatchCandidate match,
  required BuildContext context,
}) async {
  final cache = service<LocalDataCache>();
  await cache.saveTransactionLink(
    TransactionAllocationLink(
      transactionCode: transaction.transactionId,
      entityType: match.entityType,
      entityId: match.entityId,
      entityName: match.entityName,
      linkedAmount: transaction.amount.abs(),
      createdAt: DateTime.now(),
    ),
  );

  // Best-effort local progress updates using existing APIs where available.
  if (context.mounted && match.entityType == AllocationEntityType.goal) {
    final goals = context.read<GoalsBloc>().state.goals ?? const [];
    Goals? goal;
    for (final g in goals) {
      if (g.id == match.entityId) {
        goal = g;
        break;
      }
    }
    if (goal != null && goal.id != null) {
      final updated = goal.copyWith(
        amountSaved: (goal.amountSaved ?? 0) + transaction.amount.abs(),
      );
      context.read<GoalsBloc>().add(UpdateGoalEvent(goal.id!, updated));
    }
  } else if (context.mounted &&
      match.entityType == AllocationEntityType.plannedPayment) {
    final progress = await refreshPlannedPaymentLinkStatus(
      cache: cache,
      plannedPaymentId: match.entityId,
    );
    // Refresh list/detail from SQLite so Paid / Partially paid shows up.
    context.read<PlannedPaymentBloc>().add(const PlannedPaymentEvent.fetched());
    if (progress != null) {
      if (progress.isPaid) {
        showSuccess('Fully paid — linked amount covers ${match.entityName}');
        return;
      }
      if (progress.isPartial) {
        showSuccess(
          'Partially paid — '
          'KES ${progress.paidAmount.toStringAsFixed(2)} of '
          'KES ${progress.targetAmount.toStringAsFixed(2)}',
        );
        return;
      }
    }
  }

  showSuccess('Linked to ${match.entityType.label.toLowerCase()}');
}

class _AllocationLinkSheet extends StatefulWidget {
  const _AllocationLinkSheet({
    required this.transaction,
    required this.preferredMatches,
  });

  final Transaction transaction;
  final List<AllocationMatchCandidate> preferredMatches;

  @override
  State<_AllocationLinkSheet> createState() => _AllocationLinkSheetState();
}

class _AllocationLinkSheetState extends State<_AllocationLinkSheet> {
  String _query = '';
  TransactionAllocationLink? _existing;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final link = await service<LocalDataCache>()
        .loadTransactionLink(widget.transaction.transactionId);
    if (!mounted) return;
    setState(() => _existing = link);
  }

  @override
  Widget build(BuildContext context) {
    final catalog = allocationCatalogFromContext(context);
    final suggested = widget.preferredMatches.isNotEmpty
        ? widget.preferredMatches
        : TransactionAllocationMatcher.findMatches(
            widget.transaction,
            catalog,
          );
    final all = TransactionAllocationMatcher.allManualOptions(catalog)
        .where((c) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return c.entityName.toLowerCase().contains(q) ||
          c.entityType.label.toLowerCase().contains(q);
    }).toList();

    final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 2);
    final height = MediaQuery.of(context).size.height * 0.72;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Link payment',
                  style: TextStyle(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.transaction.narration} · ${money.format(widget.transaction.amount)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 12.5,
                  ),
                ),
                if (_existing != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Linked to ${_existing!.entityType.label}: ${_existing!.entityName}',
                            style: TextStyle(
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final existing = _existing;
                            await service<LocalDataCache>()
                                .removeTransactionLink(
                                    widget.transaction.transactionId);
                            if (existing != null &&
                                existing.entityType ==
                                    AllocationEntityType.plannedPayment) {
                              await refreshPlannedPaymentLinkStatus(
                                cache: service<LocalDataCache>(),
                                plannedPaymentId: existing.entityId,
                              );
                              if (context.mounted) {
                                context.read<PlannedPaymentBloc>().add(
                                      const PlannedPaymentEvent.fetched(),
                                    );
                              }
                            }
                            if (!mounted) return;
                            setState(() => _existing = null);
                            showSuccess('Link removed');
                          },
                          child: const Text('Unlink'),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search bills, planned, budgets, goals',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: AppColors.scaffoldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          if (suggested.isNotEmpty && _query.isEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                child: Text(
                  'Suggested matches',
                  style: TextStyle(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            ...suggested.take(3).map((m) => _optionTile(m, highlight: true)),
            const Divider(height: 18),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text(
                'All items',
                style: TextStyle(
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: all.isEmpty
                ? Center(
                    child: Text(
                      'No bills, planned payments, budgets or goals found.\nAdd them under Planning first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.fadeBlackColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: all.length,
                    itemBuilder: (context, index) => _optionTile(all[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(AllocationMatchCandidate match, {bool highlight = false}) {
    final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: highlight
            ? AppColors.primaryColor.withValues(alpha: 0.15)
            : AppColors.darkBlueColor.withValues(alpha: 0.08),
        child: Icon(
          _iconFor(match.entityType),
          size: 18,
          color: highlight ? AppColors.primaryColor : AppColors.darkBlueColor,
        ),
      ),
      title: Text(
        match.entityName,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        '${match.entityType.label} · ${money.format(match.targetAmount)}',
        style: TextStyle(color: AppColors.fadeBlackColor, fontSize: 12),
      ),
      trailing: const Icon(Icons.link_rounded, size: 20),
      onTap: () async {
        await saveAllocationLink(
          transaction: widget.transaction,
          match: match,
          context: context,
        );
        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  IconData _iconFor(AllocationEntityType type) {
    switch (type) {
      case AllocationEntityType.bill:
        return Icons.receipt_long_outlined;
      case AllocationEntityType.plannedPayment:
        return Icons.event_available_outlined;
      case AllocationEntityType.budget:
        return Icons.pie_chart_outline;
      case AllocationEntityType.goal:
        return Icons.flag_outlined;
    }
  }
}
