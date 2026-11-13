import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:fedha/constants/constants.dart';
import 'package:fedha/data/error/error_handler.dart';
import 'package:fedha/data/error/failure.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/rate_limit_interceptor.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/data/sync/wallet_id_remap.dart';

import 'package:fedha/data/models/ads/ads.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/analytics/financial_wallet.dart';
import 'package:fedha/data/models/analytics/top_transactions.dart';
import 'package:fedha/data/models/analytics/trend_analysis.dart';
import 'package:fedha/data/models/articles/articles.dart';
import 'package:fedha/data/models/auth/Delete/delete_account_request.dart';
import 'package:fedha/data/models/auth/login/login_request.dart';
import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:fedha/data/models/auth/otp/otp_request_response.dart';
import 'package:fedha/data/models/auth/otp/otp_verify_request.dart';
import 'package:fedha/data/models/auth/otp/otp_verify_response.dart';
import 'package:fedha/data/models/auth/password.dart';
import 'package:fedha/data/models/auth/register/register_request.dart';
import 'package:fedha/data/models/auth/register/register_response.dart';
import 'package:fedha/data/models/auth/social_sign_in.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/models/bills/bill_types.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/budgets/budget.dart';
import 'package:fedha/data/models/categories/categories.dart';
import 'package:fedha/data/models/chats/chat.dart';
import 'package:fedha/data/models/faqs/faqs.dart';
import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/data/models/graphs/chart_data.dart';
import 'package:fedha/data/models/membership/membership.dart';
import 'package:fedha/data/models/multiple_result/multiple_result.dart';
import 'package:fedha/data/models/notifications/notifications.dart';

import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/planned_payment/planned_payment_request.dart';

// import 'package:fedha/data/models/payment_histories/payment_histories.dart';
import 'package:fedha/data/models/planned_payments/planned_payments.dart';
import 'package:fedha/data/models/profile/changepassword.dart';
import 'package:fedha/data/models/profile/profile_update_data.dart';
import 'package:fedha/data/models/subscriptions/subscriptions.dart';
import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/models/wallet/wallet_detail/wallet_details.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/localization/profile_image_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import "package:fedha/data/models/categories/categories.dart" as category_;
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

part 'http_client.dart';
part 'client.dart';

GetIt service = GetIt.asNewInstance();

final Logger logger = Logger('Client Service');

void _registerLazyIfAbsent<T extends Object>(T Function() factory) {
  if (!service.isRegistered<T>()) {
    service.registerLazySingleton<T>(factory);
  }
}

/// Safe to call more than once (main + background isolates / re-init).
setUpService() {
  _registerLazyIfAbsent<AuthService>(() => AuthService());
  _registerLazyIfAbsent<ProfileService>(() => ProfileService());
  _registerLazyIfAbsent<GoogleAuthService>(() => GoogleAuthService());
  _registerLazyIfAbsent<TransactionsService>(() => TransactionsService());
  _registerLazyIfAbsent<IncomeService>(() => IncomeService());
  _registerLazyIfAbsent<ExpenseService>(() => ExpenseService());

  _registerLazyIfAbsent<AppPreferences>(() => AppPreferences());
  _registerLazyIfAbsent<LocalDataCache>(() => LocalDataCache());
  _registerLazyIfAbsent<SyncEngine>(() => SyncEngine());
  _registerLazyIfAbsent<GraphsService>(() => GraphsService());
  _registerLazyIfAbsent<WalletService>(() => WalletService());
  _registerLazyIfAbsent<AnalyticsService>(() => AnalyticsService());
  _registerLazyIfAbsent<BillService>(() => BillService());
  _registerLazyIfAbsent<BudgetService>(() => BudgetService());

  _registerLazyIfAbsent<SubscriptionService>(() => SubscriptionService());
  _registerLazyIfAbsent<ArticleService>(() => ArticleService());
  _registerLazyIfAbsent<ProfileImagePickerService>(
      () => ProfileImagePickerService());
  _registerLazyIfAbsent<NotificationsService>(() => NotificationsService());
  _registerLazyIfAbsent<AdsService>(() => AdsService());
  _registerLazyIfAbsent<BanksService>(() => BanksService());
  _registerLazyIfAbsent<ChatService>(() => ChatService());

  _registerLazyIfAbsent<MembershipService>(() => MembershipService());

  _registerLazyIfAbsent<PlannedPaymentService>(() => PlannedPaymentService());
  _registerLazyIfAbsent<PlanningService>(() => PlanningService());
}

enum ServiceStatus {
  initial,
  // Receiveng data from server
  loading,
  loadingSuccess,
  loadingFailure,
  // Sending data to server
  submissionInProgress,
  submissionFailure,
  submissionSuccess,
}
