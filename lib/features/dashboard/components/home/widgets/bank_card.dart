import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/features/dashboard/components/home/utils/color_detector.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankCard extends StatefulWidget {
  const BankCard({super.key, required this.wallet});
  final Wallet wallet;

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  late Future<Color?> _backgroundColor;

  ImageProvider get _logoProvider => bankLogoProvider(
        name: widget.wallet.name,
        shortname: widget.wallet.shortname,
      );

  @override
  void initState() {
    super.initState();
    _backgroundColor = getDominantColorFromProvider(_logoProvider);
  }

  @override
  void didUpdateWidget(covariant BankCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wallet.name != widget.wallet.name ||
        oldWidget.wallet.shortname != widget.wallet.shortname) {
      _backgroundColor = getDominantColorFromProvider(_logoProvider);
    }
  }

  String get _currency {
    final c = widget.wallet.currency?.trim();
    if (c == null || c.isEmpty || c.toLowerCase() == 'null') return 'KES';
    return c;
  }

  String get _accountNumber {
    final n = widget.wallet.accountNumber?.trim();
    if (n == null || n.isEmpty || n.toLowerCase() == 'null') return '';
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color?>(
      future: _backgroundColor,
      builder: (context, snapshot) {
        final base = snapshot.data ?? AppColors.darkBlueColor;
        final textColor = _getTextColorBasedOnBackground(base);
        final money = NumberFormat.currency(
          symbol: '$_currency ',
          decimalDigits: 2,
        );
        final balance =
            double.tryParse(widget.wallet.balance ?? '0') ?? 0.0;

        return Container(
          height: 190,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                base,
                Color.lerp(base, AppColors.darkGreenColor, 0.35) ?? base,
                Color.lerp(base, Colors.black, 0.18) ?? base,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: base.withValues(alpha: 0.35),
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
                  Expanded(
                    child: Text(
                      widget.wallet.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _currency,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: BankLogoImage(
                          name: widget.wallet.name,
                          shortname: widget.wallet.shortname,
                          fit: BoxFit.cover,
                          height: 36,
                          width: 36,
                          fallbackIconSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Available balance',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                money.format(balance),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.4,
                    ),
              ),
              if (_accountNumber.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'Acc · $_accountNumber',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withValues(alpha: 0.75),
                        letterSpacing: 0.6,
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getTextColorBasedOnBackground(Color? backgroundColor) {
    final isLightBackground = isColorLight(backgroundColor);
    return isLightBackground ? Colors.black : Colors.white;
  }
}
