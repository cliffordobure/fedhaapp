import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/local/planned_payment_progress.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_payement_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PlannedPaymentDetailScreen extends StatefulWidget {
  const PlannedPaymentDetailScreen({
    super.key,
    required this.category,
    required this.plannedPayment,
  });

  final String category;
  final PlannedPayment plannedPayment;

  @override
  State<PlannedPaymentDetailScreen> createState() =>
      _PlannedPaymentDetailScreenState();
}

class _PlannedPaymentDetailScreenState extends State<PlannedPaymentDetailScreen> {
  List<TransactionAllocationLink> _localLinks = const [];
  bool _markingPaid = false;

  @override
  void initState() {
    super.initState();
    context.read<PlannedPaymentBloc>().add(
          PlannedPaymentEvent.detailFetched(
            id: widget.plannedPayment.id ?? 0,
          ),
        );
    _loadLocalLinks();
  }

  Future<void> _loadLocalLinks() async {
    final id = widget.plannedPayment.id;
    if (id == null) return;
    final cache = service<LocalDataCache>();
    final links = await cache.loadLinksForEntity(
      entityType: AllocationEntityType.plannedPayment,
      entityId: id,
    );
    await refreshPlannedPaymentLinkStatus(
      cache: cache,
      plannedPaymentId: id,
    );
    if (!mounted) return;
    setState(() {
      _localLinks = links;
      _markingPaid = false;
    });
  }

  PlannedPayment _paymentFrom(PlannedPaymentState state) {
    return state.plannedPayment ?? widget.plannedPayment;
  }

  double get _linkedTotal =>
      _localLinks.fold<double>(0, (s, l) => s + l.linkedAmount.abs());

  PlannedPaymentProgress _resolveProgress(PlannedPayment payment) {
    return progressForPlannedPayment(
      payment: payment,
      linkedTotal: _linkedTotal,
    );
  }

  int _daysUntil(String dateStr) {
    try {
      final paymentDate = DateFormat('yyyy-MM-dd').parse(dateStr);
      final today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final due =
          DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
      return due.difference(today).inDays;
    } catch (_) {
      return 0;
    }
  }

  String _dueLabel(int days) {
    if (days > 1) return 'Due in $days days';
    if (days == 1) return 'Due tomorrow';
    if (days == 0) return 'Due today';
    if (days == -1) return '1 day overdue';
    return '${-days} days overdue';
  }

  Future<void> _markPaid(PlannedPayment payment) async {
    if (_markingPaid) return;
    if (!canMarkPlannedPaymentPaid(
      payment: payment,
      linkedTotal: _linkedTotal,
    )) {
      return;
    }

    setState(() => _markingPaid = true);
    HapticFeedback.mediumImpact();
    context.read<PlannedPaymentBloc>().add(
          PlannedPaymentEvent.paymentHistoryAdded(
            id: payment.id ?? 0,
            request: PaymentHistory(
              plannedPaymentsId: payment.id ?? 0,
              amount: payment.amount,
              paidAt: DateTime.now().toIso8601String(),
              userId: payment.userId,
            ),
          ),
        );
  }

  void _openMenu(PlannedPayment payment) {
    final box = context.findRenderObject() as RenderBox?;
    final position = RelativeRect.fromLTRB(
      (box?.size.width ?? 200) - 8,
      96,
      16,
      0,
    );
    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(LucideIcons.pencil, size: 16),
              SizedBox(width: 10),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(LucideIcons.trash2, size: 16, color: Colors.red),
              SizedBox(width: 10),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (!mounted || value == null) return;
      if (value == 'edit') {
        showModalBottomSheet(
          showDragHandle: false,
          useRootNavigator: true,
          isScrollControlled: true,
          useSafeArea: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => FractionallySizedBox(
            heightFactor: 1,
            child: NewPlannedPaymentBottomSheet(
              update: true,
              payment: payment,
            ),
          ),
        );
      } else if (value == 'delete') {
        context.read<PlannedPaymentBloc>().add(
              PlannedPaymentEvent.deleted(id: payment.id ?? 0),
            );
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(minScaleFactor: 0.95, maxScaleFactor: 1.0),
        ),
        child: BlocConsumer<PlannedPaymentBloc, PlannedPaymentState>(
          listener: (context, state) {
            if (state.status == PlannedPaymentStatus.success) {
              _loadLocalLinks();
            }
          },
          builder: (context, state) {
            final payment = _paymentFrom(state);
            final days = _daysUntil(payment.paymentDate);
            final progress = _resolveProgress(payment);
            final histories = payment.paymentHistory
                    ?.whereType<PaymentHistory>()
                    .toList() ??
                const <PaymentHistory>[];

            if (state.status == PlannedPaymentStatus.loading &&
                state.plannedPayment == null) {
              return const Center(child: LogoLoader());
            }

            return Column(
              children: [
                SizedBox(height: topPad > 0 ? topPad : 8),
                _buildAppBar(payment),
                Expanded(
                  child: RefreshIndicator(
                    color: HomeDesign.green,
                    onRefresh: () async {
                      context.read<PlannedPaymentBloc>().add(
                            PlannedPaymentEvent.detailFetched(
                              id: payment.id ?? 0,
                            ),
                          );
                      await _loadLocalLinks();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      children: [
                        _HeroSummary(
                          payment: payment,
                          progress: progress,
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle(
                          'Payment schedule',
                          LucideIcons.calendar,
                        ),
                        const SizedBox(height: 10),
                        _ScheduleCard(
                          date: payment.paymentDate,
                          dueLabel: _dueLabel(days),
                          overdue: days < 0,
                        ),
                        const SizedBox(height: 14),
                        if (!progress.isPaid)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _markingPaid
                                  ? null
                                  : () => _markPaid(payment),
                              icon: _markingPaid
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(LucideIcons.checkCircle2,
                                      size: 18),
                              label: Text(
                                _markingPaid ? 'Marking…' : 'Mark as paid',
                                style: HomeDesign.text(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HomeDesign.greenDeep,
                                disabledBackgroundColor:
                                    HomeDesign.greenDeep.withValues(alpha: 0.7),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(LucideIcons.checkCircle2,
                                  size: 18),
                              label: Text(
                                'Paid for this period',
                                style: HomeDesign.text(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: HomeDesign.greenDeep,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: HomeDesign.greenDeep,
                                disabledForegroundColor: HomeDesign.greenDeep,
                                side: const BorderSide(
                                    color: HomeDesign.greenDeep),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 22),
                        _sectionTitle(
                          'Payment history',
                          LucideIcons.history,
                        ),
                        const SizedBox(height: 10),
                        _buildHistory(histories),
                        if (_localLinks.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          _sectionTitle(
                            'Linked transactions',
                            LucideIcons.link,
                          ),
                          const SizedBox(height: 10),
                          _buildLocalLinks(),
                        ],
                        const SizedBox(height: 16),
                        const _StayOnTrackCard(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(PlannedPayment payment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 12, 0),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(
                  LucideIcons.arrowLeft,
                  size: 18,
                  color: HomeDesign.ink,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Planned Payment',
              textAlign: TextAlign.center,
              style: HomeDesign.text(
                size: 17,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _openMenu(payment),
            icon: const Icon(
              LucideIcons.moreVertical,
              color: HomeDesign.ink,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: HomeDesign.green),
        const SizedBox(width: 8),
        Text(
          title,
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(List<PaymentHistory> histories) {
    if (histories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
              height: 88,
              child: CustomPaint(painter: _ClipboardEmptyPainter()),
            ),
            const SizedBox(height: 12),
            Text(
              'No payments recorded yet',
              style: HomeDesign.text(
                size: 15,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Mark as paid or link a transaction to start history.',
              textAlign: TextAlign.center,
              style: HomeDesign.text(
                size: 12.5,
                color: HomeDesign.muted,
                height: 1.35,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < histories.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFF0F1F3)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F6EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.checkCircle2,
                      color: HomeDesign.green,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paid',
                          style: HomeDesign.text(
                            size: 14,
                            weight: FontWeight.w700,
                            color: HomeDesign.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatPaidAt(histories[i]),
                          style: HomeDesign.text(
                            size: 12,
                            color: HomeDesign.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _detailMoney(parsePlannedAmount(histories[i].amount)),
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
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

  String _formatPaidAt(PaymentHistory h) {
    final raw = h.paidAt.isNotEmpty ? h.paidAt : (h.createdAt ?? '');
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('dd MMM yyyy, HH:mm').format(dt);
  }

  Widget _buildLocalLinks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _localLinks.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFF0F1F3)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Icon(LucideIcons.receipt,
                      size: 18, color: HomeDesign.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _localLinks[i].transactionCode,
                      style: HomeDesign.text(
                        size: 13,
                        weight: FontWeight.w600,
                        color: HomeDesign.ink,
                      ),
                    ),
                  ),
                  Text(
                    _detailMoney(_localLinks[i].linkedAmount),
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
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
}

String _detailMoney(double amount) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: 'KES ',
    decimalDigits: 2,
  ).format(amount);
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({
    required this.payment,
    required this.progress,
  });

  final PlannedPayment payment;
  final PlannedPaymentProgress progress;

  @override
  Widget build(BuildContext context) {
    final statusColor = progress.isPaid
        ? const Color(0xFF9AF0B5)
        : const Color(0xFFFFD54F);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
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
                color: HomeDesign.greenDeep.withValues(alpha: 0.2),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF9AF0B5).withValues(alpha: 0.45),
                      ),
                    ),
                    child: Icon(
                      getMaterialIcon(payment.category.name),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.name,
                          style: HomeDesign.text(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payment.category.name,
                          style: HomeDesign.text(
                            size: 12,
                            weight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          progress.label,
                          style: HomeDesign.text(
                            size: 11,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                _detailMoney(progress.targetAmount),
                style: HomeDesign.text(
                  size: 30,
                  weight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Pending amount',
                      style: HomeDesign.text(
                        size: 12,
                        color: HomeDesign.muted,
                      ),
                    ),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: _detailMoney(progress.paidAmount),
                            style: HomeDesign.text(
                              size: 12,
                              weight: FontWeight.w700,
                              color: HomeDesign.greenDeep,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' / ${_detailMoney(progress.targetAmount).replaceFirst('KES ', '')}',
                            style: HomeDesign.text(
                              size: 12,
                              weight: FontWeight.w500,
                              color: HomeDesign.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final ratio = progress.ratio.clamp(0.0, 1.0);
                    final thumbLeft =
                        (ratio * constraints.maxWidth - 6).clamp(0.0, constraints.maxWidth - 12);
                    return SizedBox(
                      height: 12,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: ratio <= 0 ? 0.02 : ratio,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFE8ECF0),
                              valueColor: const AlwaysStoppedAnimation(
                                HomeDesign.greenDeep,
                              ),
                            ),
                          ),
                          Positioned(
                            left: thumbLeft,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: HomeDesign.greenDeep,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Remaining amount',
                      style: HomeDesign.text(
                        size: 12,
                        color: HomeDesign.muted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _detailMoney(progress.remaining),
                      style: HomeDesign.text(
                        size: 13,
                        weight: FontWeight.w700,
                        color: HomeDesign.greenDeep,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.date,
    required this.dueLabel,
    required this.overdue,
  });

  final String date;
  final String dueLabel;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final accent = overdue ? HomeDesign.expense : HomeDesign.green;
    final bg = overdue ? const Color(0xFFFFECEC) : const Color(0xFFE6F6EC);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.calendar, color: accent, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: HomeDesign.text(
                        size: 14,
                        weight: FontWeight.w700,
                        color: HomeDesign.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dueLabel,
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: HomeDesign.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StayOnTrackCard extends StatelessWidget {
  const _StayOnTrackCard();

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
              LucideIcons.lightbulb,
              size: 18,
              color: HomeDesign.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay on track',
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pay on time and avoid late fees.',
                  style: HomeDesign.text(
                    size: 12,
                    color: HomeDesign.muted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: HomeDesign.muted,
          ),
        ],
      ),
    );
  }
}

class _ClipboardEmptyPainter extends CustomPainter {
  const _ClipboardEmptyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.55),
        width: 26,
        height: 14,
      ),
      Paint()..color = const Color(0xFFB8F5C8),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.42),
        width: 22,
        height: 12,
      ),
      Paint()..color = const Color(0xFFB8F5C8),
    );

    // Clipboard
    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.28,
        size.height * 0.22,
        size.width * 0.44,
        size.height * 0.58,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(board, Paint()..color = Colors.white);
    canvas.drawRRect(
      board,
      Paint()
        ..color = const Color(0xFFE2E8E4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.38,
          size.height * 0.16,
          size.width * 0.24,
          size.height * 0.12,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFD6F0DE),
    );

    // Clock badge
    final c = Offset(size.width * 0.62, size.height * 0.62);
    canvas.drawCircle(c, 14, Paint()..color = HomeDesign.greenDeep);
    canvas.drawCircle(
      c,
      9,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawLine(
      c,
      Offset(c.dx, c.dy - 5),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      c,
      Offset(c.dx + 4, c.dy + 2),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
