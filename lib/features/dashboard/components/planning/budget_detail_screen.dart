import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/services/payment_history_store.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/budget_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

final _money = NumberFormat('#,##0', 'en_US');
String _kes(double v) => 'KES ${_money.format(v.round())}';

const _quickAmounts = [500, 1000, 2000, 5000];

class BudgetDetailScreen extends StatefulWidget {
  const BudgetDetailScreen({super.key, required this.budget});

  final UserBudget budget;

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  List<Map<String, dynamic>> _histories = const [];
  bool _loadingHistory = true;
  bool _submitting = false;
  DateTime _paidAt = DateTime.now();

  int get _budgetId => widget.budget.id ?? 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _loadHistories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  UserBudget _latestBudget(UserBudgetState state) {
    for (final b in state.userBudgets?.budgets ?? const <UserBudget>[]) {
      if (b.id == widget.budget.id) return b;
    }
    return widget.budget;
  }

  double get _enteredAmount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '')) ?? 0;

  Future<void> _loadHistories() async {
    if (_budgetId <= 0) {
      setState(() => _loadingHistory = false);
      return;
    }
    final data = await PaymentHistoryStore.load('budget', _budgetId);
    if (!mounted) return;
    setState(() {
      _histories = data;
      _loadingHistory = false;
    });
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidAt,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(primary: HomeDesign.green),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _paidAt = DateTime(
            picked.year,
            picked.month,
            picked.day,
            now.hour,
            now.minute,
          ));
    }
  }

  Future<void> _submitPayment() async {
    if (_submitting) return;
    final amount = _enteredAmount;
    if (amount <= 0) {
      _snack('Enter a payment amount greater than 0');
      return;
    }
    if (_budgetId <= 0) {
      _snack('This budget is still syncing. Try again in a moment.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    HapticFeedback.mediumImpact();
    final note = _noteController.text.trim();
    context.read<UserBudgetBloc>().add(ContributeUserBudgetEvent(
          _budgetId,
          amount,
          note: note.isEmpty ? null : note,
          paidAt: _paidAt,
        ));
    _amountController.clear();
    _noteController.clear();
    _paidAt = DateTime.now();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _loadHistories();
    if (mounted) setState(() => _submitting = false);
  }

  Future<void> _confirmRemove(Map<String, dynamic> row) async {
    final amount = _rowAmount(row);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove payment?'),
        content: Text(
          '${_kes(amount)} will be taken off the amount spent on this budget.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: HomeDesign.expense),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    context.read<UserBudgetBloc>().add(RemoveUserBudgetPaymentEvent(
          _budgetId,
          PaymentHistoryStore.rowId(row),
          amount,
        ));
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _loadHistories();
  }

  void _openEdit(UserBudget budget) {
    showModalBottomSheet(
      showDragHandle: false,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.95,
        child: NewBudgetBottomSheet(update: true, budget: budget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBudgetBloc, UserBudgetState>(
      builder: (context, state) {
        final budget = _latestBudget(state);
        final spent = double.tryParse(budget.amount) ?? 0;
        final limit = double.tryParse(budget.budgetLimitAmount ?? '') ?? 0;
        final period = (budget.resetPeriod ?? '').toLowerCase();
        final title = budget.subcategoryName ??
            budget.category ??
            budget.budgetName ??
            'Budget';
        final periodRows = _rowsInCurrentPeriod(period);
        final periodTotal =
            periodRows.fold<double>(0, (s, r) => s + _rowAmount(r));
        final historyTotal =
            _histories.fold<double>(0, (s, r) => s + _rowAmount(r));

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F9F8),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: HomeDesign.ink),
              onPressed: () => context.pop(),
            ),
            title: Text(
              title,
              style: HomeDesign.text(
                size: 17,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Edit budget',
                onPressed: () => _openEdit(budget),
                icon: const Icon(LucideIcons.pencil,
                    size: 20, color: HomeDesign.ink),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: HomeDesign.green,
            onRefresh: () async {
              context.read<UserBudgetBloc>().add(FetchAllUserBudgetsEvent());
              await _loadHistories();
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              children: [
                _SummaryCard(
                  spent: spent,
                  limit: limit,
                  period: period,
                  account: budget.associatedWallet,
                ),
                const SizedBox(height: 12),
                _PeriodStrip(
                  label: _periodLabel(period),
                  total: periodTotal,
                  count: periodRows.length,
                ),
                const SizedBox(height: 20),
                _sectionTitle('Add a payment',
                    'Log money spent so this budget stays accurate.'),
                const SizedBox(height: 12),
                _buildPaymentForm(spent, limit),
                const SizedBox(height: 26),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _sectionTitle(
                        'Payment history',
                        _histories.isEmpty
                            ? 'Payments you add appear here.'
                            : '${_histories.length} payment${_histories.length == 1 ? '' : 's'}'
                                ' · ${_kes(historyTotal)} total',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_loadingHistory)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child:
                          CircularProgressIndicator(color: HomeDesign.green),
                    ),
                  )
                else if (_histories.isEmpty)
                  _EmptyHistory()
                else
                  _HistoryList(
                    rows: _histories,
                    onRemove: _confirmRemove,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentForm(double spent, double limit) {
    final entered = _enteredAmount;
    final after = limit - spent - entered;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            style: HomeDesign.text(
              size: 22,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
            decoration: _inputDecoration('0').copyWith(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: Text(
                  'KES',
                  style: HomeDesign.text(
                    size: 14,
                    weight: FontWeight.w700,
                    color: HomeDesign.muted,
                  ),
                ),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickAmounts.map((v) {
              return ActionChip(
                label: Text('+${_money.format(v)}'),
                labelStyle: HomeDesign.text(
                  size: 12,
                  weight: FontWeight.w600,
                  color: HomeDesign.green,
                ),
                backgroundColor: HomeDesign.mint,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  final next = _enteredAmount + v;
                  _amountController.text = next == next.roundToDouble()
                      ? next.toStringAsFixed(0)
                      : next.toStringAsFixed(2);
                  _amountController.selection = TextSelection.collapsed(
                      offset: _amountController.text.length);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendar,
                            size: 16, color: HomeDesign.muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isToday(_paidAt)
                                ? 'Today'
                                : DateFormat('d MMM yyyy').format(_paidAt),
                            style: HomeDesign.text(
                                size: 13, color: HomeDesign.ink),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('What was it for? (optional)'),
          ),
          if (entered > 0 && limit > 0) ...[
            const SizedBox(height: 12),
            _PreviewLine(after: after),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitting ? null : _submitPayment,
              icon: _submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(LucideIcons.plus, size: 18),
              label: Text(
                _submitting ? 'Saving…' : 'Add payment',
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeDesign.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    HomeDesign.green.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _rowsInCurrentPeriod(String period) {
    final start = _periodStart(period);
    if (start == null) return _histories;
    return _histories.where((r) {
      final when = DateTime.tryParse('${r['created_at'] ?? ''}')?.toLocal();
      return when != null && !when.isBefore(start);
    }).toList();
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: HomeDesign.text(size: 12, color: HomeDesign.muted),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: HomeDesign.text(size: 14, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: border(const Color(0xFFE5E7EB)),
      enabledBorder: border(const Color(0xFFE5E7EB)),
      focusedBorder: border(HomeDesign.green, 1.4),
    );
  }
}

double _rowAmount(Map<String, dynamic> row) =>
    (row['amount'] as num?)?.toDouble() ??
    double.tryParse('${row['amount']}') ??
    0;

bool _isToday(DateTime d) {
  final n = DateTime.now();
  return d.year == n.year && d.month == n.month && d.day == n.day;
}

DateTime? _periodStart(String period) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (period.startsWith('day') || period == 'daily') return today;
  if (period.startsWith('week')) {
    return today.subtract(Duration(days: today.weekday - 1));
  }
  if (period.startsWith('month')) return DateTime(now.year, now.month);
  if (period.startsWith('year') || period.startsWith('annual')) {
    return DateTime(now.year);
  }
  return null;
}

String _periodLabel(String period) {
  if (period.startsWith('day') || period == 'daily') return 'Today';
  if (period.startsWith('week')) return 'This week';
  if (period.startsWith('month')) return 'This month';
  if (period.startsWith('year') || period.startsWith('annual')) {
    return 'This year';
  }
  return 'All time';
}

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE9EDEB)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.spent,
    required this.limit,
    required this.period,
    required this.account,
  });

  final double spent;
  final double limit;
  final String period;
  final String? account;

  @override
  Widget build(BuildContext context) {
    final remaining = limit - spent;
    final over = remaining < 0;
    final ratio = limit <= 0 ? 0.0 : spent / limit;
    final usedPct = (ratio * 100).round();
    final barColor = over
        ? const Color(0xFFFF8A80)
        : ratio >= 0.8
            ? const Color(0xFFFFD180)
            : const Color(0xFF9AF0B5);
    final status = over
        ? 'Over budget'
        : ratio >= 0.8
            ? 'Almost at limit'
            : 'On track';
    final periodText = period.isEmpty
        ? '—'
        : '${period[0].toUpperCase()}${period.substring(1)}';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A3326), HomeDesign.greenDeep, Color(0xFF0F5C3D)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SPENT',
                style: HomeDesign.text(
                  size: 11,
                  weight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: HomeDesign.text(
                    size: 11,
                    weight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _kes(spent),
            style: HomeDesign.text(
              size: 28,
              weight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            limit > 0 ? 'of ${_kes(limit)} limit' : 'No limit set',
            style: HomeDesign.text(
              size: 12.5,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              color: barColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: over ? 'Over by' : 'Remaining',
                  value: _kes(remaining.abs()),
                  valueColor: over ? const Color(0xFFFF8A80) : Colors.white,
                ),
              ),
              _divider(),
              Expanded(
                child: _Stat(label: 'Used', value: '$usedPct%'),
              ),
              _divider(),
              Expanded(child: _Stat(label: 'Period', value: periodText)),
            ],
          ),
          if (account != null && account!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(LucideIcons.landmark,
                    size: 14, color: Colors.white.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text(
                  'Paid from $account',
                  style: HomeDesign.text(
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white.withValues(alpha: 0.15),
      );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: HomeDesign.text(
            size: 11,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: HomeDesign.text(
            size: 14,
            weight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PeriodStrip extends StatelessWidget {
  const _PeriodStrip({
    required this.label,
    required this.total,
    required this.count,
  });

  final String label;
  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HomeDesign.mint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.calendarCheck,
                size: 16, color: HomeDesign.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label · $count payment${count == 1 ? '' : 's'}',
              style: HomeDesign.text(size: 13, color: HomeDesign.ink),
            ),
          ),
          Text(
            _kes(total),
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.after});
  final double after;

  @override
  Widget build(BuildContext context) {
    final over = after < 0;
    final color = over ? HomeDesign.expense : HomeDesign.green;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(over ? LucideIcons.alertTriangle : LucideIcons.checkCircle2,
              size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              over
                  ? 'After this payment you will be ${_kes(after.abs())} over budget'
                  : 'After this payment you will have ${_kes(after)} left',
              style: HomeDesign.text(
                size: 12.5,
                weight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: HomeDesign.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.receipt,
                size: 22, color: HomeDesign.green),
          ),
          const SizedBox(height: 10),
          Text(
            'No payments yet',
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your first payment above to start tracking this budget.',
            textAlign: TextAlign.center,
            style: HomeDesign.text(size: 12, color: HomeDesign.muted),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.rows, required this.onRemove});

  final List<Map<String, dynamic>> rows;
  final void Function(Map<String, dynamic> row) onRemove;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final r in rows) {
      final when = DateTime.tryParse('${r['created_at'] ?? ''}')?.toLocal();
      final key = when == null ? 'Earlier' : DateFormat('MMMM yyyy').format(when);
      groups.putIfAbsent(key, () => []).add(r);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.entries.map((g) {
        final total = g.value.fold<double>(0, (s, r) => s + _rowAmount(r));
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      g.key,
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w700,
                        color: HomeDesign.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _kes(total),
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w700,
                        color: HomeDesign.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    for (var i = 0; i < g.value.length; i++) ...[
                      if (i > 0)
                        const Divider(
                            height: 1, indent: 60, color: Color(0xFFEFF2F1)),
                      _HistoryTile(
                        row: g.value[i],
                        onRemove: () => onRemove(g.value[i]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.row, required this.onRemove});
  final Map<String, dynamic> row;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final amount = _rowAmount(row);
    final note = row['note']?.toString();
    final when = DateTime.tryParse('${row['created_at'] ?? ''}')?.toLocal();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HomeDesign.mint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.receipt,
                size: 16, color: HomeDesign.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note == null || note.isEmpty ? 'Payment' : note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w600,
                    color: HomeDesign.ink,
                  ),
                ),
                if (when != null)
                  Text(
                    DateFormat('EEE, d MMM · HH:mm').format(when),
                    style: HomeDesign.text(size: 11, color: HomeDesign.muted),
                  ),
              ],
            ),
          ),
          Text(
            _kes(amount),
            style: HomeDesign.text(
              size: 13,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical,
                size: 18, color: HomeDesign.muted),
            onSelected: (_) => onRemove(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'remove', child: Text('Remove payment')),
            ],
          ),
        ],
      ),
    );
  }
}
