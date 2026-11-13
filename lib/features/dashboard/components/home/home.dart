import 'dart:async';

import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:fedha/constants/constants.dart';
import 'package:fedha/constants/global_keys.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/ads/bloc.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/app/blocs/graphs/bloc.dart';
import 'package:fedha/features/app/blocs/membership/bloc.dart';
import 'package:fedha/features/app/blocs/notifications/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/tuitorial/bloc.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/home/utils/utils.dart';
import 'package:fedha/features/dashboard/components/home/widgets/add_wallet_bottom_sheet.dart';
import 'package:fedha/features/dashboard/components/home/widgets/banner.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_dashboard_sections.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/home/widgets/wallet_card.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/allocation_link_sheet.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/message_reading_service/scheduller.dart';
import 'package:fedha/utils/notifications_service/notification_service.dart';
import 'package:fedha/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({super.key, this.startTutorial = false});
  late final bool startTutorial;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final Telephony telephony = Telephony.instance;
  final AppPreferences prefs = service<AppPreferences>();
  bool _didInitBlocs = false;
  bool _handlingAllocationPrompt = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeBlocs(context);
      unawaited(_runFirstLaunchPrompts());
    });
  }

  /// SMS and notification dialogs, then the walkthrough.
  ///
  /// A new account hits all three at once. Inserting the coach-mark overlay
  /// in the same frame as a dialog route makes Flutter drop a GlobalKey
  /// element (`_elements.contains(element)`).
  Future<void> _runFirstLaunchPrompts() async {
    if (!mounted) return;
    await showSmsDialog(context);
    if (!mounted) return;
    await NotificationService.checkNotificationPermissions(context);
    if (!mounted) return;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    // Root navigator overlay covers the tab bar and the home content.
    final tutorialContext = Navigator.of(context, rootNavigator: true).context;
    if (!tutorialContext.mounted) return;
    context
        .read<TuitorialBloc>()
        .add(CheckTuitorialEvent(context: tutorialContext));
  }

  @override
  void dispose() {
    // Clean up resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationRepository.instance.user;

    return MultiBlocListener(
      listeners: [
        BlocListener<TuitorialBloc, TuitorialState>(
          listener: (context, state) {
            logger.info("Start tutorial in home is : ${state.startTutorial}");
            if (state.startTutorial) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  context
                      .read<TuitorialBloc>()
                      .add(ShowTuitorialEvent(context: context, force: true));
                },
              );
            }
          },
        ),
        BlocListener<TransactionsBloc, TransactionsState>(
          listenWhen: (prev, next) =>
              next.pendingAllocationMatches.isNotEmpty &&
              next.pendingAllocationMatches != prev.pendingAllocationMatches,
          listener: (context, state) {
            unawaited(_handleAllocationMatches(
              context,
              state.pendingAllocationMatches,
            ));
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: HomeDesign.bg,
        appBar: _buildAppBar(),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context)
                .textScaler
                .clamp(minScaleFactor: 0.95, maxScaleFactor: 1.0),
          ),
          child: RefreshIndicator(
            onRefresh: () => _refreshData(context),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                _buildHeaderSection(context, user),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: HomeQuickNav(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: HomeInsightCard(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: HomeCashFlowCard(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: BlocBuilder<TransactionsBloc, TransactionsState>(
                      builder: (context, state) {
                        if (state.status == ServiceStatus.loading &&
                            state.transactions.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return HomeRecentTransactions(
                          transactions: state.transactions,
                        );
                      },
                    ),
                  ),
                ),
                // Ads / wallets below the mock content so the first screen matches.
                _buildWalletsSection(),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                    child: BannerSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 88,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAllocationMatches(
    BuildContext context,
    List<Transaction> pending,
  ) async {
    if (_handlingAllocationPrompt || pending.isEmpty) return;
    _handlingAllocationPrompt = true;
    try {
      if (!mounted) return;
      context.read<TransactionsBloc>().add(ClearPendingAllocationMatches());
      await ensureAllocationCatalogLoaded(context);
      if (!mounted) return;

      final cache = service<LocalDataCache>();
      final dismissed = await cache.loadDismissedAllocationCodes();
      final links = await cache.loadTransactionLinks();
      final catalog = allocationCatalogFromContext(context);

      for (final tx in pending) {
        final code = tx.transactionId.trim();
        if (code.isEmpty ||
            dismissed.contains(code) ||
            links.containsKey(code)) {
          continue;
        }
        final matches = TransactionAllocationMatcher.findMatches(
          tx,
          catalog,
          limit: 1,
          requireAmountMatch: true,
        );
        if (matches.isEmpty) continue;
        if (!context.mounted) return;

        final choice = await showAllocationMatchConfirmDialog(
          context,
          transaction: tx,
          match: matches.first,
        );
        if (!context.mounted) return;

        if (choice == true) {
          await saveAllocationLink(
            transaction: tx,
            match: matches.first,
            context: context,
          );
        } else {
          // No / dismiss — do not link; remember so we don't ask again.
          await cache.dismissAllocationMatch(code);
        }
      }
    } finally {
      _handlingAllocationPrompt = false;
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HomeDesign.bg,
      surfaceTintColor: HomeDesign.bg,
      elevation: 0,
      leading: IconButton(
        key: menuDrawerKey,
        onPressed: () => zoomDrawerController.toggle?.call(),
        icon: const Icon(Icons.menu, color: HomeDesign.ink),
      ),
      actions: [
        BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            final unreadCount = state.notifications
                .where((notif) => notif.status == 0)
                .length;
            final label = unreadCount > 99 ? '99+' : '$unreadCount';

            return IconButton(
              key: notificationsKey,
              tooltip: 'Notifications',
              onPressed: () => context.pushNamed(Routes.notifications),
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                backgroundColor: Colors.red,
                smallSize: 8,
                largeSize: 14,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                label: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: HomeDesign.ink),
              ),
            );
          },
        ),
      ],
    );
  }

  void _initializeBlocs(BuildContext context) {
    if (_didInitBlocs) return;
    _didInitBlocs = true;

    final walletsBloc = context.read<WalletsBloc>();
    if (walletsBloc.state.status == ServiceStatus.initial) {
      walletsBloc.add(StartWalletBloc());
    }

    _initializeOtherBlocs(context);
  }

  Future<void> _initializeOtherBlocs(BuildContext context) async {
    final adsBloc = context.read<AdsBloc>();
    final transactionsBloc = context.read<TransactionsBloc>();
    final memberShipBloc = context.read<MemberShipBloc>();
    final graphsBloc = context.read<GraphsBloc>();
    final dataBloc = context.read<DataBloc>();
    final notificationsBloc = context.read<NotificationsBloc>();
    final plannedPaymentBloc = context.read<PlannedPaymentBloc>();
    final goalsBloc = context.read<GoalsBloc>();
    final userBudgetBloc = context.read<UserBudgetBloc>();
    final billsBloc = context.read<BillsBloc>();

    // Stagger startup fetches so we don't burn the 60 req/min API budget.
    Future<void> kick(void Function() action) async {
      if (!mounted) return;
      action();
      await Future.delayed(const Duration(milliseconds: 350));
    }

    // Prefetch notifications early so the bell opens instantly.
    if (notificationsBloc.state.status == ServiceStatus.initial) {
      await kick(() => notificationsBloc.add(const StartNotifications()));
    }
    if (transactionsBloc.state.status == ServiceStatus.initial) {
      await kick(() => transactionsBloc.add(StartTransactions()));
    }
    if (dataBloc.state.status == ServiceStatus.initial) {
      await kick(() => dataBloc.add(StartDataBloc()));
    }
    if (graphsBloc.state.status == ServiceStatus.initial) {
      await kick(() => graphsBloc.add(FetchWeekly()));
    }
    if (adsBloc.state.status == ServiceStatus.initial) {
      await kick(() => adsBloc.add(StartAdsBloc()));
    }
    if (memberShipBloc.state.status == ServiceStatus.initial) {
      await kick(() => memberShipBloc.add(StartMemberShip()));
    }
    await kick(
      () => plannedPaymentBloc.add(const PlannedPaymentEvent.fetched()),
    );
    if (goalsBloc.state.status == ServiceStatus.initial) {
      await kick(() => goalsBloc.add(FetchAllGoalsEvent()));
    }
    if (userBudgetBloc.state.status == ServiceStatus.initial) {
      await kick(() => userBudgetBloc.add(FetchAllUserBudgetsEvent()));
    }
    if (billsBloc.state.status == ServiceStatus.initial) {
      await kick(() => billsBloc.add(StartBillsBloc()));
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    // Re-scan recent SMS first so M-Pesa sends appear even if an earlier
    // sync skipped them (rate limit / parse failure).
    await syncMessagesNow(lookback: kSmsImportMaxWindow);
    if (!context.mounted) return;

    // Sequential refresh avoids another 429 storm on pull-to-refresh.
    context.read<TransactionsBloc>().add(RefreshTransactions());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    context.read<WalletsBloc>().add(RefreshWallets());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    context.read<DataBloc>().add(RefreshData());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    context.read<GraphsBloc>().add(RefreshGraphs());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    context.read<AdsBloc>().add(RefreshAds());
    await Future.delayed(const Duration(milliseconds: 400));
    if (!context.mounted) return;
    context.read<NotificationsBloc>().add(const StartNotifications());
  }

  Widget _buildHeaderSection(BuildContext context, dynamic user) {
    final firstName = capitalize((user?.name ?? 'there').split(' ').first);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$greeting, ',
                    style: HomeDesign.text(
                      size: 18,
                      weight: FontWeight.w400,
                      color: HomeDesign.ink,
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: firstName,
                    style: HomeDesign.text(
                      size: 20,
                      weight: FontWeight.w700,
                      color: HomeDesign.ink,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: ' 👋',
                    style: HomeDesign.text(
                      size: 18,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Here’s your financial overview',
              style: HomeDesign.text(
                size: 12,
                weight: FontWeight.w400,
                color: HomeDesign.muted,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.pushNamed(Routes.analytics),
              child: const HomeNetWorthCard(),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildWalletsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Wallets',
                  style: HomeDesign.text(
                    size: 15,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Text(
                  'Your accounts',
                  style: HomeDesign.text(
                    size: 11,
                    weight: FontWeight.w500,
                    color: HomeDesign.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 102,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8EAED)),
              ),
              child: _buildWalletsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletsList() {
    return BlocConsumer<WalletsBloc, WalletsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return _buildLoadingIndicator();
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return _buildErrorWidget();
        }
        return ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          children: [
            ...state.wallets.map((wallet) => WalletCard(wallet: wallet)),
            _buildAddWalletButton(),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      height: 100,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(child: Text("An error occurred")),
      ),
    );
  }

  Widget _buildAddWalletButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () => _showAddWalletBottomSheet(context),
        child: Column(
          children: [
            DottedBorder(
              borderType: BorderType.Circle,
              color: AppColors.darkColor,
              strokeWidth: 1,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  radius: 23,
                  child: Icon(Icons.add,
                      key: newWalletKey, color: AppColors.darkBlueColor),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text("New Wallet", style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  void _showAddWalletBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const AddWalletBottomSheet(),
    );
  }
}


// ElevatedButton(
//     onPressed: () async {
//       await NotificationService.showImmediateNotification(
//         "Immediate Notification",
//         "This is an immediate notification",
//       );
//       await NotificationService.scheduleOneTimeNotification(
//         id: 1,
//         title: "One-time Notification",
//         body: "This is a one-time scheduled notification",
//         scheduledDateTime: DateTime.now().add(
//           const Duration(minutes: 1),
//         ),
//       );
//       await NotificationService.scheduleNotification(
//           id: 2,
//           title: "Testing Repeat Notifs",
//           body: "Theae ia a reapeated notif",
//           recurrenceType: RecurrenceType.minutely,
//           time: TimeOfDay.now());
//     },
//     child: Container()),
// const SizedBox(
//   height: 16,
// ),