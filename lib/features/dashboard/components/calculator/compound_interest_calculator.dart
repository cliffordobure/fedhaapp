// ignore_for_file: library_private_types_in_public_api

import 'dart:math' as math;

import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CompoundInterestCalc extends StatefulWidget {
  const CompoundInterestCalc({super.key});

  @override
  _CompoundInterestCalcState createState() => _CompoundInterestCalcState();
}

class _CompoundFrequency {
  const _CompoundFrequency(this.label, this.timesPerYear, this.hint);
  final String label;
  final int timesPerYear;
  final String hint;
}

class _CompoundInterestCalcState extends State<CompoundInterestCalc> {
  final _principalCtrl = TextEditingController(text: '100000');
  final _rateCtrl = TextEditingController(text: '10');
  final _yearsCtrl = TextEditingController(text: '5');

  static const _frequencies = <_CompoundFrequency>[
    _CompoundFrequency('Yearly', 1, 'Once a year'),
    _CompoundFrequency('Half-year', 2, 'Every 6 months'),
    _CompoundFrequency('Quarterly', 4, 'Every 3 months'),
    _CompoundFrequency('Monthly', 12, 'Every month'),
    _CompoundFrequency('Daily', 365, 'Every day'),
  ];

  int _frequencyIndex = 3; // Monthly — common default
  final _money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
  final _moneyExact =
      NumberFormat.currency(symbol: 'KES ', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    for (final c in [_principalCtrl, _rateCtrl, _yearsCtrl]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in [_principalCtrl, _rateCtrl, _yearsCtrl]) {
      c.removeListener(_onChanged);
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  double get _principal =>
      double.tryParse(_principalCtrl.text.replaceAll(',', '')) ?? 0;
  double get _rate => double.tryParse(_rateCtrl.text) ?? 0;
  double get _years => double.tryParse(_yearsCtrl.text) ?? 0;
  int get _n => _frequencies[_frequencyIndex].timesPerYear;

  /// A = P (1 + r/n)^(n t)
  double get _finalAmount {
    if (_principal <= 0 || _years <= 0) return _principal;
    if (_rate <= 0) return _principal;
    final r = _rate / 100;
    return _principal * math.pow(1 + (r / _n), _n * _years);
  }

  double get _simpleFinal {
    if (_principal <= 0 || _years <= 0) return _principal;
    return _principal * (1 + (_rate / 100) * _years);
  }

  double get _interestEarned => (_finalAmount - _principal).clamp(0, double.infinity);
  double get _extraVsSimple =>
      (_finalAmount - _simpleFinal).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildResultCard(),
                  const SizedBox(height: 18),
                  _buildSectionTitle('Your investment'),
                  const SizedBox(height: 10),
                  _CalcField(
                    controller: _principalCtrl,
                    label: 'Starting amount',
                    hint: 'e.g. 100,000',
                    helper: 'How much you invest today',
                    prefix: 'KES',
                    icon: LucideIcons.wallet,
                    decimals: 2,
                  ),
                  const SizedBox(height: 12),
                  _CalcField(
                    controller: _rateCtrl,
                    label: 'Annual interest rate',
                    hint: 'e.g. 10',
                    helper: 'Yearly rate your money grows at',
                    suffix: '%',
                    icon: LucideIcons.percent,
                    decimals: 2,
                  ),
                  const SizedBox(height: 12),
                  _CalcField(
                    controller: _yearsCtrl,
                    label: 'Time period',
                    hint: 'e.g. 5',
                    helper: 'How long you plan to invest',
                    suffix: 'years',
                    icon: LucideIcons.calendarDays,
                    decimals: 1,
                  ),
                  const SizedBox(height: 18),
                  _buildSectionTitle('How often does interest add up?'),
                  const SizedBox(height: 4),
                  Text(
                    'More often usually means you earn a bit more.',
                    style: TextStyle(
                      color: AppColors.fadeBlackColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildFrequencyChips(),
                  const SizedBox(height: 18),
                  _buildBreakdownCard(),
                  const SizedBox(height: 14),
                  _buildTipCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 12, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded,
                color: AppColors.darkBlueColor, size: 24),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Growth calculator',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                ),
                Text(
                  'See how your money can grow over time',
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.darkBlueColor,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    );
  }

  Widget _buildResultCard() {
    final hasInput = _principal > 0 && _years > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkBlueColor,
            AppColors.darkGreenColor,
            AppColors.primaryColor.withValues(alpha: 0.92),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hasInput ? 'Projected value' : 'Enter details below',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(LucideIcons.trendingUp,
                  size: 18, color: Colors.white.withValues(alpha: 0.9)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hasInput ? _moneyExact.format(_finalAmount) : 'KES 0.00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasInput
                ? 'After ${_formatYears(_years)} with ${_frequencies[_frequencyIndex].label.toLowerCase()} compounding'
                : 'Your future balance will show here instantly',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13,
              height: 1.3,
            ),
          ),
          if (hasInput && _interestEarned > 0) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.sparkles,
                      size: 16, color: Colors.white.withValues(alpha: 0.95)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Interest earned: ${_money.format(_interestEarned)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
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

  Widget _buildFrequencyChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_frequencies.length, (i) {
        final f = _frequencies[i];
        final selected = i == _frequencyIndex;
        return ChoiceChip(
          selected: selected,
          label: Text(f.label),
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.darkColor,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
          selectedColor: AppColors.primaryColor,
          backgroundColor: AppColors.whiteColor,
          side: BorderSide(
            color: selected
                ? AppColors.primaryColor
                : AppColors.greyColor.withValues(alpha: 0.55),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          onSelected: (_) => setState(() => _frequencyIndex = i),
        );
      }),
    );
  }

  Widget _buildBreakdownCard() {
    final hasInput = _principal > 0 && _years > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakdown',
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          _breakdownRow('You invest', hasInput ? _money.format(_principal) : '—'),
          _breakdownRow(
            'Interest earned',
            hasInput ? _money.format(_interestEarned) : '—',
            valueColor: AppColors.primaryColor,
          ),
          _breakdownRow(
            'Final amount',
            hasInput ? _moneyExact.format(_finalAmount) : '—',
            emphasize: true,
          ),
          if (hasInput && _extraVsSimple > 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
                color: AppColors.greyColor.withValues(alpha: 0.45),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Compounding adds about ${_money.format(_extraVsSimple)} more than simple interest over ${_formatYears(_years)}.',
                style: TextStyle(
                  color: AppColors.darkColor,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _breakdownRow(
    String label,
    String value, {
    Color? valueColor,
    bool emphasize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.fadeBlackColor,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.darkBlueColor,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
              fontSize: emphasize ? 15 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.lightbulb,
              size: 18, color: AppColors.darkBlueColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tip: Starting earlier — even with a smaller amount — often beats waiting to invest a larger sum later.',
              style: TextStyle(
                color: AppColors.darkColor,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatYears(double years) {
    if (years == years.roundToDouble()) {
      final y = years.round();
      return '$y ${y == 1 ? 'year' : 'years'}';
    }
    return '${years.toStringAsFixed(1)} years';
  }
}

class _CalcField extends StatelessWidget {
  const _CalcField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.helper,
    required this.icon,
    this.prefix,
    this.suffix,
    this.decimals = 2,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String helper;
  final IconData icon;
  final String? prefix;
  final String? suffix;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextInputFormatter(decimalRange: decimals)],
            style: TextStyle(
              color: AppColors.darkColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.fadeBlackColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixText: prefix != null ? '$prefix  ' : null,
              prefixStyle: TextStyle(
                color: AppColors.fadeBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                color: AppColors.fadeBlackColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.scaffoldBackground,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            helper,
            style: TextStyle(
              color: AppColors.fadeBlackColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var truncated = newValue.text;
    var newSelection = newValue.selection;
    final value = newValue.text;

    if ((value.trim().isNotEmpty && double.tryParse(value) == null) ||
        value.split('.').length > 2 ||
        (value.contains('.') &&
            value.substring(value.indexOf('.') + 1).length > decimalRange)) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == '.') {
      truncated = '0.';
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
