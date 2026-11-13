import 'dart:convert';

import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/articles/articles.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/expense/expense.dart';
import 'package:fedha/data/models/income/income.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/authentication/banks.dart';
import 'package:fedha/features/authentication/forgot_password_screen.dart';
import 'package:fedha/features/authentication/login_screen.dart';
import 'package:fedha/features/authentication/otp_screen.dart';
import 'package:fedha/features/authentication/register_screen.dart';
import 'package:fedha/features/authentication/reset_otp.dart';
import 'package:fedha/features/authentication/reset_password_screen.dart';
import 'package:fedha/features/authentication/reset_success.dart';
import 'package:fedha/features/common_widgets/webview_pages.dart';

import 'package:fedha/features/dashboard/base_screen.dart';
import 'package:fedha/features/dashboard/components/analytics/analytics.dart';
import 'package:fedha/features/dashboard/components/analytics/transaction_analytics/transaction_categories_analytics.dart';
import 'package:fedha/features/dashboard/components/articles/articles.dart';
import 'package:fedha/features/dashboard/components/articles/articles_details.dart';
import 'package:fedha/features/dashboard/components/bills/bill_calender.dart';
import 'package:fedha/features/dashboard/components/bills/bills.dart';
import 'package:fedha/features/dashboard/components/bills/edit_bill.dart';
import 'package:fedha/features/dashboard/components/bills/new_bill.dart';
import 'package:fedha/features/dashboard/components/budgets/budget.dart';
import 'package:fedha/features/dashboard/components/budgets/new_budget.dart';
import 'package:fedha/features/dashboard/components/calculator/compound_interest_calculator.dart';
import 'package:fedha/features/dashboard/components/categories/categories.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/category_expenses.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/category_income.dart';
import 'package:fedha/features/dashboard/components/home/home.dart';
import 'package:fedha/features/dashboard/components/membership/membership.dart';
import 'package:fedha/features/dashboard/components/membership/membership_success.dart';
import 'package:fedha/features/dashboard/components/notifications/notifications.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/planned_payment_detail_screen.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/planned_payments.dart';
import 'package:fedha/features/dashboard/components/planning/planning.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';

import 'package:fedha/features/dashboard/components/profile/components/bookmarked_articles.dart';
import 'package:fedha/features/dashboard/components/profile/components/chat_screen.dart';
import 'package:fedha/features/dashboard/components/profile/components/help_center.dart';
import 'package:fedha/features/dashboard/components/profile/components/profile_edit.dart';
import 'package:fedha/features/dashboard/components/profile/profile.dart';
import 'package:fedha/features/dashboard/components/search/search_banks.dart';
import 'package:fedha/features/dashboard/components/subscriptions/new_subscriptions.dart';
import 'package:fedha/features/dashboard/components/subscriptions/subscriptions.dart';
import 'package:fedha/features/dashboard/components/subscriptions/subscriptions_detail.dart';
import 'package:fedha/features/dashboard/components/transactions/transactions.dart';

import 'package:fedha/features/dashboard/test/test_page.dart';
import 'package:fedha/features/welcome_pages/welcome_page.dart';
import 'package:fedha/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen(
      (value) {
        notifyListeners();
      },
    );
  }
}

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

class Routes {
  //Test
  static const String test = 'test';
  //search bank
  static const String searchBank = 'search_bank';
  // Start
  static const String splash = 'splash';
  static const String welcome = 'welcome';

  // auth
  static const String register = 'register';
  static const String login = 'login';
  static const String otpVerify = 'otpVerify';
  static const String newPasswords = 'new_passwords';

  static const String banks = 'banks';

  static const String membership = 'membership';
  static const String membershipSuccess = 'membership_success';

  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String resetOtp = 'resetOtp';

  static const String resetSuccess = 'reset-success';

  // Dashboard
  static const String root = 'root';
  // root
  static const String home = 'home';
  static const String planning = 'planning';
  static const String budget = 'budget';
  static const String budgetDetail = 'budgetDetail';
  static const String goals = 'goals';
  static const String goalDetail = 'goalDetail';
  static const String plannedPaymentCategories = 'plannedPaymentCategories';
  static const String plannedPayments = 'plannedPayments';
  static const String plannedPaymentDetail = 'plannedPaymentDetails';
  static const String transactions = 'transactions';
  static const String categories = 'categories';
  static const String analytics = 'analytics';
  static const String transactionCategoryanalytics =
      'transactionCategoryanalytics';

  static const String profile = 'profile';

  // other
  static const String profileUpdate = 'profileUpdate';
  static const String bills = 'bills';
  static const String newBill = 'newBill';
  static const String editBill = 'editBill';
  static const String calendarBill = 'calendarBill';

  static const String budgets = 'budgets';
  static const String newBudget = 'newBudget';

  static const String subscriptions = 'subscriptions';
  static const String subscriptionDetail = 'subscriptionDetail';
  static const String newSubscription = 'newSubscription';

  static const String articles = 'articles';
  static const String articleDetail = 'articleDetail';
  static const String bookMarked = 'bookMarked';

  static const String notifications = 'notifications';
  static const String help = 'help';
  static const String chats = 'chats';

  static const String categoryExpenses = 'categoryExpenses';
  static const String categoryIncome = 'categoryIncome';
  static const String webpage = 'webpage';

  static const String calculator = 'calculator';
}

Future<String> _handleSuccessfulLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);

  String? pendingNavigation = prefs.getString('pendingNavigation');
  String? pendingNavigationDataString =
      prefs.getString('pendingNavigationData');

  if (pendingNavigation != null) {
    await prefs.remove('pendingNavigation');
    await prefs.remove('pendingNavigationData');

    // We'll handle the extra data in the router
    return pendingNavigation;
  } else {
    return Routes.home;
  }
}

final router = GoRouter(
    navigatorKey: rootNavigator,
    refreshListenable:
        GoRouterRefreshStream(AuthenticationRepository.instance.stream),
    redirect: (context, state) async {
      String loc = state.uri.toString();
      bool isAuthenticated = AuthenticationRepository.instance.status ==
          AuthenticationStatus.authenticated;

      if (isAuthenticated) {
        if (loc.contains("login") ||
            loc.contains("splash") ||
            loc.contains("register") ||
            loc.contains("otp")) {
          String route = await _handleSuccessfulLogin();
          return state.namedLocation(route);
        }
      } else if (!(loc.contains("login") ||
          loc.contains("splash") ||
          loc.contains("welcome"))) {
        return state.namedLocation(Routes.login);
      }
      return null;
    },
    initialLocation: '/splash',
    routes: [
      // GoRoute(
      //   path: '/test',
      //   name: Routes.test,
      //   builder: (context, state) {
      //     return TestPage(key: state.pageKey);
      //   },
      // ),
      GoRoute(
        path: '/splash',
        name: Routes.splash,
        builder: (context, state) {
          return SplashScreen(key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/welcome',
        name: Routes.welcome,
        builder: (context, state) {
          return WelcomePage(key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/calculator',
        name: Routes.calculator,
        builder: (context, state) {
          return CompoundInterestCalc(key: state.pageKey);
        },
      ),
      GoRoute(
        path: '/login',
        name: Routes.login,
        builder: (context, state) => LoginScreen(key: state.pageKey),
        routes: [
          GoRoute(
            path: 'register',
            name: Routes.register,
            builder: (context, state) => RegisterScreen(key: state.pageKey),
          ),
          GoRoute(
            path: 'otpVerify',
            name: Routes.otpVerify,
            builder: (context, state) => OTPScreen(key: state.pageKey),
          ),
          GoRoute(
            path: 'banks',
            name: Routes.banks,
            builder: (context, state) => Banks(key: state.pageKey),
          ),
          GoRoute(
            path: 'forgot-password',
            name: Routes.forgotPassword,
            builder: (context, state) =>
                ForgotPasswordScreen(key: state.pageKey),
          ),
          GoRoute(
            path: 'resetOtp',
            name: Routes.resetOtp,
            builder: (context, state) => ResetOTPScreen(
                key: state.pageKey, email: state.extra as String),
          ),
          GoRoute(
            path: Routes.newPasswords,
            name: Routes.newPasswords,
            builder: (context, state) => ResetPasswordScreen(
                key: state.pageKey, email: state.extra as String),
          ),
          GoRoute(
            path: 'reset-password',
            name: Routes.resetPassword,
            builder: (context, state) => ResetPasswordScreen(
                key: state.pageKey, email: state.extra as String),
          ),
          GoRoute(
            path: 'reset-success',
            name: Routes.resetSuccess,
            builder: (context, state) => ResetSuccess(key: state.pageKey),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        // navigatorKey: _shellNavigator,
        builder: (context, state, navigationShell) {
          int index = navigationShell.currentIndex;

          debugPrint(index.toString());
          return BaseScreen(
              key: state.pageKey, navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              name: Routes.home,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final startTutorial = extra?['startTutorial'] as bool? ?? false;
                return NoTransitionPage(
                  child: HomeScreen(
                    startTutorial: startTutorial,
                    key: state.pageKey,
                  ),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/planning',
                name: Routes.planning,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: PlanningScreen(
                      key: state.pageKey,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'budget',
                    parentNavigatorKey: rootNavigator,
                    name: Routes.budget,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: BudgetScreen(
                          key: state.pageKey,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'details',
                        parentNavigatorKey: rootNavigator,
                        name: Routes.budgetDetail,
                        pageBuilder: (context, state) {
                          return NoTransitionPage(
                            child: BudgetDetailScreen(
                              key: state.pageKey,
                              budget: state.extra as UserBudget,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'goals',
                    parentNavigatorKey: rootNavigator,
                    name: Routes.goals,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: GoalsScreen(
                          key: state.pageKey,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'details',
                        parentNavigatorKey: rootNavigator,
                        name: Routes.goalDetail,
                        pageBuilder: (context, state) {
                          return NoTransitionPage(
                            child: GoalDetailScreen(
                              key: state.pageKey,
                              goal: state.extra as Goals,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'plannedPaymentCategories',
                    parentNavigatorKey: rootNavigator,
                    name: Routes.plannedPaymentCategories,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: PlannedPaymentCategoryScreen(
                          key: state.pageKey,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                      path: 'plannedPayments',
                      parentNavigatorKey: rootNavigator,
                      name: Routes.plannedPayments,
                      pageBuilder: (context, state) {
                        return const NoTransitionPage(
                          child: PlannedPayments(),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'details',
                          parentNavigatorKey: rootNavigator,
                          name: Routes.plannedPaymentDetail,
                          pageBuilder: (context, state) {
                            return NoTransitionPage(
                              child: PlannedPaymentDetailScreen(
                                key: state.pageKey,
                                plannedPayment: state.extra as PlannedPayment,
                                category:
                                    state.uri.queryParameters["category"]!,
                              ),
                            );
                          },
                        ),
                      ]),
                ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/budgets',
              name: Routes.budgets,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: BudgetTrackerScreen(
                    key: state.pageKey,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/category_expenses',
              name: Routes.categoryExpenses,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: CategoryExpenses(
                    key: state.pageKey,
                    category: state.extra as ExpenseCategory,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/category_income',
              name: Routes.categoryIncome,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: CategoryIncome(
                    key: state.pageKey,
                    category: state.extra as IncomeCategory,
                  ),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/analytics',
                name: Routes.analytics,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    child: AnalyticsScreen(
                      key: state.pageKey,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'transaction-analytics',
                    name: Routes.transactionCategoryanalytics,
                    pageBuilder: (context, state) {
                      // Retrieve query parameters
                      final type =
                          state.uri.queryParameters['type'] ?? 'expense';
                      final title = state.uri.queryParameters['title'] ??
                          'Monthly Report';
                      final period =
                          state.uri.queryParameters['period'] ?? "this_month";
                      final startDate = state.uri.queryParameters['startDate'];
                      final endDate = state.uri.queryParameters['endDate'];

                      Period? dateRange;
                      if (startDate != null && endDate != null) {
                        dateRange = Period(
                          start: DateTime.parse(startDate),
                          end: DateTime.parse(endDate),
                        );
                      }

                      return MaterialPage(
                        key: state.pageKey,
                        child: TransactionCategoryAnalytics(
                          title: title,
                          type: type,
                          period: period,
                          dateRange: dateRange,
                        ),
                      );
                    },
                  ),
                ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              name: Routes.profile,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: ProfileScreen(
                    key: state.pageKey,
                  ),
                );
              },
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/articles',
        name: Routes.articles,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: Articles(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/article_detail',
        name: Routes.articleDetail,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: ArticleDetail(
              key: state.pageKey,
              article: state.extra as Article,
            ),
          );
        },
      ),
      GoRoute(
        path: '/membership',
        name: Routes.membership,
        builder: (context, state) => MemberShip(key: state.pageKey),
      ),
      GoRoute(
        path: '/membership_success',
        name: Routes.membershipSuccess,
        builder: (context, state) => MemberShipSuccess(key: state.pageKey),
      ),
      GoRoute(
        path: '/bookmarked_articles',
        name: Routes.bookMarked,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: BookmarkedArticles(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/transactions',
        name: Routes.transactions,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: TransactionsScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/bills',
        name: Routes.bills,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: BillTrackerScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/new_bill',
        name: Routes.newBill,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: NewBillScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/edit_bill',
        name: Routes.editBill,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: EditBillScreen(
              bill: state.extra as Bill,
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/calendar_bill',
        name: Routes.calendarBill,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: BillCalendarScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/categories',
        name: Routes.categories,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: CategoriesScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/new_budget',
        name: Routes.newBudget,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: NewBudgetScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/subscriptions',
        name: Routes.subscriptions,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: SubscriptionsScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/subscription_detail',
        name: Routes.subscriptionDetail,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: SubscriptionDetail(
              key: state.pageKey,
              subscription: state.extra as Subscription,
            ),
          );
        },
      ),
      GoRoute(
        path: '/new_subscription',
        name: Routes.newSubscription,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: NewSubscriptionScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/profile_update',
        name: Routes.profileUpdate,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: ProfileUpdate(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        name: Routes.notifications,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: NotificationsScreen(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/help',
        name: Routes.help,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: HelpCenter(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/chats',
        name: Routes.chats,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: ChatDetail(
              key: state.pageKey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/webpage',
        name: Routes.webpage,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child:
                WebPageWidget(key: state.pageKey, route: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: '/search_bank',
        name: Routes.searchBank,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: SearchBanks(key: state.pageKey),
          );
        },
      )
    ],

    // refreshListenable: notifier,
    errorBuilder: (context, state) => Scaffold(
          body: Center(child: Text(state.error.toString())),
        ));
