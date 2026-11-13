import 'dart:math' as math;

import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Design tokens matched to the Fedha home mock.
class HomeDesign {
  static const bg = Color(0xFFFFFFFF);
  static const ink = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const green = Color(0xFF0F9D58);
  static const greenDeep = Color(0xFF0B3D2E);
  static const mint = Color(0xFFE6F6EC);
  static const mintSoft = Color(0xFFEDF8F1);
  static const income = Color(0xFF0F9D58);
  static const expense = Color(0xFFE25555);
  static const pad = 20.0;

  /// Poppins — rounded geometric sans matching the mock.
  static TextStyle text({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = ink,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

String formatHomeMoney(double amount) {
  final abs = amount.abs();
  if (abs >= 1000000) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: 'KES ',
      decimalDigits: 2,
    ).format(amount);
  }
  if (abs >= 100000) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: 'KES ',
      decimalDigits: 1,
    ).format(amount);
  }
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: 'KES ',
    decimalDigits: 0,
  ).format(amount);
}

/// Full shilling amount, e.g. "KES 106,000" instead of "KES 106K".
String formatHomeMoneyFull(double amount) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: 'KES ',
    decimalDigits: 0,
  ).format(amount);
}

/// Dark green net-worth hero matching the home redesign.
class HomeNetWorthCard extends StatefulWidget {
  const HomeNetWorthCard({super.key});

  @override
  State<HomeNetWorthCard> createState() => _HomeNetWorthCardState();
}

class _HomeNetWorthCardState extends State<HomeNetWorthCard> {
  bool _concealed = false;

  @override
  Widget build(BuildContext context) {
    if (context.read<DataBloc>().state.status == ServiceStatus.initial) {
      context.read<DataBloc>().add(StartDataBloc());
    }

    return BlocBuilder<DataBloc, DataState>(
      buildWhen: (p, c) => p.data != c.data || p.status != c.status,
      builder: (context, state) {
        if (state.status == ServiceStatus.loadingFailure) {
          return _error(state);
        }
        final data = state.status == ServiceStatus.loadingSuccess
            ? state
            : state.copyWith(
                status: ServiceStatus.loadingSuccess,
                data: state.data.isEmpty
                    ? LocalDataCache.emptyHomeCard()
                    : state.data,
                totals: state.data.isEmpty ? 0 : state.totals,
              );
        return _card(data);
      },
    );
  }

  Widget _error(DataState state) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${state.message?.message}'),
          TextButton(
            onPressed: () => context.read<DataBloc>().add(RefreshData()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _card(DataState state) {
    final netWorth = _amount(state, 'total_balance');
    final assets = _amount(state, 'incomes');
    final liabilities = _amount(state, 'expenses');
    final saved = assets - liabilities;
    final trendPct = assets > 0 ? ((saved / assets) * 100) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: HomeDesign.greenDeep.withValues(alpha: 0.22),
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
              child: CustomPaint(painter: _WavePatternPainter()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total Net Worth',
                        style: HomeDesign.text(
                          size: 12,
                          weight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () =>
                              setState(() => _concealed = !_concealed),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              _concealed
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _concealed ? 'KES ••••••' : formatHomeMoneyFull(netWorth),
                      style: HomeDesign.text(
                        size: 28,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.4,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9AF0B5).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${trendPct >= 0 ? '▲' : '▼'}  '
                      '${trendPct.abs().toStringAsFixed(1)}% this month',
                      style: HomeDesign.text(
                        size: 11,
                        weight: FontWeight.w600,
                        color: const Color(0xFF9AF0B5),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _miniStat(
                          icon: LucideIcons.wallet,
                          iconBg: const Color(0xFF1FA85A),
                          label: 'Total Assets',
                          value: _concealed
                              ? '••••'
                              : formatHomeMoney(assets),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _miniStat(
                          icon: LucideIcons.wallet,
                          iconBg: const Color(0xFFD96A5A),
                          label: 'Total Liabilities',
                          value: _concealed
                              ? '••••'
                              : formatHomeMoney(liabilities),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 11, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HomeDesign.text(
                    size: 10.5,
                    weight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.78),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  double _amount(DataState state, String key) {
    final value = state.data[key];
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '')) ?? 0;
    }
    return 0;
  }
}

class _WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var i = 0; i < 6; i++) {
      final path = Path();
      final yBase = size.height * (0.22 + i * 0.13);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 5) {
        final y = yBase + math.sin((x / size.width) * math.pi * 2.2 + i) * 8;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
