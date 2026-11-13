import 'dart:math' as math;

import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/budget_bottomsheet.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/budget_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBudgetBloc>().add(FetchAllUserBudgetsEvent());
  }

  void _openCreateSheet() {
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
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.95,
          child: NewBudgetBottomSheet(),
        );
      },
    );
  }

  Color _colorFromRatio(double number) {
    if (number < 0.75) return HomeDesign.green;
    if (number < 1) return Colors.orange;
    return HomeDesign.expense;
  }

  String _adviceFromRatio(double number) {
    if (number < 0.75) return 'Awesome! You are on track with your budget';
    if (number < 1) {
      return 'You are almost there! Remember to stay within your budget';
    }
    return 'Caution! You have exceeded your budget';
  }

  IconData _iconFromRatio(double number) {
    if (number < 0.75) return Icons.check_circle;
    if (number < 1) return Icons.warning;
    return Icons.cancel;
  }

  String _formatKes(double v) => v
      .round()
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  double _ratioFor(dynamic budget) {
    if (budget.budgetLimitAmount == null) return 1;
    final limit = double.tryParse(budget.budgetLimitAmount!) ?? 0;
    final amount = double.tryParse(budget.amount) ?? 0;
    if (limit <= 0) return 1;
    return amount / limit;
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
              child: BlocBuilder<UserBudgetBloc, UserBudgetState>(
                builder: (context, state) {
                  if (state.status == ServiceStatus.loading) {
                    return const Center(child: LogoLoader());
                  }
                  if (state.status == ServiceStatus.loadingFailure) {
                    return _buildErrorState();
                  }

                  final budgets = state.userBudgets?.budgets ?? const [];
                  return RefreshIndicator(
                    color: HomeDesign.green,
                    onRefresh: () async {
                      context
                          .read<UserBudgetBloc>()
                          .add(FetchAllUserBudgetsEvent());
                    },
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                      children: [
                        const _BudgetHeroCard(),
                        const SizedBox(height: 16),
                        if (budgets.isEmpty) ...[
                          _EmptyBudgetCard(onCreate: _openCreateSheet),
                          const SizedBox(height: 12),
                          _FeatureCard(
                            icon: LucideIcons.slidersHorizontal,
                            title: 'Control spending by category',
                            onTap: _openCreateSheet,
                          ),
                          _FeatureCard(
                            icon: LucideIcons.lineChart,
                            title: 'See when you’re close to your limit',
                            onTap: () => context.pushNamed(Routes.analytics),
                          ),
                        ] else ...[
                          Text(
                            'Your spending limits',
                            style: HomeDesign.text(
                              size: 15,
                              weight: FontWeight.w700,
                              color: HomeDesign.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${budgets.length} budget${budgets.length == 1 ? '' : 's'}',
                            style: HomeDesign.text(
                              size: 12,
                              color: HomeDesign.muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...budgets.map((budget) {
                            final ratio = _ratioFor(budget);
                            final color = _colorFromRatio(ratio);
                            final remaining = budget.budgetLimitAmount != null
                                ? (double.tryParse(budget.budgetLimitAmount!) ??
                                        0) -
                                    (double.tryParse(budget.amount) ?? 0)
                                : 0.0;

                            return BudgetCard(
                              budget: budget,
                              onPressed: () {
                                context.pushNamed(
                                  Routes.budgetDetail,
                                  extra: budget,
                                );
                              },
                              value: ratio,
                              indicatorColor: color,
                              iconBgColor: color,
                              icon: LucideIcons.piggyBank,
                              text: budget.subcategoryName ??
                                  budget.category ??
                                  '',
                              description: remaining < 0
                                  ? 'Over by KES ${_formatKes(-remaining)}'
                                  : 'Remaining: KES ${_formatKes(remaining)}',
                              widget: Row(
                                children: [
                                  Icon(_iconFromRatio(ratio),
                                      color: color, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _adviceFromRatio(ratio),
                                      style: TextStyle(
                                          fontSize: 11, color: color),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        const SizedBox(height: 8),
                        const _BudgetTipCard(),
                      ],
                    ),
                  );
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
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 1,
          shadowColor: Colors.black26,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.pop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                LucideIcons.arrowLeft,
                size: 18,
                color: HomeDesign.ink,
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
                'Budget',
                style: HomeDesign.text(
                  size: 22,
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
            onTap: _openCreateSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: HomeDesign.green.withValues(alpha: 0.45)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.list,
                    size: 14,
                    color: HomeDesign.green,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Limits',
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w600,
                      color: HomeDesign.green,
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
              'Couldn’t load budgets',
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
                    .read<UserBudgetBloc>()
                    .add(FetchAllUserBudgetsEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetHeroCard extends StatelessWidget {
  const _BudgetHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: HomeDesign.greenDeep.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay in control of your spending',
                          style: HomeDesign.text(
                            size: 18,
                            weight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.piggyBank,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Better planning. Better future.',
                                style: HomeDesign.text(
                                  size: 10,
                                  weight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 108,
                    height: 108,
                    child: CustomPaint(painter: _BudgetHeroArtPainter()),
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

class _EmptyBudgetCard extends StatelessWidget {
  const _EmptyBudgetCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F6EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.wallet,
              color: HomeDesign.greenDeep,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No budgets yet',
            style: HomeDesign.text(
              size: 16,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first budget to take control of your spending and save smarter.',
            textAlign: TextAlign.center,
            style: HomeDesign.text(
              size: 12.5,
              color: HomeDesign.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(LucideIcons.plus, size: 18),
              label: Text(
                'Create a budget',
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 10, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F6EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: HomeDesign.greenDeep, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: HomeDesign.text(
                      size: 13.5,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F6EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.chevronRight,
                    size: 15,
                    color: HomeDesign.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetTipCard extends StatelessWidget {
  const _BudgetTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8F1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6F0DE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tip',
                    style: HomeDesign.text(
                      size: 11,
                      weight: FontWeight.w600,
                      color: HomeDesign.greenDeep,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Budget today, stress less tomorrow',
                  style: HomeDesign.text(
                    size: 14,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A good budget gives you freedom to enjoy what matters most.',
                  style: HomeDesign.text(
                    size: 12,
                    weight: FontWeight.w400,
                    color: HomeDesign.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 88,
            height: 88,
            child: CustomPaint(painter: _TipArtPainter()),
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
      final yBase = size.height * (0.28 + i * 0.16);
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

class _BudgetHeroArtPainter extends CustomPainter {
  const _BudgetHeroArtPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Clipboard
    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.18,
        size.width * 0.48,
        size.height * 0.62,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(board, Paint()..color = Colors.white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.12,
          size.width * 0.24,
          size.height * 0.1,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFD6F0DE),
    );

    // Mini pie on clipboard
    final pieC = Offset(size.width * 0.32, size.height * 0.48);
    canvas.drawArc(
      Rect.fromCircle(center: pieC, radius: 14),
      -math.pi / 2,
      math.pi * 1.2,
      true,
      Paint()..color = const Color(0xFF0F9D58),
    );
    canvas.drawArc(
      Rect.fromCircle(center: pieC, radius: 14),
      math.pi * 0.7,
      math.pi * 0.8,
      true,
      Paint()..color = const Color(0xFF7B61FF),
    );

    // Coins
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.68, size.height * (0.55 - i * 0.08)),
        10,
        Paint()..color = Color.lerp(const Color(0xFF0F9D58), const Color(0xFF7CF0A0), i / 2)!,
      );
      canvas.drawCircle(
        Offset(size.width * 0.68, size.height * (0.55 - i * 0.08)),
        10,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Shield
    final shield = Path()
      ..moveTo(size.width * 0.72, size.height * 0.18)
      ..lineTo(size.width * 0.92, size.height * 0.26)
      ..lineTo(size.width * 0.92, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.56,
        size.width * 0.72,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.56,
        size.width * 0.62,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.62, size.height * 0.26)
      ..close();
    canvas.drawPath(shield, Paint()..color = const Color(0xFF0F9D58));
    final check = Path()
      ..moveTo(size.width * 0.7, size.height * 0.4)
      ..lineTo(size.width * 0.76, size.height * 0.46)
      ..lineTo(size.width * 0.86, size.height * 0.32);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TipArtPainter extends CustomPainter {
  const _TipArtPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Target
    final cx = size.width * 0.55;
    final cy = size.height * 0.42;
    canvas.drawCircle(Offset(cx, cy), 22, Paint()..color = const Color(0xFF3CDB73));
    canvas.drawCircle(Offset(cx, cy), 14, Paint()..color = const Color(0xFF0B3D2E));
    canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = Colors.white);
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.18),
      Offset(cx - 2, cy - 2),
      Paint()
        ..color = const Color(0xFF7CF0A0)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Coins
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.72),
      9,
      Paint()..color = const Color(0xFF0F9D58),
    );
    canvas.drawCircle(
      Offset(size.width * 0.34, size.height * 0.78),
      7,
      Paint()..color = const Color(0xFF7CF0A0),
    );

    // Plant
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.72, size.height * 0.7, 12, 14),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFC47A2C),
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.64),
      8,
      Paint()..color = const Color(0xFF0F9D58),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
