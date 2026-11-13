import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shared navy → green hero used on Analytics / Planning screens.
class FedhaGradientHeader extends StatelessWidget {
  const FedhaGradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.trailing,
    this.bottom,
    this.showBack = false,
    this.onBack,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final Widget? trailing;
  final Widget? bottom;
  final bool showBack;
  final VoidCallback? onBack;

  /// Smaller padding for nested screens (Budget, Goals, Bills).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        showBack ? 8 : 20,
        topPad + (compact ? 4 : 8),
        20,
        compact ? 18 : 22,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkBlueColor,
            AppColors.darkBlueColor.withValues(alpha: 0.92),
            AppColors.darkGreenColor.withValues(alpha: 0.88),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBack)
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(CupertinoIcons.back, color: Colors.white),
                  visualDensity: VisualDensity.compact,
                ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        fontSize: compact ? 20 : 22,
                      ),
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: compact ? 8 : 10),
            Padding(
              padding: EdgeInsets.only(left: showBack ? 12 : 0),
              child: Text(
                subtitle!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: compact ? 12.5 : 13,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          if (bottom != null) ...[
            SizedBox(height: compact ? 12 : 16),
            Padding(
              padding: EdgeInsets.only(left: showBack ? 12 : 0),
              child: bottom!,
            ),
          ],
        ],
      ),
    );
  }
}
