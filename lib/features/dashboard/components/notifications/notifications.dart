import 'package:fedha/common/fedha_gradient_header.dart';
import 'package:fedha/data/models/notifications/notifications.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/notifications/bloc.dart';
import 'package:fedha/features/dashboard/components/notifications/widgets/notification_card.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Soft refresh — shows cache immediately if available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationsBloc>().add(const StartNotifications());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          final unread = state.notifications.where((n) => n.status == 0).length;
          final hasCache = state.notifications.isNotEmpty;
          final showLoader =
              state.status == ServiceStatus.loading && !hasCache;

          return Column(
            children: [
              FedhaGradientHeader(
                title: 'Notifications',
                showBack: true,
                compact: true,
                onBack: () => Navigator.pop(context),
                badge: unread > 0 ? '$unread new' : 'All caught up',
                subtitle: unread > 0
                    ? 'You have $unread unread notification${unread == 1 ? '' : 's'}.'
                    : 'Swipe left to delete · tap to mark as read.',
              ),
              Expanded(
                child: showLoader
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : state.status == ServiceStatus.loadingFailure && !hasCache
                        ? _buildErrorState(context, state.message?.message)
                        : _buildNotificationList(context, state.notifications),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.wifiOff,
                size: 40, color: AppColors.fadeBlackColor),
            const SizedBox(height: 12),
            Text(
              'Couldn’t load notifications',
              style: TextStyle(
                color: AppColors.darkBlueColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message ?? 'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.fadeBlackColor, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context
                    .read<NotificationsBloc>()
                    .add(const StartNotifications(forceLoader: true));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationModel> notifications,
  ) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // Newest first — reverse once, not per row.
    final items = notifications.reversed.toList(growable: false);

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        context
            .read<NotificationsBloc>()
            .add(const StartNotifications(forceLoader: false));
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = items[index];
          final id = notification.id ?? notification.message.hashCode;

          return Dismissible(
            key: ValueKey('notif-$id-$index'),
            background: _swipeBg(
              alignment: Alignment.centerLeft,
              color: AppColors.primaryColor,
              icon: LucideIcons.check,
              label: 'Read',
            ),
            secondaryBackground: _swipeBg(
              alignment: Alignment.centerRight,
              color: AppColors.dangerColor,
              icon: LucideIcons.trash2,
              label: 'Delete',
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                context
                    .read<NotificationsBloc>()
                    .add(ReadNotification(id: id));
                showSnackBar(
                  context,
                  content: 'Marked as read',
                  bgColor: AppColors.primaryColor,
                );
                return false; // keep in list, just mark read
              }
              context
                  .read<NotificationsBloc>()
                  .add(DeleteNotification(id: id));
              showSnackBar(
                context,
                content: 'Notification deleted',
                bgColor: AppColors.darkBlueColor,
              );
              return true;
            },
            child: NotificationsCard(
              notification: notification,
              onTap: () {
                if (notification.status == 0) {
                  context
                      .read<NotificationsBloc>()
                      .add(ReadNotification(id: id));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.darkBlueColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.bellOff,
                  color: AppColors.darkBlueColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No notifications',
                style: TextStyle(
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'You’re all caught up for now.',
                style: TextStyle(
                  color: AppColors.fadeBlackColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _swipeBg({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: alignment == Alignment.centerLeft
            ? [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
            : [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 18),
              ],
      ),
    );
  }
}
