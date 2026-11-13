import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeDonut extends StatefulWidget {
  const HomeDonut({Key? key}) : super(key: key);

  @override
  State<HomeDonut> createState() => HomeDonutState();
}

class HomeDonutState extends State<HomeDonut> {
  bool concealed = false;

  final _compact =
      NumberFormat.compactCurrency(symbol: 'KES ', decimalDigits: 1);
  final _money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    if (context.read<DataBloc>().state.status == ServiceStatus.initial) {
      context.read<DataBloc>().add(StartDataBloc());
    }

    return BlocBuilder<DataBloc, DataState>(
      buildWhen: (previous, current) =>
          previous.data != current.data || previous.status != current.status,
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
    return Center(
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
    final balance = _amount(state, 'total_balance');
    final income = _amount(state, 'incomes');
    final expense = _amount(state, 'expenses');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF012340).withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Clean premium gradient — no busy drawings
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF012340),
                      Color(0xFF013A2C),
                      Color(0xFF026B3A),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            // Soft light glow top-right
            Positioned(
              right: -40,
              top: -50,
              child: IgnorePointer(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Soft green glow bottom-left
            Positioned(
              left: -50,
              bottom: -60,
              child: IgnorePointer(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF3CDB73).withValues(alpha: 0.18),
                        const Color(0xFF3CDB73).withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Fedha',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      _iconBtn(
                        icon: concealed
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        onTap: () => setState(() => concealed = !concealed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Available balance',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      concealed ? 'KES ••••••' : _fmt(balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _statTile(
                          icon: LucideIcons.arrowUpRight,
                          label: 'Income',
                          value: concealed ? '••••' : _fmt(income),
                          tint: const Color(0xFF3CDB73),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statTile(
                          icon: LucideIcons.arrowDownRight,
                          label: 'Expense',
                          value: concealed ? '••••' : _fmt(expense),
                          tint: const Color(0xFFFF8A80),
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

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required String value,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
                  color: tint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 12, color: tint),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double amount) {
    if (amount >= 100000) return _compact.format(amount);
    return _money.format(amount);
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
