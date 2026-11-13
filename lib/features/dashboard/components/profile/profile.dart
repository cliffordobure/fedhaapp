import 'dart:io';

import 'package:fedha/common/fedha_gradient_header.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/features/app/blocs/profile_image/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/tuitorial/bloc.dart';
import 'package:fedha/features/authentication/delete_screen.dart';
import 'package:fedha/features/dashboard/components/profile/components/password_change.dart';
import 'package:fedha/features/dashboard/components/profile/components/reset_transactions_sheet.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/statement_import_sheet.dart';
import 'package:fedha/features/dashboard/widgets/drawer.dart';
import 'package:fedha/features/helpers/privacy_policy.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  CloudSyncStatus? _syncStatus;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    )..forward();
    _loadSyncStatus();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _loadSyncStatus() async {
    final status = await service<LocalDataCache>().loadCloudSyncStatus();
    if (!mounted) return;
    setState(() => _syncStatus = status);
  }

  Future<void> _syncNow() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    showLoading('Syncing with cloud…');
    try {
      final ok =
          await service<SyncEngine>().syncNow(forcePull: true).timeout(
        SyncEngine.syncTimeout + const Duration(seconds: 5),
        onTimeout: () => false,
      );
      final cached = await service<LocalDataCache>().loadTransactions();
      if (mounted && cached != null) {
        context.read<TransactionsBloc>().add(
              ApplyLocalTransactions(
                transactions: cached.transactions,
                total: cached.total,
              ),
            );
      }
      await _loadSyncStatus();
      final pending = _syncStatus?.pendingUploadCount ?? 0;
      final pushError = service<SyncEngine>().lastPushError;
      if (!ok && (pushError == null || pushError.isEmpty)) {
        showError(
          'Sync timed out. Check your internet and try again.',
        );
      } else if (pending > 0) {
        showError(
          pushError != null && pushError.isNotEmpty
              ? pushError
              : '$pending transaction${pending == 1 ? '' : 's'} still waiting to upload. Check your connection and try again.',
        );
      } else {
        showSuccess('Cloud sync complete');
      }
    } catch (e) {
      showError('Sync failed. Please try again.');
    } finally {
      // Always clear the spinner — showSuccess/showError usually replace it,
      // but a hang/timeout path must never leave EasyLoading stuck.
      EasyLoading.dismiss();
      if (mounted) setState(() => _syncing = false);
    }
  }

  Widget _fadeSlide({required double delay, required Widget child}) {
    final curved = CurvedAnimation(
      parent: _entrance,
      curve: Interval(
        delay.clamp(0.0, 0.85),
        (delay + 0.35).clamp(0.15, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - curved.value)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationRepository.instance.user;
    final name = capitalize(user?.name ?? 'User');
    final email = user?.email ?? '';
    final phone = user?.phoneNumber ?? '';
    final plan = user?.accountPlan ?? 'Free';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: FedhaGradientHeader(
              title: 'Profile',
              badge: plan,
              bottom: _buildIdentityCard(
                name: name,
                email: email,
                phone: phone,
                plan: plan,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _fadeSlide(
                  delay: 0.08,
                  child: _section(
                    title: 'Account',
                    children: [
                      _tile(
                        iconPath: 'assets/Icons/Icon ionic-md-person.svg',
                        title: 'Update profile',
                        subtitle: 'Name, email and phone',
                        onTap: () => context.pushNamed(Routes.profileUpdate),
                      ),
                      _tile(
                        iconPath: 'assets/Icons/membership.svg',
                        title: 'Premium membership',
                        subtitle: 'Plans and billing',
                        accent: AppColors.primaryColor,
                        onTap: () => context.pushNamed(Routes.membership),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _fadeSlide(
                  delay: 0.12,
                  child: _buildDataSyncCard(),
                ),
                const SizedBox(height: 14),
                _fadeSlide(
                  delay: 0.14,
                  child: _section(
                    title: 'SMS & history',
                    children: [
                      _tile(
                        iconPath: 'assets/Icons/Icon material-track-changes.svg',
                        title: 'Reset transactions',
                        subtitle: 'Clear history and pick SMS start date',
                        danger: true,
                        onTap: () => showResetTransactionsSheet(context),
                      ),
                      _tile(
                        iconPath: 'assets/Icons/Group 389.svg',
                        title: 'Import statement',
                        subtitle: 'Upload PDF or Excel bank/M-Pesa statement',
                        onTap: () => showStatementImportSheet(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _fadeSlide(
                  delay: 0.16,
                  child: _section(
                    title: 'Preferences',
                    children: [
                      _tile(
                        iconPath: 'assets/Icons/Icon feather-bookmark.svg',
                        title: 'Bookmarked articles',
                        subtitle: 'Saved reading list',
                        onTap: () => context.pushNamed(Routes.bookMarked),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _fadeSlide(
                  delay: 0.24,
                  child: _section(
                    title: 'Support',
                    children: [
                      _tile(
                        iconPath:
                            'assets/Icons/Icon awesome-chalkboard-teacher.svg',
                        title: 'App walkthrough',
                        subtitle: 'Replay the guided tour',
                        onTap: () {
                          final tutorial = context.read<TuitorialBloc>();
                          context.goNamed(Routes.home);
                          tutorial
                              .add(ReShowTuitorialEvent(context: context));
                        },
                      ),
                      _tile(
                        iconPath: 'assets/Icons/Group 389.svg',
                        title: 'Help center',
                        subtitle: 'FAQs and guides',
                        onTap: () => context.pushNamed(Routes.help),
                      ),
                      _tile(
                        iconPath: 'assets/Icons/whatsapp.svg',
                        title: 'Contact us',
                        subtitle: 'Chat on WhatsApp',
                        onTap: _launchWhatsApp,
                      ),
                      _tile(
                        iconPath: 'assets/Icons/invite-user.svg',
                        title: 'Invite a friend',
                        subtitle: 'Share Fedha with others',
                        onTap: () => _shareAppLink(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _fadeSlide(
                  delay: 0.34,
                  child: _section(
                    title: 'Security & privacy',
                    children: [
                      _tile(
                        iconPath: 'assets/Icons/privacy.svg',
                        title: 'Privacy & policies',
                        subtitle: 'How we handle your data',
                        onTap: launchPrivacyAndPolicy,
                      ),
                      _tile(
                        iconPath: 'assets/Icons/Icon ionic-md-person.svg',
                        title: 'Change password',
                        subtitle: 'Update your login password',
                        onTap: () => _showPasswordChangeBottomSheet(context),
                      ),
                      _tile(
                        iconPath: 'assets/Icons/user-delete.svg',
                        title: 'Delete account',
                        subtitle: 'Permanently remove your data',
                        danger: true,
                        onTap: () => _showDeleteAccountBottomsheet(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _fadeSlide(
                  delay: 0.42,
                  child: _logoutButton(context),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSyncCard() {
    final status = _syncStatus;
    final pending = status?.pendingUploadCount ?? 0;
    final failed = status?.failedCount ?? 0;
    final synced = status?.isFullySynced ?? true;
    final lastAt = status?.lastSyncedAt;

    final Color tone = !synced
        ? (failed > 0 ? AppColors.dangerColor : AppColors.warningColor)
        : AppColors.primaryColor;
    final String headline = status == null
        ? 'Checking sync…'
        : synced
            ? 'All data synced'
            : pending > 0
                ? '$pending waiting to upload'
                : '$failed failed to sync';
    final String detail = status == null
        ? 'Reading local database'
        : synced
            ? (lastAt == null
                ? 'Phone and cloud are in sync'
                : 'Last synced ${_formatSyncTime(lastAt)}')
            : 'Tap Sync now to push phone data and pull the latest from the cloud';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Data sync',
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlueColor.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      synced
                          ? LucideIcons.checkCircle2
                          : LucideIcons.uploadCloud,
                      size: 20,
                      color: tone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headline,
                          style: TextStyle(
                            color: AppColors.darkBlueColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          detail,
                          style: TextStyle(
                            color: AppColors.fadeBlackColor,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _syncing ? null : _syncNow,
                  icon: _syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(LucideIcons.refreshCw, size: 16),
                  label: Text(
                    _syncing ? 'Syncing…' : 'Sync now',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlueColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.darkBlueColor.withValues(alpha: 0.55),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSyncTime(DateTime at) {
    final local = at.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24 && now.day == local.day) {
      return DateFormat('h:mm a').format(local);
    }
    if (diff.inDays < 2) return 'yesterday ${DateFormat('h:mm a').format(local)}';
    return DateFormat('MMM d, h:mm a').format(local);
  }

  Widget _buildIdentityCard({
    required String name,
    required String email,
    required String phone,
    required String plan,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.45),
              width: 2,
            ),
          ),
          child: BlocBuilder<ProfileImageBloc, File?>(
            builder: (context, state) {
              return ClipOval(
                child: state != null
                    ? Image.file(state, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/Images/ic_launcher.png',
                        fit: BoxFit.cover,
                      ),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 12.5,
                  ),
                ),
              ],
              if (phone.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$plan plan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlueColor.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 58,
                    endIndent: 16,
                    color: AppColors.greyColor.withValues(alpha: 0.35),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? accent,
    bool danger = false,
  }) {
    final color = danger
        ? AppColors.dangerColor
        : (accent ?? AppColors.darkBlueColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: danger
                            ? AppColors.dangerColor
                            : AppColors.darkBlueColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.fadeBlackColor,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.fadeBlackColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.dangerColor.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlueColor.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.logOut, size: 18, color: AppColors.dangerColor),
              const SizedBox(width: 8),
              Text(
                'Log out',
                style: TextStyle(
                  color: AppColors.dangerColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp() async {
    const url = 'https://wa.me/+254743420920';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _shareAppLink(BuildContext context) {
    const appLink =
        'Hey! I found this amazing app that helps manage finances. Check it out here: https://app.fedhatrac.com';

    Share.share(appLink, subject: 'You should try this app!').then((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App link shared successfully')),
      );
    }).catchError((error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $error')),
      );
    });
  }

  void _showPasswordChangeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      elevation: 5,
      useSafeArea: false,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (context) => const PasswordChangeBottomSheet(),
    );
  }

  void _showDeleteAccountBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DeleteAccountBottomSheet(
            onDeleteSuccess: () {},
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const LogoutDialog(),
    );

    if (confirmLogout == true && context.mounted) {
      AuthenticationRepository.instance.logout();
      context.goNamed(Routes.login);
    }
  }
}
