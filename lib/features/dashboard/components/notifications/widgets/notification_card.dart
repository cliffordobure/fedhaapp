import 'package:fedha/data/models/notifications/notifications.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsCard extends StatelessWidget {
  const NotificationsCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;

  bool get _isUnread => notification.status == 0;

  IconData get _icon {
    final title = notification.title.toLowerCase();
    if (title.contains('complete') || title.contains('profile')) {
      return LucideIcons.userCheck;
    }
    if (title.contains('bank') || title.contains('wallet') || title.contains('update')) {
      return LucideIcons.landmark;
    }
    if (title.contains('payment') || title.contains('bill')) {
      return LucideIcons.receipt;
    }
    if (title.contains('goal') || title.contains('budget')) {
      return LucideIcons.target;
    }
    return LucideIcons.bell;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: _isUnread
                ? AppColors.primaryColor.withValues(alpha: 0.06)
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isUnread
                  ? AppColors.primaryColor.withValues(alpha: 0.18)
                  : AppColors.greyColor.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlueColor.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isUnread
                        ? AppColors.primaryColor
                        : AppColors.darkBlueColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icon,
                    size: 20,
                    color: _isUnread
                        ? Colors.white
                        : AppColors.darkBlueColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.darkBlueColor,
                                    fontWeight: _isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TimeBadge(
                            label: notification.timeElapsed,
                            unread: _isUnread,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.fadeBlackColor,
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: _isUnread
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                      if (_isUnread) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Unread',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.label, required this.unread});

  final String label;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: unread
            ? AppColors.primaryColor.withValues(alpha: 0.12)
            : AppColors.darkBlueColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: unread ? AppColors.primaryColor : AppColors.fadeBlackColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
