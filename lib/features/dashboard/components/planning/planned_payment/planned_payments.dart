import 'dart:math' as math;

import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/local/planned_payment_progress.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_payement_bottomsheet.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PlannedPayments extends StatefulWidget {
  const PlannedPayments({super.key});

  @override
  State<PlannedPayments> createState() => _PlannedPaymentScreenState();
}

enum _SortMode { dueDate, amount, name }

class _PlannedPaymentScreenState extends State<PlannedPayments> {
  _SortMode _sort = _SortMode.dueDate;

  @override
  void initState() {
    super.initState();
    context.read<PlannedPaymentBloc>().add(const PlannedPaymentEvent.fetched());
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 1,
        child: NewPlannedPaymentBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HomeDesign.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: _openCreateSheet,
        child: const Icon(LucideIcons.plus, size: 26),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(minScaleFactor: 0.95, maxScaleFactor: 1.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, topPad + 8, 16, 0),
              child: _buildHeader(context),
            ),
            Expanded(
              child: BlocBuilder<PlannedPaymentBloc, PlannedPaymentState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PlannedPaymentStatus.loading:
                      return const Center(child: LogoLoader());
                    case PlannedPaymentStatus.failure:
                      return _buildErrorState();
                    case PlannedPaymentStatus.success:
                      return _buildBody(state.plannedPayments);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: const Color(0xFFE6F6EC),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.pop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                LucideIcons.arrowLeft,
                size: 18,
                color: HomeDesign.greenDeep,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planned Payments',
                style: HomeDesign.text(
                  size: 20,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.pushNamed(Routes.bills),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.wallet,
                    size: 14,
                    color: HomeDesign.greenDeep,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Bills',
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w600,
                      color: HomeDesign.greenDeep,
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 40, color: HomeDesign.muted),
            const SizedBox(height: 12),
            Text(
              'Couldn’t load planned payments',
              style: HomeDesign.text(
                size: 16,
                weight: FontWeight.w600,
                color: HomeDesign.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: HomeDesign.text(size: 13, color: HomeDesign.muted),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context
                    .read<PlannedPaymentBloc>()
                    .add(const PlannedPaymentEvent.fetched());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<PlannedPayment> payments) {
    if (payments.isEmpty) return _buildEmptyState();

    final sorted = List<PlannedPayment>.from(payments);
    switch (_sort) {
      case _SortMode.dueDate:
        sorted.sort((a, b) =>
            _parseDate(a.paymentDate).compareTo(_parseDate(b.paymentDate)));
      case _SortMode.amount:
        sorted.sort(
            (a, b) => _parseAmount(b.amount).compareTo(_parseAmount(a.amount)));
      case _SortMode.name:
        sorted.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    final totalDue = sorted.fold<double>(
      0,
      (sum, p) {
        final status = normalizePlannedStatus(p.status);
        if (status == 'paid') return sum;
        return sum + _parseAmount(p.amount);
      },
    );

    return RefreshIndicator(
      color: HomeDesign.green,
      onRefresh: () async {
        context
            .read<PlannedPaymentBloc>()
            .add(const PlannedPaymentEvent.fetched());
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          _TotalDueCard(
            total: totalDue,
            count: sorted.length,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Upcoming & scheduled',
                style: HomeDesign.text(
                  size: 15,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6EC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${sorted.length}',
                  style: HomeDesign.text(
                    size: 11,
                    weight: FontWeight.w700,
                    color: HomeDesign.greenDeep,
                  ),
                ),
              ),
              const Spacer(),
              _SortChip(
                label: switch (_sort) {
                  _SortMode.dueDate => 'Due date',
                  _SortMode.amount => 'Amount',
                  _SortMode.name => 'Name',
                },
                onTap: _showSortMenu,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sorted.map((p) => _PlannedPaymentListCard(
                payment: p,
                onTap: () {
                  context.pushNamed(
                    Routes.plannedPaymentDetail,
                    extra: p,
                    queryParameters: {'category': ''},
                  );
                },
              )),
          const SizedBox(height: 8),
          const _StayAheadBanner(),
        ],
      ),
    );
  }

  Future<void> _showSortMenu() async {
    final chosen = await showModalBottomSheet<_SortMode>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in _SortMode.values)
                ListTile(
                  title: Text(
                    switch (mode) {
                      _SortMode.dueDate => 'Due date',
                      _SortMode.amount => 'Amount',
                      _SortMode.name => 'Name',
                    },
                    style: HomeDesign.text(
                      size: 14,
                      weight: _sort == mode ? FontWeight.w700 : FontWeight.w500,
                      color: HomeDesign.ink,
                    ),
                  ),
                  trailing: _sort == mode
                      ? const Icon(LucideIcons.check, color: HomeDesign.green)
                      : null,
                  onTap: () => Navigator.pop(context, mode),
                ),
            ],
          ),
        );
      },
    );
    if (chosen != null && mounted) setState(() => _sort = chosen);
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      children: [
        const _TotalDueCard(total: 0, count: 0),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6EC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.receipt,
                  color: HomeDesign.green,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No planned payments yet',
                textAlign: TextAlign.center,
                style: HomeDesign.text(
                  size: 16,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add bills and recurring payments so Fedha can remind you before they’re due.',
                textAlign: TextAlign.center,
                style: HomeDesign.text(
                  size: 13,
                  color: HomeDesign.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openCreateSheet,
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text('Add planned payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeDesign.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _StayAheadBanner(),
      ],
    );
  }
}

double _parseAmount(String raw) {
  return double.tryParse(raw.replaceAll(',', '').trim()) ?? 0;
}

DateTime _parseDate(String raw) {
  final cleaned = raw.trim();
  if (cleaned.isEmpty) return DateTime(2100);
  for (final fmt in [
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'dd-MM-yyyy',
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd\'T\'HH:mm:ss',
  ]) {
    try {
      return DateFormat(fmt).parse(cleaned);
    } catch (_) {}
  }
  return DateTime.tryParse(cleaned) ?? DateTime(2100);
}

String _formatDueDate(DateTime date) {
  if (date.year >= 2100) return 'No date';
  return DateFormat('d MMM yyyy').format(date);
}

String _dueInLabel(DateTime date) {
  if (date.year >= 2100) return 'Date not set';
  final today = DateTime.now();
  final d0 = DateTime(today.year, today.month, today.day);
  final d1 = DateTime(date.year, date.month, date.day);
  final days = d1.difference(d0).inDays;
  if (days < 0) return 'Overdue by ${-days} day${-days == 1 ? '' : 's'}';
  if (days == 0) return 'Due today';
  if (days == 1) return 'Due in 1 day';
  return 'Due in $days days';
}

IconData _iconForPayment(PlannedPayment p) {
  final name = '${p.name} ${p.category.name}'.toLowerCase();
  if (name.contains('rent') || name.contains('house') || name.contains('home')) {
    return LucideIcons.home;
  }
  if (name.contains('electric') ||
      name.contains('power') ||
      name.contains('kplc') ||
      name.contains('utility')) {
    return LucideIcons.zap;
  }
  if (name.contains('water')) return LucideIcons.droplets;
  if (name.contains('internet') || name.contains('wifi')) {
    return LucideIcons.wifi;
  }
  return getMaterialIcon(p.category.name);
}

class _TotalDueCard extends StatelessWidget {
  const _TotalDueCard({required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HomeDesign.greenDeep.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0A3326),
                      Color(0xFF0B3D2E),
                      Color(0xFF0F5C3D),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(painter: _WavePainter()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total due',
                          style: HomeDesign.text(
                            size: 12,
                            weight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatHomeMoney(total),
                          style: HomeDesign.text(
                            size: 28,
                            weight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.calendar,
                              size: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$count payment${count == 1 ? '' : 's'} scheduled',
                              style: HomeDesign.text(
                                size: 12,
                                weight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 88,
                    height: 88,
                    child: CustomPaint(painter: _CalendarBellPainter()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE6F6EC),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: HomeDesign.text(
                  size: 11,
                  weight: FontWeight.w600,
                  color: HomeDesign.greenDeep,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                LucideIcons.chevronDown,
                size: 14,
                color: HomeDesign.greenDeep,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlannedPaymentListCard extends StatelessWidget {
  const _PlannedPaymentListCard({
    required this.payment,
    required this.onTap,
  });

  final PlannedPayment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final due = _parseDate(payment.paymentDate);
    final freq = payment.frequency.trim().isEmpty
        ? 'Scheduled'
        : payment.frequency[0].toUpperCase() +
            payment.frequency.substring(1).toLowerCase();
    final status = normalizePlannedStatus(payment.status);
    final dueLabel = status == 'paid' ? 'Paid' : _dueInLabel(due);
    final dueColor = status == 'paid'
        ? HomeDesign.green
        : const Color(0xFFC47A2C);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F6EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForPayment(payment),
                    size: 20,
                    color: HomeDesign.greenDeep,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeDesign.text(
                          size: 14,
                          weight: FontWeight.w700,
                          color: HomeDesign.ink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F6EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: HomeDesign.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              freq,
                              style: HomeDesign.text(
                                size: 10,
                                weight: FontWeight.w600,
                                color: HomeDesign.greenDeep,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            size: 12,
                            color: HomeDesign.muted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatDueDate(due),
                            style: HomeDesign.text(
                              size: 11,
                              weight: FontWeight.w500,
                              color: HomeDesign.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dueLabel,
                        style: HomeDesign.text(
                          size: 11,
                          weight: FontWeight.w600,
                          color: dueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  size: const Size(1, 64),
                  painter: _DashedLinePainter(),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatHomeMoney(_parseAmount(payment.amount)),
                      style: HomeDesign.text(
                        size: 13,
                        weight: FontWeight.w700,
                        color: HomeDesign.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: HomeDesign.greenDeep,
                    ),
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

class _StayAheadBanner extends StatelessWidget {
  const _StayAheadBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: HomeDesign.greenDeep,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.lightbulb,
              size: 18,
              color: Color(0xFFFFD54F),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay ahead, stress less',
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Pay on time and avoid late fees.',
                  style: HomeDesign.text(
                    size: 12,
                    weight: FontWeight.w400,
                    color: HomeDesign.muted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 72,
            height: 64,
            child: CustomPaint(painter: _ShieldPlantPainter()),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 4; i++) {
      final path = Path();
      final yBase = size.height * (0.3 + i * 0.16);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 5) {
        final y = yBase + math.sin((x / size.width) * math.pi * 2 + i) * 7;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CalendarBellPainter extends CustomPainter {
  const _CalendarBellPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cal = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.12,
        size.height * 0.18,
        size.width * 0.62,
        size.height * 0.62,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(cal, Paint()..color = Colors.white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.12,
          size.height * 0.18,
          size.width * 0.62,
          size.height * 0.18,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE8F6EE),
    );
    for (var r = 0; r < 2; r++) {
      for (var c = 0; c < 3; c++) {
        canvas.drawCircle(
          Offset(
            size.width * (0.26 + c * 0.16),
            size.height * (0.5 + r * 0.16),
          ),
          3.2,
          Paint()..color = const Color(0xFFD1E7D8),
        );
      }
    }
    final bellC = Offset(size.width * 0.78, size.height * 0.72);
    canvas.drawCircle(bellC, 14, Paint()..color = const Color(0xFF0F9D58));
    canvas.drawCircle(bellC, 14, Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
    final bell = Path()
      ..moveTo(bellC.dx, bellC.dy - 6)
      ..quadraticBezierTo(bellC.dx + 6, bellC.dy - 4, bellC.dx + 5, bellC.dy + 2)
      ..lineTo(bellC.dx - 5, bellC.dy + 2)
      ..quadraticBezierTo(bellC.dx - 6, bellC.dy - 4, bellC.dx, bellC.dy - 6);
    canvas.drawPath(bell, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(bellC.dx, bellC.dy + 5),
      2,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1.2;
    const dash = 4.0;
    const gap = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, math.min(y + dash, size.height)), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShieldPlantPainter extends CustomPainter {
  const _ShieldPlantPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Mini calendar
    final cal = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.05, size.height * 0.2, size.width * 0.42, size.height * 0.5),
      const Radius.circular(6),
    );
    canvas.drawRRect(cal, Paint()..color = Colors.white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.2, size.width * 0.42, size.height * 0.14),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFD6F0DE),
    );

    // Shield
    final shield = Path()
      ..moveTo(size.width * 0.58, size.height * 0.22)
      ..lineTo(size.width * 0.88, size.height * 0.3)
      ..lineTo(size.width * 0.88, size.height * 0.52)
      ..quadraticBezierTo(
        size.width * 0.73,
        size.height * 0.72,
        size.width * 0.58,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.43,
        size.height * 0.72,
        size.width * 0.43,
        size.height * 0.52,
      )
      ..lineTo(size.width * 0.43, size.height * 0.3)
      ..close();
    canvas.drawPath(shield, Paint()..color = HomeDesign.green);
    final check = Path()
      ..moveTo(size.width * 0.55, size.height * 0.5)
      ..lineTo(size.width * 0.63, size.height * 0.58)
      ..lineTo(size.width * 0.78, size.height * 0.4);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Plant
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.72, size.height * 0.72, size.width * 0.16, size.height * 0.16),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFC47A2C),
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.68),
      7,
      Paint()..color = const Color(0xFF0F9D58),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
