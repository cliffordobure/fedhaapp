import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/services/payment_history_store.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

final _money = NumberFormat('#,##0', 'en_US');
String _kes(double v) => 'KES ${_money.format(v.round())}';

const _quickAmounts = [500, 1000, 2000, 5000];

class GoalDetailScreen extends StatefulWidget {
  const GoalDetailScreen({super.key, required this.goal});

  final Goals goal;

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  List<Map<String, dynamic>> _histories = const [];
  bool _loadingHistory = true;
  bool _submitting = false;
  DateTime _paidAt = DateTime.now();

  int get _goalId => widget.goal.id ?? 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    if (_goalId > 0) context.read<GoalsBloc>().add(FetchGoalEvent(_goalId));
    _loadHistories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Goals _latestGoal(GoalsState state) {
    for (final g in state.goals ?? const <Goals>[]) {
      if (g.id == widget.goal.id) return g;
    }
    if (state.goal?.id == widget.goal.id) return state.goal!;
    return widget.goal;
  }

  double get _enteredAmount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '')) ?? 0;

  Future<void> _loadHistories() async {
    if (_goalId <= 0) {
      setState(() => _loadingHistory = false);
      return;
    }
    final data = await PaymentHistoryStore.load('goal', _goalId);
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
          picked.year, picked.month, picked.day, now.hour, now.minute));
    }
  }

  Future<void> _submitPayment() async {
    if (_submitting) return;
    final amount = _enteredAmount;
    if (amount <= 0) {
      _snack('Enter a payment amount greater than 0');
      return;
    }
    if (_goalId <= 0) {
      _snack('This goal is still syncing. Try again in a moment.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    HapticFeedback.mediumImpact();
    final note = _noteController.text.trim();
    context.read<GoalsBloc>().add(RechargeGoalEvent(
          _goalId,
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
            '${_kes(amount)} will be taken off the amount saved for this goal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove',
                style: TextStyle(color: HomeDesign.expense)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    context.read<GoalsBloc>().add(RemoveGoalPaymentEvent(
          _goalId,
          PaymentHistoryStore.rowId(row),
          amount,
        ));
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _loadHistories();
  }

  void _setStatus(String status) {
    if (_goalId <= 0) return;
    HapticFeedback.selectionClick();
    context.read<GoalsBloc>().add(UpdateGoalStatusEvent(_goalId, status));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final goal = _latestGoal(state);
        final saved = (goal.amountSaved ?? 0).toDouble();
        final target = (goal.targetAmount ?? 0).toDouble();
        final status = (goal.status ?? 'active').toLowerCase();
        final isPaused = status == 'pending';
        final isAchieved = status == 'archived';
        final reached = target > 0 && saved >= target;
        final accent = _goalColor(goal.color);
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
              goal.name ?? 'Goal',
              style: HomeDesign.text(
                size: 17,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
            actions: [
              if (!isAchieved)
                TextButton.icon(
                  onPressed: () => _setStatus(isPaused ? 'active' : 'pending'),
                  icon: Icon(
                    isPaused ? LucideIcons.play : LucideIcons.pause,
                    size: 16,
                    color: HomeDesign.green,
                  ),
                  label: Text(
                    isPaused ? 'Activate' : 'Pause',
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w600,
                      color: HomeDesign.green,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
            ],
          ),
          body: RefreshIndicator(
            color: HomeDesign.green,
            onRefresh: () async {
              context.read<GoalsBloc>().add(FetchAllGoalsEvent());
              await _loadHistories();
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              children: [
                _GoalSummaryCard(goal: goal, saved: saved, target: target),
                const SizedBox(height: 12),
                _PlanStrip(
                  saved: saved,
                  target: target,
                  desiredDate: goal.desiredDate,
                ),
                const SizedBox(height: 20),
                if (isAchieved)
                  _InfoBanner(
                    icon: LucideIcons.trophy,
                    color: HomeDesign.green,
                    title: 'Goal achieved',
                    message: 'Nice work! This goal is marked as achieved.',
                    actionLabel: 'Reopen goal',
                    onAction: () => _setStatus('active'),
                  )
                else if (isPaused)
                  _InfoBanner(
                    icon: LucideIcons.pauseCircle,
                    color: const Color(0xFFF59E0B),
                    title: 'This goal is paused',
                    message: 'Activate it again to keep adding payments.',
                    actionLabel: 'Activate goal',
                    onAction: () => _setStatus('active'),
                  )
                else ...[
                  if (reached) ...[
                    _InfoBanner(
                      icon: LucideIcons.partyPopper,
                      color: HomeDesign.green,
                      title: 'Target reached',
                      message:
                          'You have saved the full amount. Mark this goal as achieved?',
                      actionLabel: 'Mark as achieved',
                      onAction: () => _setStatus('archived'),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _sectionTitle('Add a payment',
                      'Record money you have put towards this goal.'),
                  const SizedBox(height: 12),
                  _buildPaymentForm(saved, target, accent),
                ],
                const SizedBox(height: 26),
                _sectionTitle(
                  'Payment history',
                  _histories.isEmpty
                      ? 'Payments you add appear here.'
                      : '${_histories.length} payment${_histories.length == 1 ? '' : 's'}'
                          ' · ${_kes(historyTotal)} total',
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
                  const _EmptyHistory()
                else
                  _HistoryList(
                    rows: _histories,
                    accent: accent,
                    onRemove: _confirmRemove,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentForm(double saved, double target, Color accent) {
    final entered = _enteredAmount;
    final leftAfter = target - saved - entered;
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
            children: [
              ..._quickAmounts.map((v) => _chip('+${_money.format(v)}', () {
                    _setAmount(_enteredAmount + v);
                  })),
              if (target - saved > 0)
                _chip('Remaining ${_money.format((target - saved).round())}',
                    () => _setAmount(target - saved)),
            ],
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.calendar,
                      size: 16, color: HomeDesign.muted),
                  const SizedBox(width: 8),
                  Text(
                    _isToday(_paidAt)
                        ? 'Today'
                        : DateFormat('d MMM yyyy').format(_paidAt),
                    style: HomeDesign.text(size: 13, color: HomeDesign.ink),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('Note (optional)'),
          ),
          if (entered > 0 && target > 0) ...[
            const SizedBox(height: 12),
            _PreviewLine(leftAfter: leftAfter),
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

  void _setAmount(double v) {
    _amountController.text =
        v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    _amountController.selection =
        TextSelection.collapsed(offset: _amountController.text.length);
  }

  Widget _chip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      labelStyle: HomeDesign.text(
        size: 12,
        weight: FontWeight.w600,
        color: HomeDesign.green,
      ),
      backgroundColor: HomeDesign.mint,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
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
        Text(subtitle,
            style: HomeDesign.text(size: 12, color: HomeDesign.muted)),
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

Color _goalColor(String? hex) {
  final v = int.tryParse(hex ?? '', radix: 16);
  return v == null ? HomeDesign.green : Color(v);
}

double _rowAmount(Map<String, dynamic> row) =>
    (row['amount'] as num?)?.toDouble() ??
    double.tryParse('${row['amount']}') ??
    0;

bool _isToday(DateTime d) {
  final n = DateTime.now();
  return d.year == n.year && d.month == n.month && d.day == n.day;
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

class _GoalSummaryCard extends StatelessWidget {
  const _GoalSummaryCard({
    required this.goal,
    required this.saved,
    required this.target,
  });

  final Goals goal;
  final double saved;
  final double target;

  @override
  Widget build(BuildContext context) {
    final ratio = target <= 0 ? 0.0 : saved / target;
    final pct = (ratio * 100).floor();
    final left = target - saved;
    final status = (goal.status ?? 'active').toLowerCase();
    final statusLabel = status == 'pending'
        ? 'Paused'
        : status == 'archived'
            ? 'Achieved'
            : ratio >= 1
                ? 'Target reached'
                : 'Active';

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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  getIconDataFromString(goal.icon ?? 'IconData(U+e000)'),
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'SAVED',
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
                  color: const Color(0xFF9AF0B5).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: HomeDesign.text(
                    size: 11,
                    weight: FontWeight.w700,
                    color: const Color(0xFF9AF0B5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _kes(saved),
            style: HomeDesign.text(
              size: 28,
              weight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            target > 0 ? 'of ${_kes(target)} target' : 'No target set',
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
              color: const Color(0xFF9AF0B5),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: left > 0 ? 'Left to save' : 'Extra saved',
                  value: _kes(left.abs()),
                ),
              ),
              _divider(),
              Expanded(child: _Stat(label: 'Progress', value: '$pct%')),
              _divider(),
              Expanded(
                child: _Stat(
                  label: 'Target date',
                  value: goal.desiredDate == null
                      ? '—'
                      : DateFormat('d MMM yy')
                          .format(goal.desiredDate!.toLocal()),
                ),
              ),
            ],
          ),
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
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

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
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// How much needs to be saved per month/week to hit the target date.
class _PlanStrip extends StatelessWidget {
  const _PlanStrip({
    required this.saved,
    required this.target,
    required this.desiredDate,
  });

  final double saved;
  final double target;
  final DateTime? desiredDate;

  @override
  Widget build(BuildContext context) {
    final left = target - saved;
    final IconData icon;
    final String text;

    if (target <= 0) {
      icon = LucideIcons.target;
      text = 'Set a target amount to see your saving plan.';
    } else if (left <= 0) {
      icon = LucideIcons.checkCircle2;
      text = 'You have reached this goal.';
    } else if (desiredDate == null) {
      icon = LucideIcons.target;
      text = '${_kes(left)} to go. Add a target date to get a saving plan.';
    } else {
      final today = DateTime.now();
      final end = desiredDate!.toLocal();
      final days = DateTime(end.year, end.month, end.day)
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
      if (days <= 0) {
        icon = LucideIcons.alertTriangle;
        text = 'Target date has passed with ${_kes(left)} still to save.';
      } else {
        icon = LucideIcons.calendarClock;
        final months = days / 30.44;
        final perMonth = months >= 1 ? left / months : left;
        final perWeek = left / (days / 7).clamp(1, double.infinity);
        text = days < 31
            ? 'Save ${_kes(perWeek)} a week · $days days left'
            : 'Save ${_kes(perMonth)} a month (${_kes(perWeek)} a week) · $days days left';
      }
    }

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
            child: Icon(icon, size: 16, color: HomeDesign.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: HomeDesign.text(size: 13, color: HomeDesign.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: HomeDesign.text(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(message,
                    style:
                        HomeDesign.text(size: 12, color: HomeDesign.muted)),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.leftAfter});
  final double leftAfter;

  @override
  Widget build(BuildContext context) {
    final done = leftAfter <= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HomeDesign.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(done ? LucideIcons.partyPopper : LucideIcons.trendingUp,
              size: 16, color: HomeDesign.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              done
                  ? 'This payment completes your goal'
                  : 'After this payment, ${_kes(leftAfter)} left to reach your goal',
              style: HomeDesign.text(
                size: 12.5,
                weight: FontWeight.w600,
                color: HomeDesign.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

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
            child: const Icon(LucideIcons.piggyBank,
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
            'Add your first payment to start growing this goal.',
            textAlign: TextAlign.center,
            style: HomeDesign.text(size: 12, color: HomeDesign.muted),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.rows,
    required this.accent,
    required this.onRemove,
  });

  final List<Map<String, dynamic>> rows;
  final Color accent;
  final void Function(Map<String, dynamic> row) onRemove;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final r in rows) {
      final when = DateTime.tryParse('${r['created_at'] ?? ''}')?.toLocal();
      final key =
          when == null ? 'Earlier' : DateFormat('MMMM yyyy').format(when);
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
                      '+${_kes(total)}',
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
                        accent: accent,
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
  const _HistoryTile({
    required this.row,
    required this.accent,
    required this.onRemove,
  });

  final Map<String, dynamic> row;
  final Color accent;
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
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(LucideIcons.piggyBank, size: 16, color: accent),
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
            '+${_kes(amount)}',
            style: HomeDesign.text(
              size: 13,
              weight: FontWeight.w700,
              color: HomeDesign.green,
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
