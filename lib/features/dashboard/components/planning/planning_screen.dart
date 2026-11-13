import 'dart:math' as math;

import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  int _insightIndex = 0;

  static const _insights = [
    (
      title: 'Smart planning',
      accent: 'better future',
      body:
          'A clear plan helps you avoid surprises and reach your goals faster.',
      badge: 'This month 8% less spending',
    ),
    (
      title: 'Stay consistent',
      accent: 'win big',
      body: 'Small weekly check-ins keep bills, budgets, and goals on course.',
      badge: 'On track this week',
    ),
    (
      title: 'Plan first',
      accent: 'spend later',
      body: 'Allocate money before it leaves your wallet — stress drops fast.',
      badge: '3 plans active',
    ),
    (
      title: 'Goals grow',
      accent: 'with focus',
      body: 'Review targets monthly so progress stays visible and motivating.',
      badge: 'Keep going',
    ),
    (
      title: 'Budgets work',
      accent: 'when simple',
      body: 'Fewer categories, clearer limits — easier to stick with them.',
      badge: 'Simplify & save',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(minScaleFactor: 0.95, maxScaleFactor: 1.0),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, topPad + 10, 20, 0),
                child: _buildHeader(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _PlanningHeroCard(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _buildChooseHeader(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    _PlanOptionCard(
                      title: 'Bill Tracker',
                      subtitle: 'Track rent, utilities and other bills',
                      icon: LucideIcons.receipt,
                      accent: const Color(0xFF0F9D58),
                      iconBg: const Color(0xFFE6F6EC),
                      onTap: () => context.pushNamed(Routes.bills),
                    ),
                    _PlanOptionCard(
                      title: 'Planned payments',
                      icon: LucideIcons.calendarClock,
                      accent: const Color(0xFF059669),
                      iconBg: const Color(0xFFD1FAE5),
                      onTap: () =>
                          context.pushNamed(Routes.plannedPayments),
                    ),
                    _PlanOptionCard(
                      title: 'Budget',
                      icon: LucideIcons.pieChart,
                      accent: const Color(0xFF7B61FF),
                      iconBg: const Color(0xFFF0ECFF),
                      onTap: () => context.pushNamed(Routes.budget),
                    ),
                    _PlanOptionCard(
                      title: 'My goals',
                      subtitle: 'Save toward what matters most',
                      icon: LucideIcons.target,
                      accent: const Color(0xFF3B82F6),
                      iconBg: const Color(0xFFE8F1FF),
                      onTap: () => context.pushNamed(Routes.goals),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
                child: _InsightCard(
                  insight: _insights[_insightIndex],
                  index: _insightIndex,
                  count: _insights.length,
                  onPage: (i) => setState(() => _insightIndex = i),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planning',
                style: HomeDesign.text(
                  size: 26,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: HomeDesign.greenDeep,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: HomeDesign.greenDeep.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.crown, size: 13, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                'Money plans',
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
    );
  }

  Widget _buildChooseHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Choose a plan',
          style: HomeDesign.text(
            size: 16,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () => context.pushNamed(Routes.bills),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Open bills',
                  style: HomeDesign.text(
                    size: 12,
                    weight: FontWeight.w600,
                    color: HomeDesign.green,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 14,
                  color: HomeDesign.green,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanningHeroCard extends StatelessWidget {
  const _PlanningHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: HomeDesign.greenDeep.withValues(alpha: 0.24),
            blurRadius: 18,
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
              child: CustomPaint(painter: _HeroWavePainter()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                LucideIcons.lineChart,
                                size: 12,
                                color: Color(0xFF9AF0B5),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Stay on track',
                              style: HomeDesign.text(
                                size: 11,
                                weight: FontWeight.w500,
                                color: const Color(0xFF9AF0B5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Plan today,\n',
                                style: HomeDesign.text(
                                  size: 20,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              TextSpan(
                                text: 'achieve tomorrow',
                                style: HomeDesign.text(
                                  size: 20,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF7CF0A0),
                                  height: 1.2,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Good planning leads to financial freedom.',
                          style: HomeDesign.text(
                            size: 11.5,
                            weight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.82),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 108,
                    height: 108,
                    child: CustomPaint(painter: _ChecklistTargetPainter()),
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

class _PlanOptionCard extends StatelessWidget {
  const _PlanOptionCard({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.accent,
    required this.iconBg,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accent;
  final Color iconBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
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
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 4, color: accent),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: HomeDesign.text(
                                    size: 13.5,
                                    weight: FontWeight.w700,
                                    color: HomeDesign.ink,
                                  ),
                                ),
                                if (subtitle != null &&
                                    subtitle!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle!,
                                    style: HomeDesign.text(
                                      size: 11.5,
                                      weight: FontWeight.w400,
                                      color: HomeDesign.muted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.insight,
    required this.index,
    required this.count,
    required this.onPage,
  });

  final ({String title, String accent, String body, String badge}) insight;
  final int index;
  final int count;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v < -200 && index < count - 1) onPage(index + 1);
        if (v > 200 && index > 0) onPage(index - 1);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF8F1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Insight',
                      style: HomeDesign.text(
                        size: 11,
                        weight: FontWeight.w600,
                        color: HomeDesign.greenDeep,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${insight.title} ',
                          style: HomeDesign.text(
                            size: 15,
                            weight: FontWeight.w700,
                            color: HomeDesign.ink,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: insight.accent,
                          style: HomeDesign.text(
                            size: 15,
                            weight: FontWeight.w700,
                            color: HomeDesign.green,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    insight.body,
                    style: HomeDesign.text(
                      size: 12,
                      weight: FontWeight.w400,
                      color: HomeDesign.muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (var i = 0; i < count; i++) ...[
                        if (i > 0) const SizedBox(width: 5),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: i == index ? 14 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == index
                                ? HomeDesign.green
                                : const Color(0xFFC9D9CE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 108,
              height: 108,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              insight.badge,
                              style: HomeDesign.text(
                                size: 9,
                                weight: FontWeight.w600,
                                color: HomeDesign.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            LucideIcons.arrowDown,
                            size: 10,
                            color: HomeDesign.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 4,
                    bottom: 4,
                    child: SizedBox(
                      width: 88,
                      height: 72,
                      child: CustomPaint(painter: _InsightChartsPainter()),
                    ),
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

class _HeroWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < 5; i++) {
      final path = Path();
      final yBase = size.height * (0.24 + i * 0.15);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 5) {
        final y = yBase + math.sin((x / size.width) * math.pi * 2.1 + i) * 8;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChecklistTargetPainter extends CustomPainter {
  const _ChecklistTargetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.06,
        size.height * 0.14,
        size.width * 0.52,
        size.height * 0.7,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(board, Paint()..color = Colors.white);
    canvas.drawRRect(
      board,
      Paint()
        ..color = const Color(0xFFE2E8E4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final checkPaint = Paint()
      ..color = const Color(0xFF0F9D58)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.3 + i * 0.18);
      final box = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.18, y),
          width: 12,
          height: 12,
        ),
        const Radius.circular(3),
      );
      canvas.drawRRect(box, Paint()..color = const Color(0xFFE6F6EC));
      final path = Path()
        ..moveTo(size.width * 0.14, y)
        ..lineTo(size.width * 0.17, y + 3.5)
        ..lineTo(size.width * 0.23, y - 4);
      canvas.drawPath(path, checkPaint);
      canvas.drawLine(
        Offset(size.width * 0.28, y),
        Offset(size.width * 0.48, y),
        Paint()
          ..color = const Color(0xFFD5DDD8)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    final cx = size.width * 0.74;
    final cy = size.height * 0.58;
    final rings = [
      (size.width * 0.26, const Color(0xFF3CDB73)),
      (size.width * 0.17, const Color(0xFF0B3D2E)),
      (size.width * 0.07, Colors.white),
    ];
    for (final ring in rings) {
      canvas.drawCircle(Offset(cx, cy), ring.$1, Paint()..color = ring.$2);
    }

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(cx - 2, cy - 2),
      Paint()
        ..color = const Color(0xFF7CF0A0)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    final tip = Path()
      ..moveTo(cx + 2, cy + 2)
      ..lineTo(cx - 10, cy - 2)
      ..lineTo(cx - 2, cy - 12)
      ..close();
    canvas.drawPath(tip, Paint()..color = const Color(0xFF7CF0A0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InsightChartsPainter extends CustomPainter {
  const _InsightChartsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Pie
    final pieC = Offset(size.width * 0.32, size.height * 0.42);
    final pieR = size.width * 0.22;
    final slices = [
      (0.0, 0.38, const Color(0xFF0F9D58)),
      (0.38, 0.28, const Color(0xFF7B61FF)),
      (0.66, 0.2, const Color(0xFFF59E0B)),
      (0.86, 0.14, const Color(0xFF3B82F6)),
    ];
    for (final s in slices) {
      canvas.drawArc(
        Rect.fromCircle(center: pieC, radius: pieR),
        -math.pi / 2 + s.$1 * math.pi * 2,
        s.$2 * math.pi * 2,
        true,
        Paint()..color = s.$3,
      );
    }
    canvas.drawCircle(pieC, pieR * 0.42, Paint()..color = const Color(0xFFEDF8F1));

    // Bars
    final barPaint = Paint()..style = PaintingStyle.fill;
    final heights = [0.35, 0.55, 0.45, 0.8];
    final barW = size.width * 0.08;
    for (var i = 0; i < heights.length; i++) {
      barPaint.color = Color.lerp(
            const Color(0xFFB8F5C8),
            HomeDesign.green,
            i / (heights.length - 1),
          ) ??
          HomeDesign.green;
      final h = size.height * heights[i] * 0.55;
      final x = size.width * 0.58 + i * (barW * 1.35);
      final y = size.height * 0.88 - h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barW, h),
          const Radius.circular(3),
        ),
        barPaint,
      );
    }

    // Up arrow badge
    final ax = size.width * 0.88;
    final ay = size.height * 0.28;
    canvas.drawCircle(
      Offset(ax, ay),
      9,
      Paint()..color = HomeDesign.green,
    );
    final arrow = Path()
      ..moveTo(ax, ay + 4)
      ..lineTo(ax, ay - 4)
      ..moveTo(ax - 3.5, ay - 1)
      ..lineTo(ax, ay - 4)
      ..lineTo(ax + 3.5, ay - 1);
    canvas.drawPath(
      arrow,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
