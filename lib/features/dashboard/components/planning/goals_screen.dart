import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/goals_bottomsheet.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/goals_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

IconData getIconDataFromString(String iconString) {
  // Must return compile-time constant IconData only — dynamic
  // `IconData(codePoint, ...)` breaks release APK tree-shaking.
  try {
    final parts = iconString.split('+');
    if (parts.length < 2) return Icons.flag_outlined;
    final hexCode = parts[1].split(')')[0];
    final iconCode = int.parse(hexCode, radix: 16);
    for (final icon in _goalIconChoices) {
      if (icon.codePoint == iconCode) return icon;
    }
  } catch (e) {
    logger.severe('Error parsing icon string: $e');
  }
  return Icons.flag_outlined;
}

/// Const Material icons used by goals — keep this list for tree-shaking.
const List<IconData> _goalIconChoices = <IconData>[
  Icons.flag_outlined,
  Icons.home_outlined,
  Icons.directions_car_outlined,
  Icons.flight_takeoff_outlined,
  Icons.school_outlined,
  Icons.savings_outlined,
  Icons.favorite_outline,
  Icons.fitness_center_outlined,
  Icons.phone_android_outlined,
  Icons.laptop_mac_outlined,
  Icons.shopping_bag_outlined,
  Icons.celebration_outlined,
  Icons.pets_outlined,
  Icons.child_care_outlined,
  Icons.work_outline,
  Icons.account_balance_wallet_outlined,
  Icons.beach_access_outlined,
  Icons.restaurant_outlined,
  Icons.sports_soccer_outlined,
  Icons.music_note_outlined,
  Icons.camera_alt_outlined,
  Icons.card_giftcard_outlined,
  Icons.health_and_safety_outlined,
  Icons.bolt_outlined,
  Icons.water_drop_outlined,
  Icons.trending_up_outlined,
];

class _GoalsScreenState extends State<GoalsScreen> {
  /// API status keys: Active / Pending / Archived
  String _selected = 'Active';

  void _openCreateSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        final inset = MediaQuery.viewInsetsOf(context).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: const FractionallySizedBox(
            heightFactor: 0.95,
            child: NewGoalsBottomSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return BlocProvider<GoalsBloc>(
      create: (context) => GoalsBloc()..add(FetchAllGoalsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7F6),
            floatingActionButton: FloatingActionButton(
              backgroundColor: HomeDesign.green,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              onPressed: () => _openCreateSheet(context),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _GoalsTabs(
                      selected: _selected,
                      onChanged: (v) => setState(() => _selected = v),
                    ),
                  ),
                  Expanded(child: _buildGoalsList(context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 1,
          shadowColor: Colors.black26,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.pop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                LucideIcons.chevronLeft,
                size: 22,
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
                'My Goals',
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
            onTap: () => _openCreateSheet(context),
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
                    LucideIcons.target,
                    size: 14,
                    color: HomeDesign.green,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Targets',
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

  Widget _buildGoalsList(BuildContext context) {
    return RefreshIndicator(
      color: HomeDesign.green,
      onRefresh: () async {
        context.read<GoalsBloc>().add(FetchAllGoalsEvent());
      },
      child: BlocBuilder<GoalsBloc, GoalsState>(
        builder: (context, state) {
          if (state.status == ServiceStatus.loading) {
            return const Center(child: LogoLoader());
          }
          if (state.status == ServiceStatus.loadingFailure) {
            return _buildErrorState(context, state.message?.message);
          }

          final goals = state.goals ?? const <Goals>[];
          final filtered = goals
              .where((goal) =>
                  (goal.status ?? '').toLowerCase() == _selected.toLowerCase())
              .toList();

          if (goals.isEmpty || filtered.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                _EmptyGoalsCard(
                  title: goals.isEmpty
                      ? 'No goals yet'
                      : 'No ${_tabLabel(_selected).toLowerCase()} goals',
                  body: goals.isEmpty
                      ? 'Set a savings target and track your progress toward what matters most.'
                      : 'Switch tabs to see other goals, or create a new one.',
                  onCreate: () => _openCreateSheet(context),
                ),
                if (goals.isEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoList(onTap: () => _openCreateSheet(context)),
                  const SizedBox(height: 12),
                  const _GoalsTipCard(),
                ],
              ],
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final goal = filtered[index];
              final saved = (goal.amountSaved ?? 0).toDouble();
              final target = (goal.targetAmount ?? 1).toDouble();
              final color = Color(
                int.parse(goal.color ?? 'FF012340', radix: 16),
              );

              return GoalsCard(
                goalId: goal.id ?? 0,
                goalStatus: goal.status ?? 'active',
                key: ValueKey(goal.id),
                onPressed: () {
                  context.pushNamed(Routes.goalDetail, extra: goal);
                },
                value: target == 0 ? 0 : saved / target,
                indicatorColor: color,
                iconBgColor: color,
                icon: getIconDataFromString(
                  goal.icon ?? 'IconData(U+e000)',
                ),
                text: goal.name ?? '',
                description:
                    'KES ${saved.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}',
              );
            },
          );
        },
      ),
    );
  }

  String _tabLabel(String key) {
    switch (key) {
      case 'Pending':
        return 'Paused';
      case 'Archived':
        return 'Achieved';
      default:
        return 'Active';
    }
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 40, color: HomeDesign.muted),
            const SizedBox(height: 12),
            Text(
              'Couldn’t load goals',
              style: HomeDesign.text(
                size: 16,
                weight: FontWeight.w600,
                color: HomeDesign.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: HomeDesign.text(size: 13, color: HomeDesign.muted),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<GoalsBloc>().add(FetchAllGoalsEvent());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsTabs extends StatelessWidget {
  const _GoalsTabs({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (key: 'Active', label: 'Active', icon: LucideIcons.target),
      (key: 'Pending', label: 'Paused', icon: LucideIcons.pause),
      (key: 'Archived', label: 'Achieved', icon: LucideIcons.check),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(tab.key),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == tab.key
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: selected == tab.key
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tab.icon,
                            size: 14,
                            color: selected == tab.key
                                ? HomeDesign.green
                                : HomeDesign.muted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            tab.label,
                            style: HomeDesign.text(
                              size: 12,
                              weight: selected == tab.key
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected == tab.key
                                  ? HomeDesign.green
                                  : HomeDesign.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: selected == tab.key ? 28 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: HomeDesign.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyGoalsCard extends StatelessWidget {
  const _EmptyGoalsCard({
    required this.title,
    required this.body,
    required this.onCreate,
  });

  final String title;
  final String body;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
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
          const SizedBox(
            width: 120,
            height: 100,
            child: CustomPaint(painter: _TargetLeavesPainter()),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: HomeDesign.text(
              size: 16,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
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
                'Create a goal',
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

class _InfoList extends StatelessWidget {
  const _InfoList({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          _InfoRow(
            icon: LucideIcons.flag,
            title: 'Save for travel, school, or an emergency fund',
            subtitle: 'Plan for the things that matter to you.',
            onTap: onTap,
          ),
          const Divider(height: 1, color: Color(0xFFF0F1F3)),
          _InfoRow(
            icon: LucideIcons.trendingUp,
            title: 'Watch your progress as you save',
            subtitle: 'See how close you are to reaching your goals.',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F6EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: HomeDesign.greenDeep, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: HomeDesign.text(
                      size: 13,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: HomeDesign.text(
                      size: 11.5,
                      weight: FontWeight.w400,
                      color: HomeDesign.muted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: HomeDesign.green,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsTipCard extends StatelessWidget {
  const _GoalsTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 10, 14),
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
              color: Color(0xFFD6F0DE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.lightbulb,
              size: 18,
              color: HomeDesign.greenDeep,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tip',
                    style: HomeDesign.text(
                      size: 10,
                      weight: FontWeight.w600,
                      color: HomeDesign.green,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Small steps today, big results tomorrow',
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consistent saving helps you build the future you dream of.',
                  style: HomeDesign.text(
                    size: 11.5,
                    weight: FontWeight.w400,
                    color: HomeDesign.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(painter: _TipChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _TargetLeavesPainter extends CustomPainter {
  const _TargetLeavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.52;
    final cy = size.height * 0.52;

    // Leaves
    final leaf = Paint()..color = const Color(0xFFB8F5C8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.55),
        width: 28,
        height: 16,
      ),
      leaf,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.82, size.height * 0.4),
        width: 22,
        height: 14,
      ),
      leaf,
    );

    // Sparks
    final spark = Paint()..color = const Color(0xFF7CF0A0);
    for (final p in [
      Offset(size.width * 0.18, size.height * 0.28),
      Offset(size.width * 0.78, size.height * 0.22),
      Offset(size.width * 0.88, size.height * 0.62),
    ]) {
      canvas.drawCircle(p, 2.2, spark);
    }

    // Target rings
    canvas.drawCircle(Offset(cx, cy), 30, Paint()..color = const Color(0xFF3CDB73));
    canvas.drawCircle(Offset(cx, cy), 20, Paint()..color = const Color(0xFF0B3D2E));
    canvas.drawCircle(Offset(cx, cy), 9, Paint()..color = Colors.white);

    // Arrow
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.18),
      Offset(cx - 2, cy - 2),
      Paint()
        ..color = const Color(0xFF0F9D58)
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
    final tip = Path()
      ..moveTo(cx + 3, cy + 3)
      ..lineTo(cx - 8, cy)
      ..lineTo(cx, cy - 8)
      ..close();
    canvas.drawPath(tip, Paint()..color = const Color(0xFF0F9D58));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TipChartPainter extends CustomPainter {
  const _TipChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final heights = [0.35, 0.55, 0.45, 0.78];
    final w = size.width / (heights.length * 1.8);
    for (var i = 0; i < heights.length; i++) {
      paint.color = Color.lerp(
            const Color(0xFFB8F5C8),
            HomeDesign.green,
            i / (heights.length - 1),
          ) ??
          HomeDesign.green;
      final h = size.height * heights[i] * 0.55;
      final x = i * (w * 1.5);
      final y = size.height * 0.72 - h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h),
          const Radius.circular(2.5),
        ),
        paint,
      );
    }

    // Trend line
    final line = Path()
      ..moveTo(2, size.height * 0.55)
      ..lineTo(size.width * 0.35, size.height * 0.42)
      ..lineTo(size.width * 0.55, size.height * 0.48)
      ..lineTo(size.width * 0.78, size.height * 0.28);
    canvas.drawPath(
      line,
      Paint()
        ..color = HomeDesign.green
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Plant
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.78, size.height * 0.72, 8, 10),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFC47A2C),
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.66),
      6,
      Paint()..color = const Color(0xFF0F9D58),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
