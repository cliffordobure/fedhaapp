import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/app/blocs/grouped_transactions/grouped_transactions_bloc.dart';
import 'package:fedha/features/app/blocs/notifications/bloc.dart';

import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';

import 'package:fedha/features/app/blocs/search_bank/search_bank_bloc.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';

import 'package:fedha/features/app/blocs/wallets/wallet-details/wallet_details_bloc.dart';

import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/app/blocs/ads/bloc.dart';
import 'package:fedha/features/app/blocs/analytics/blocs.dart';
import 'package:fedha/features/app/blocs/articles/bloc.dart';
import 'package:fedha/features/app/blocs/bank/bloc.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/app/blocs/budget/bloc.dart';
import 'package:fedha/features/app/blocs/chat/bloc.dart';
import 'package:fedha/features/app/blocs/dashboard/bloc.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/graphs/bloc.dart';
import 'package:fedha/features/app/blocs/help/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/membership/bloc.dart';
import 'package:fedha/features/app/blocs/profile_image/bloc.dart';
import 'package:fedha/features/app/blocs/subscriptions/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/tuitorial/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/top_transactions/bloc/top_transactions_bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_analytics/bloc/transactions_analytics_bloc.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_trends/bloc/trends_bloc.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'features/app/blocs/new_analytics/new_analytic_bloc.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final incomeBloc = IncomeBloc();
    final expenseBloc = ExpenseBloc();
    final dataBloc = DataBloc();

    final transactionsBloc =
        TransactionsBloc(incomeBloc, expenseBloc, dataBloc);
    final ProfileImageBloc profileImageBloc = ProfileImageBloc();
    final graphsBloc = GraphsBloc();
    final analyticsBloc = AnalyticsBloc();
    final walletDetailsBloc = WalletDetailsBloc();
    final newAnalyticBloc = NewAnalyticBloc()
      ..add(const NewAnalyticEvent.fetched(period: 'this_month'));
    final walletsBloc = WalletsBloc(
      transactionsBloc,
      graphsBloc: graphsBloc,
      dataBloc: dataBloc,
      newAnalyticBloc: newAnalyticBloc,
      analyticsBloc: analyticsBloc,
      walletDetailsBloc: walletDetailsBloc,
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OverlaySupport(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => DashboardControllerBloc()),
              BlocProvider(
                  create: (context) =>
                      AccountBloc(AuthenticationRepository.instance)),
              BlocProvider(create: (context) => transactionsBloc),
              BlocProvider(create: (context) => graphsBloc),
              BlocProvider(create: (context) => walletsBloc),
              BlocProvider(create: (context) => analyticsBloc),
              BlocProvider(create: (context) => dataBloc),
              BlocProvider(create: (context) => BillsBloc()),
              BlocProvider(create: (context) => BudgetBloc()),
              BlocProvider(create: (context) => SubscriptionsBloc()),
              BlocProvider(create: (context) => ArticlesBloc()),
              BlocProvider(create: (context) => incomeBloc),
              BlocProvider(create: (context) => expenseBloc),
              BlocProvider(create: (context) => profileImageBloc),
              BlocProvider(create: (context) => AdsBloc()),
              BlocProvider(create: (context) => BanksBloc()),
              BlocProvider(create: (context) => FaqsBloc()),
              BlocProvider(create: (context) => ChatBloc()),
              BlocProvider(create: (context) => MemberShipBloc()),
              BlocProvider(create: (context) => TuitorialBloc()),
              BlocProvider(create: (context) => walletDetailsBloc),
              BlocProvider(create: (context) => newAnalyticBloc),
              BlocProvider(create: (context) => PlannedPaymentBloc()),
              BlocProvider(create: (context) => SearchBankBloc()),
              BlocProvider(create: (context) => GoalsBloc()),
              BlocProvider(create: (context) => UserBudgetBloc()),
              BlocProvider(create: (context) => NotificationsBloc()),
              BlocProvider(create: (context) => TransactionsAnalyticsBloc()),
              BlocProvider(create: (context) => TrendsBloc()),
              BlocProvider(create: (context) => TopTransactionsBloc()),
              BlocProvider(create: (context) => GroupedTransactionsBloc())
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Fedha App',
              theme: lightTheme,
              themeMode: ThemeMode.light,
              routerDelegate: router.routerDelegate,
              routeInformationParser: router.routeInformationParser,
              routeInformationProvider: router.routeInformationProvider,
              builder: EasyLoading.init(),
            ),
          ),
        );
      },
    );
  }
}
