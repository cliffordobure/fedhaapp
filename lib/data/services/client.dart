part of 'service.dart';

class AuthService {
  HttpResult<LoginResponse> login(LoginRequest request) async {
    return Http.post(
      "login",
      request.toJson(),
      deserializer: (data) => LoginResponse.fromJson(data),
    );
  }

  // register user
  HttpResult<RegisterResponse> register(RegisterRequest request) async {
    return Http.post(
      "register",
      request.toJson(),
      deserializer: (data) => RegisterResponse.fromJson(data),
    );
  }

// delete account
  HttpResult<String> deleteAccount(DeleteAccountRequest request) async {
    return Http.delete(
      "delete-account",
      data: request.toJson(),
      deserializer: (data) => data["message"],
    );
  }

// reset otp
  HttpResult<OtpVerifyResponse> resetVerifyOTP(EmailOtpRequest request) =>
      Http.post("password/verify/otp", request.toJson(),
          deserializer: (json) => OtpVerifyResponse.fromJson(json));

  HttpResult<OtpVerifyResponse> verifyOTP(EmailOtpRequest request) =>
      Http.post("password/verify/otp", request.toJson(),
          deserializer: (json) => OtpVerifyResponse.fromJson(json));

  HttpResult<String> newPassword(PasswordResetRequest request) =>
      Http.post("password/reset", request.toJson(),
          deserializer: (json) => json["message"]);

  /// Registration / account activation OTP (not password-reset).
  HttpResult<OtpVerifyResponse> verifyEmailOTP(EmailOtpRequest request) =>
      Http.post(
          "user/verify/otp", {"email": request.email, "otp": request.otp},
          deserializer: (json) => OtpVerifyResponse.fromJson(json));

  HttpResult<OtpRequestResponse> requestOTP(String request) =>
      Http.post("resend/otp", {"phone_number": request},
          deserializer: (json) => OtpRequestResponse.fromJson(json));

  HttpResult<String> changePassword(Changepassword request) async {
    return Http.post(
      "password/change-password",
      request.toJson(),
      deserializer: (data) => data["message"],
    ); //change
  }

  HttpResult<String> forgotPassword(String request) =>
      Http.post("password/forgot-password", {"email": request},
          deserializer: (json) => json["message"]);
}

// banks
class BanksService {
  HttpResult<List<Bank>> fetchBanks() async {
    return Http.get(
      "banks/category",
      deserializer: (json) =>
          List<Bank>.from(json["banks"].map((e) => Bank.fromJson(e))),
    );
  }

  HttpResult<List<Currency>> fetchCurrencies() async {
    return Http.get(
      "banks/currencies",
      deserializer: (json) =>
          List<Currency>.from(json["data"].map((e) => Currency.fromJson(e))),
    );
  }

  // saveWallets
  HttpResult<String> saveWallets(List<int> banks) async {
    return Http.post(
      "user/wallet/add",
      {
        // Backend validates a required `wallets` array of bank ids.
        "wallets": banks,
      },
      deserializer: (json) => json["message"],
    );
  }
}

// Fetch user profile
class ProfileService {
  // fetch user data
  HttpResult<User> fetchProfile() => Http.get(
        "profile/information",
        deserializer: (json) => User.fromJson(json["data"]),
      );

// Update user data
  HttpResult<String> updateProfile(ProfileUpdateData request) async {
    return Http.post(
      "profile/update",
      request.toJson(),
      // options: Options(
      //   headers: {
      //     Headers.contentTypeHeader: "multipart/form-data",
      //   },
      // ),
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<List<FaQ>> fetchFaqs() => Http.get(
        "organization/faqs",
        deserializer: (json) =>
            List<FaQ>.from(json.map((e) => FaQ.fromJson(e))),
      );
}

class ChatService {
  HttpResult<List<Chat>> chat() => Http.get(
        "user/chats",
        deserializer: (data) =>
            List<Chat>.from(data.map((e) => Chat.fromJson(e)).toList()),
      );

  HttpResult<String> send({
    required String message,
  }) async {
    return Http.post(
      "user/chat/new",
      {"message": message},
      deserializer: (json) => json["message"],
    );
  }
}

// google sign in
class GoogleAuthService {
  Future<firebaseAuth.User?> signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    logger.info(gUser?.email);
    // Obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // Create a new credentials for use
    final credential = firebaseAuth.GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in the user
    firebaseAuth.UserCredential userCredential = await firebaseAuth
        .FirebaseAuth.instance
        .signInWithCredential(credential);
    logger.info(userCredential.user?.displayName);

    return userCredential.user;
  }

  Future<bool> signInOutGoogle() async {
    await GoogleSignIn().signOut();

    return true;
  }

  // Sync info with the server
  HttpResult<LoginResponse> registerWithGoogleDetails(
      SocialSignInRequest request) async {
    return Http.post(
      "login/via/${request.email}",
      {},
      deserializer: (json) => LoginResponse.fromJson(json),
    );
  }
}

// dashbord
class TransactionsService {
  HttpResult<TransactionResponse> fetchTransactions({int? page}) async {
    return Http.get(
      "mono/transactions${page != null ? '?page=$page' : ''}",
      deserializer: (json) => TransactionResponse.fromJson(json),
    );
  }

  HttpResult<GroupedTransactionsData> fetchGroupedTransactions({
    int? days,
    int? perPage,
    int? page,
  }) async {
    final queryParams = {
      if (days != null) 'days': days.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
      if (page != null) 'page': page.toString(),
    };

    final queryString = Uri(queryParameters: queryParams).query;

    return Http.get(
      "transactions/grouped?$queryString",
      deserializer: (json) => GroupedTransactionsData.fromJson(json['data']),
    );
  }

  HttpResult<String> saveTransaction(TransactionData data) async {
    final wallets =
        await service<LocalDataCache>().loadWallets() ?? const <Wallet>[];
    return Http.post(
      "transaction/create",
      transactionDataToApiJson(data, liveWallets: wallets),
      deserializer: (data) => data["message"],
    );
  }

  HttpResult<String> saveMultipleTransactions(
      List<TransactionData> data) async {
    final wallets =
        await service<LocalDataCache>().loadWallets() ?? const <Wallet>[];
    return Http.post(
      "transaction/multiple-create",
      {
        "transactions": data
            .map(
              (e) => transactionDataToApiJson(e, liveWallets: wallets),
            )
            .toList(),
      },
      deserializer: (data) => data["message"],
    );
  }

  HttpResult<String> updateCategory(
      int categoryId, int? subcategoryId, transactionId) async {
    return Http.put(
      "transaction/update/$transactionId",
      {"category_id": categoryId, "subcategory_id": subcategoryId},
      deserializer: (data) => data["message"],
    );
  }

  HttpResult<String> updateTransaction(
      int transactionId, String? narration, double? amount) async {
    return Http.put(
      "transaction/$transactionId",
      {"narration": narration, "amount": amount},
      deserializer: (data) => data["message"] ?? "Transaction updated",
    );
  }

  HttpResult<String> deleteTransaction(int transactionId) async {
    // Matches other resource deletes (wallet/bill/budget) and
    // transaction/update/{id} naming on this API.
    return Http.delete(
      "transaction/delete/$transactionId",
      deserializer: (data) => data["message"] ?? "Transaction deleted",
    );
  }

  /// Deletes every cloud transaction for the signed-in user.
  HttpResult<String> resetAllTransactions() async {
    return Http.delete(
      "transactions/reset",
      deserializer: (data) =>
          data["message"] ?? "All transactions deleted",
    );
  }
}

// Ads
class AdsService {
  HttpResult<List<Ads>> fetchAds() async {
    return Http.get(
      "get/ads",
      deserializer: (json) =>
          List<Ads>.from(json["data"].map((e) => Ads.fromJson(e))),
    );
  }
}

// Income
class IncomeService {
  // HttpResult<List<IncomeCategory>> fetchIncome({int? page}) async {
  //   return Http.get(
  //     "finance/income/user/list",
  //     deserializer: (json) => List<IncomeCategory>.from(
  //         json["data"].map((e) => IncomeCategory.fromJson(e))),
  //   );
  // }

  HttpResult<CategoryResponse> fetchIncome({int? page}) async {
    return Http.get(
      "incomes/categories/list",
      deserializer: (json) => CategoryResponse.fromJson(json),
    );
  }

  // income
  HttpResult<List<category_.Category>> fetchIncomeType() async {
    return Http.get(
      "incomes/categories/list",
      deserializer: (json) => List<category_.Category>.from(
          json["data"].map((e) => category_.Category.fromJson(e))),
    );
  }

  HttpResult<category_.Category> fetchSpecificIncome(int id) async {
    return Http.get(
      "income/category/show/$id",
      deserializer: (json) => category_.Category.fromJson(json["data"]),
    );
  }

  HttpResult<String> deleteIncomeSubcategory(int id) async {
    return Http.delete(
      "subcategory/delete/$id",
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> updateIncomeSubcategory(int id, FormData data) async {
    return Http.put(
      "income/subcategory/update/$id",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> saveIncomeSubcategory(FormData data) async {
    return Http.post(
      "income/subcategory/create",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> saveIncomeType(Map<String, dynamic> data) async {
    return Http.post(
      "finance/income/category/add",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> categorizeIncome(String transaction, int category) async {
    return Http.put(
      "transaction/update/$transaction",
      {"category_id": category},
      deserializer: (json) => json["message"],
    );
  }
}

// MARK: expense
class ExpenseService {
  HttpResult<CategoryResponse> fetchExpense() async {
    return Http.get(
      "finance/expense/categories/user/list",
      deserializer: (json) => CategoryResponse.fromJson(json),
    );
  }

  // HttpResult<List<ExpenseCategory>> fetchExpense() async {
  //   return Http.get(
  //     "finance/expense/categories/user/list",
  //     deserializer: (json) => List<ExpenseCategory>.from(
  //         json["data"].map((e) => ExpenseCategory.fromJson(e))),
  //   );
  // }

  // get specific category
  HttpResult<category_.Category> getSpecificCategory(int id) async {
    return Http.get("expense/category/show/$id",
        deserializer: (json) => category_.Category.fromJson(json["data"]));
  }

  HttpResult<String> createEspenseTypes(String category) async {
    return Http.post(
      "/finance/expense/category/add",
      {"name": category},
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<CategoryResponse> fetchExpenseTypes() async {
    return Http.get("expenses/categories/list",
        deserializer: (json) => CategoryResponse.fromJson(json));
  }

  HttpResult<String> saveExpenseSubcategory(FormData data) async {
    return Http.post(
      "expense/subcategory/create",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> deleteExpenseSubcategory(int id) async {
    return Http.delete(
      "subcategory/delete/$id",
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> updateExpenseSubcategory(int id, FormData data) async {
    return Http.put(
      "expense/subcategory/update/$id",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> saveExpenseCategory(Map<String, dynamic> data) async {
    return Http.post(
      "finance/expense/category/add",
      data,
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<String> categorizeExpense(String transaction, int category) async {
    return Http.put(
      "transaction/update/$transaction",
      {"category_id": category},
      deserializer: (json) => json["message"],
    );
  }

  // saveNewExpenseType
  HttpResult<String> saveNewExpenseType(Map<String, dynamic> data) async {
    return Http.post(
      "expense/category/add",
      data,
      deserializer: (json) => json["message"],
    );
  }
}

// graphs
class GraphsService {
  HttpResult<ChartResponse> fetchWeeklyGraphData() async {
    return Http.get(
      "finance/income-expense/graph/weekly",
      deserializer: (json) => ChartResponse.fromJson(json),
    );
  }

  HttpResult<ChartResponse> fetchMonthlyGraphData() async {
    return Http.get("finance/income-expense/graph/monthly",
        deserializer: (json) => ChartResponse.fromJson(json));
  }

  HttpResult<ChartResponse> fetchCustomGraphData(
      String startDate, String endDate) async {
    return Http.post(
      "finance/income-expense/graph/custom",
      {
        {"startDate": startDate, "endDate": endDate}
      },
      deserializer: (json) => ChartResponse.fromJson(json),
    );
  }
}

// graphs
class WalletService {
  HttpResult<List<Wallet>> fetchWallets() async {
    return Http.get(
      "user/wallet",
      deserializer: (json) => List<Wallet>.from(
        json["data"].map(
          (e) => Wallet.fromJson(e),
        ),
      ),
    );
  }

  HttpResult<WalletDetailData> fetchWalletDetails(int walletId) async {
    return Http.get(
      "user/wallet/$walletId",
      deserializer: (json) => WalletDetailData.fromJson(json["data"]),
    );
  }

  HttpResult<TransactionDetails> fetchMoreTransactions(
    int walletId,
    int nextPage,
  ) async {
    return Http.get(
      "user/wallet/$walletId?page=$nextPage",
      deserializer: (json) =>
          TransactionDetails.fromJson(json["data"]["transactions"]),
    );
  }

  HttpResult<String> updateWallet(
      int walletId, Map<String, dynamic> data) async {
    return Http.put("user/wallet/update/$walletId", data,
        deserializer: (json) => json["message"]);
  }

  HttpResult<String> deleteWallet({required int walletId}) async {
    return Http.delete("user/wallet/delete/$walletId",
        deserializer: (resp) => resp["message"]);
  }

  // Save manual wallet
  HttpResult<String> saveWallet(Map<String, dynamic> data) async {
    return Http.post("user/wallet/create", data,
        deserializer: (json) => json["message"]);
  }

  // exchnage tokens
  HttpResult<Map<String, dynamic>> exchangeToken({required String code}) async {
    return Http.post(
      "mono/transactions/syn",
      {"code": code},
      deserializer: (json) => json,
    );
  }
}

//MARK: analytics
class AnalyticsService {
  // OLD
  HttpResult<FinancialData> fetchData() async {
    return Http.get("income-expense/analysis", deserializer: (json) {
      return FinancialData.fromJson(json["data"]);
    });
  }

  /// Backend `analysis/transaction-trend` is not deployed (always 404).
  /// Build trends from working graph APIs and/or the user's transactions.
  HttpResult<TrendAnalysisResponse> fetchTransactionsTrends({
    String period = 'this_year',
    int? walletId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Prefer transaction-built series so wallet + "All" charts show real data.
      final txs = await _loadAnalyticsTransactions();
      if (txs.isNotEmpty || walletId != null || period == 'custom') {
        final data = _trendsFromTransactions(
          txs,
          period,
          walletId: walletId,
          startDate: startDate,
          endDate: endDate,
        );
        return MultipleResult.onSuccess(
          data: TrendAnalysisResponse(
            status: 200,
            success: true,
            message: 'Trends from transactions',
            data: data,
            period: period,
          ),
        );
      }

      final graphs = GraphsService();
      final useWeekly = period == 'this_week' || period == 'weekly';
      final graphRes = useWeekly
          ? await graphs.fetchWeeklyGraphData()
          : await graphs.fetchMonthlyGraphData();

      return graphRes.when(
        onError: (error) => MultipleResult.onError(error: error),
        onSuccess: (chart) {
          final isYear = period == 'this_year';
          final data = chart.data
              .map(
                (c) => TrendData(
                  week: isYear ? null : c.label,
                  month: isYear ? c.label : null,
                  income: c.income.toString(),
                  expense: c.expense.toString(),
                  net: (c.income - c.expense).toString(),
                ),
              )
              .toList();
          return MultipleResult.onSuccess(
            data: TrendAnalysisResponse(
              status: 200,
              success: true,
              message: chart.dateRange,
              data: data,
              period: period,
            ),
          );
        },
      );
    } catch (e) {
      return MultipleResult.onError(
        error: Failure(error: 'Could not load trends'),
      );
    }
  }

  /// Backend `analysis/top-transactions` is not deployed (always 404).
  /// Rank incomes/expenses from the user's transaction list instead.
  HttpResult<TopTransactionsResponse> fetchTopTransactions({
    String period = 'this_month',
    int limit = 3,
    int? walletId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final txs = await _loadAnalyticsTransactions();
      final range = _analyticsPeriodRange(
        period,
        startDate: startDate,
        endDate: endDate,
      );
      final filtered = txs.where((t) {
        if (walletId != null && t.walletId != walletId) return false;
        if (narrationIsInternalTransfer(t.narration)) return false;
        final date = t.date ?? t.createdAt;
        if (date == null) return true;
        return !date.isBefore(range.start) && !date.isAfter(range.end);
      }).toList();

      final incomes = filtered
          .where((t) => t.type == TransactionType.credit)
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));
      final expenses = filtered
          .where((t) => t.type == TransactionType.debit)
          .toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      return MultipleResult.onSuccess(
        data: TopTransactionsResponse(
          status: 200,
          success: true,
          message: 'Top transactions from local/server data',
          data: Data(
            topIncomes: incomes.take(limit).toList(),
            topExpenses: expenses.take(limit).toList(),
          ),
          period: Period(
            periodType: period,
            start: range.start,
            end: range.end,
          ),
        ),
      );
    } catch (e) {
      return MultipleResult.onError(
        error: Failure(error: 'Could not load top transactions'),
      );
    }
  }

  Future<List<Transaction>> _loadAnalyticsTransactions() async {
    final cache = service<LocalDataCache>();
    final cached = await cache.loadTransactions();
    var txs = List<Transaction>.from(cached?.transactions ?? const []);

    final remote = await TransactionsService().fetchTransactions();
    remote.when(
      onError: (_) {},
      onSuccess: (response) {
        final byCode = <String, Transaction>{
          for (final t in txs)
            if (t.transactionId.isNotEmpty) t.transactionId: t,
        };
        for (final t in response.data) {
          if (t.transactionId.isNotEmpty) byCode[t.transactionId] = t;
        }
        txs = byCode.values.toList();
      },
    );
    return txs;
  }

  ({DateTime start, DateTime end}) _analyticsPeriodRange(
    String period, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (startDate != null && endDate != null) {
      return (
        start: DateTime(startDate.year, startDate.month, startDate.day),
        end: DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
      );
    }
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    switch (period) {
      case 'this_day':
      case 'today':
      case 'daily':
        return (
          start: DateTime(now.year, now.month, now.day),
          end: end,
        );
      case 'this_week':
      case 'weekly':
        final start = now.subtract(Duration(days: now.weekday - 1));
        return (
          start: DateTime(start.year, start.month, start.day),
          end: end,
        );
      case 'this_year':
        return (start: DateTime(now.year, 1, 1), end: end);
      case 'custom':
        if (startDate != null && endDate != null) {
          return (
            start: DateTime(startDate.year, startDate.month, startDate.day),
            end: DateTime(
                endDate.year, endDate.month, endDate.day, 23, 59, 59),
          );
        }
        return (start: DateTime(now.year, now.month, 1), end: end);
      case 'this_month':
      default:
        return (start: DateTime(now.year, now.month, 1), end: end);
    }
  }

  List<TrendData> _trendsFromTransactions(
    List<Transaction> transactions,
    String period, {
    int? walletId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final range = _analyticsPeriodRange(
      period,
      startDate: startDate,
      endDate: endDate,
    );
    final useMonthly = period == 'this_year' ||
        (period == 'custom' && range.end.difference(range.start).inDays > 60);

    final filtered = transactions.where((t) {
      if (walletId != null && t.walletId != walletId) return false;
      if (narrationIsInternalTransfer(t.narration)) return false;
      final date = t.date ?? t.createdAt;
      if (date == null) return false;
      return !date.isBefore(range.start) && !date.isAfter(range.end);
    });

    final buckets = <String, ({double income, double expense})>{};
    // Pre-fill axis points so the chart always has a visible series.
    final keys = useMonthly
        ? const [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ]
        : const ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'];
    for (final key in keys) {
      buckets[key] = (income: 0.0, expense: 0.0);
    }

    for (final t in filtered) {
      final date = t.date ?? t.createdAt ?? range.start;
      final key = useMonthly
          ? DateFormat('MMM').format(date)
          : 'Week ${((date.day - 1) ~/ 7) + 1}';
      final current = buckets[key] ?? (income: 0.0, expense: 0.0);
      if (t.type == TransactionType.credit) {
        buckets[key] = (
          income: current.income + t.amount,
          expense: current.expense,
        );
      } else {
        buckets[key] = (
          income: current.income,
          expense: current.expense + t.amount + (t.charges ?? 0),
        );
      }
    }

    return keys.map((key) {
      final value = buckets[key] ?? (income: 0.0, expense: 0.0);
      final net = value.income - value.expense;
      return TrendData(
        week: useMonthly ? null : key,
        month: useMonthly ? key : null,
        income: value.income.toStringAsFixed(2),
        expense: value.expense.toStringAsFixed(2),
        net: net.toStringAsFixed(2),
      );
    }).toList();
  }

  HttpResult<TransactionAnalytics> getTransactionsAnalytics(
    String type,
    String period,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    // Prefer backend when available; fall back to local txs on 404 / failure.
    String queryParams = 'transactions-analytics?type=$type&period=$period';

    if (period == 'custom' && startDate != null && endDate != null) {
      queryParams +=
          '&start_date=${Uri.encodeComponent(startDate.toIso8601String())}'
          '&end_date=${Uri.encodeComponent(endDate.toIso8601String())}';
    }

    final remote = await Http.get(
      queryParams,
      deserializer: (json) => TransactionAnalytics.fromJson(json),
    );

    TransactionAnalytics? remoteData;
    Failure? remoteError;
    remote.when(
      onSuccess: (data) => remoteData = data,
      onError: (error) => remoteError = error,
    );
    if (remoteData != null) {
      return MultipleResult.onSuccess(data: remoteData!);
    }

    try {
      final local = await _transactionAnalyticsFromLocal(
        type: type,
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
      return MultipleResult.onSuccess(data: local);
    } catch (_) {
      return MultipleResult.onError(
        error: remoteError ??
            Failure(error: 'Could not load transaction analytics'),
      );
    }
  }

  Future<TransactionAnalytics> _transactionAnalyticsFromLocal({
    required String type,
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final txs = await _loadAnalyticsTransactions();
    final range = _analyticsPeriodRange(
      period,
      startDate: startDate,
      endDate: endDate,
    );
    final isIncome = type.toLowerCase() == 'income';
    final names = await _resolveCategoryNames(isIncome: isIncome);

    final filtered = txs.where((t) {
      if (narrationIsInternalTransfer(t.narration)) return false;
      if (isIncome && t.type != TransactionType.credit) return false;
      if (!isIncome && t.type != TransactionType.debit) return false;
      final date = t.date ?? t.createdAt;
      if (date == null) return true;
      return !date.isBefore(range.start) && !date.isAfter(range.end);
    }).toList();

    final grouped = <int, List<Transaction>>{};
    for (final t in filtered) {
      final id = t.categoryId ?? 0;
      (grouped[id] ??= []).add(t);
    }

    final topCategories = grouped.entries.map((entry) {
      final categoryId = entry.key;
      final list = entry.value
        ..sort((a, b) => b.amount.compareTo(a.amount));
      final total = list.fold<double>(
        0,
        (sum, t) =>
            sum + t.amount + (!isIncome ? (t.charges ?? 0) : 0),
      );
      return TopCategory(
        categoryId: categoryId,
        categoryName: names[categoryId] ??
            (categoryId == 0 ? 'Uncategorized' : 'Category $categoryId'),
        totalAmount: total.round(),
        transactions: list,
      );
    }).toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    final totalAmount = topCategories.fold<int>(
      0,
      (sum, c) => sum + c.totalAmount,
    );

    return TransactionAnalytics(
      message: 'Analytics from local transactions',
      data: AnalyticsData(
        totalAmount: totalAmount,
        topCategories: topCategories,
        period: Period(
          periodType: period,
          start: range.start,
          end: range.end,
        ),
      ),
    );
  }

  Future<Map<int, String>> _resolveCategoryNames({
    required bool isIncome,
  }) async {
    final names = <int, String>{0: 'Uncategorized'};
    try {
      if (isIncome) {
        final res = await IncomeService().fetchIncomeType();
        res.when(
          onError: (_) {},
          onSuccess: (list) {
            for (final c in list) {
              names[c.id] = c.name;
            }
          },
        );
      } else {
        final res = await ExpenseService().fetchExpenseTypes();
        res.when(
          onError: (_) {},
          onSuccess: (response) {
            for (final c in response.data) {
              names[c.id] = c.name;
            }
          },
        );
      }
    } catch (_) {}
    return names;
  }

  HttpResult<Map<String, dynamic>> fetchCardData() async {
    return Http.get("user/dashboard/home",
        deserializer: (json) => json["card_data"]);
  }

  HttpResult<List<FinancialWallet>> fetchAnalyticsData({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    String queryParameters = 'period=$period';

    if (period == 'custom' && startDate != null && endDate != null) {
      queryParameters +=
          '&start_date=${startDate.toIso8601String()}&end_date=${endDate.toIso8601String()}';
    }
    return Http.get('income-expense/analysis/home?$queryParameters',
        deserializer: (json) {
      return financialWalletsFromJson(json["wallets_data"]);
    });
  }
}

// Bill service
class BillService {
//   // Fetch user bills
  HttpResult<UserBill> fetchUserBills() async {
    try {
      final res = await Http.dio.get("bills/user/list");
      return MultipleResult.onSuccess(data: _parseUserBills(res.data));
    } on DioException catch (error) {
      return MultipleResult.onError(error: ErrorHandler(error).handle());
    } catch (e) {
      logger.info('bills/user/list parse failed: $e');
      return MultipleResult.onError(
          error: Failure(error: "Could not read your bills"));
    }
  }

  static num _num(dynamic v) {
    if (v is num) return v;
    return num.tryParse('${v ?? ''}'.replaceAll(',', '')) ?? 0;
  }

  static UserBill _parseUserBills(dynamic json) {
    final map = json is Map ? Map<String, dynamic>.from(json) : {};
    Map<String, dynamic> span(dynamic raw) {
      final s = raw is Map ? Map<String, dynamic>.from(raw) : {};
      final bills = (s['bills'] is List ? s['bills'] as List : const [])
          .whereType<Map>()
          .map((b) => {
                'id': _num(b['id']).toInt(),
                'name': '${b['name'] ?? 'Bill'}',
                'img': '${b['img'] ?? ''}',
                'wallet': '${b['wallet'] ?? ''}',
                'amount': _num(b['amount']).round(),
              })
          .toList();
      return {
        'total_amount': _num(s['total_amount']).toDouble(),
        'bills': bills,
      };
    }

    return UserBill.fromJson({
      'all_total_amount': _num(map['all_total_amount']).round(),
      'Weekly': span(map['Weekly']),
      'Monthly': span(map['Monthly']),
      'Annually': span(map['Annually']),
    });
  }

  HttpResult<List<BillType>> fetchBillTypes() async {
    return Http.get("bills/types", deserializer: (json) {
      final raw = json is Map ? json["bills_types"] : null;
      if (raw is! List) return <BillType>[];
      return raw.whereType<Map>().map((e) {
        return BillType(
          id: _num(e['id']).toInt(),
          name: '${e['name'] ?? ''}',
          status: _num(e['status']).toInt(),
          createdAt: '${e['created_at'] ?? ''}',
          updatedAt: '${e['updated_at'] ?? ''}',
        );
      }).toList();
    });
  }

  /// Returns the catalog `bills.id` for [name], creating it via
  /// `bills/category/add` or reusing `existing_bill` when it already exists.
  /// Throws [DioException] for any other failure.
  Future<int?> resolveBillId(String name) async {
    final res = await Http.dio.post(
      "bills/category/add",
      data: {'name': name},
      options: Options(
          validateStatus: (s) => s != null && (s < 300 || s == 400)),
    );
    final data = res.data;
    if (data is! Map) return null;
    final bill = data['bill'] ?? data['existing_bill'];
    if (bill is Map && bill['id'] != null) return _num(bill['id']).toInt();
    return null;
  }

  /// Creates a user bill. Returns `null` on success or the server message on
  /// a 422 (e.g. already exists). Throws [DioException] for other failures.
  Future<String?> createUserBill(Map<String, dynamic> data) async {
    final res = await Http.dio.post(
      "bills/user/add",
      data: data,
      options: Options(
          validateStatus: (s) => s != null && (s < 300 || s == 422)),
    );
    final code = res.statusCode ?? 0;
    if (code >= 200 && code < 300) return null;
    final body = res.data;
    final msg = body is Map ? '${body['message'] ?? body['error'] ?? ''}' : '';
    return msg.isEmpty ? 'HTTP $code' : msg;
  }

  /// Keeps locally created bills (negative temp ids) that the server
  /// doesn't have yet, so a refresh never hides an unsynced bill.
  static UserBill mergePendingBills(UserBill server, UserBill? local) {
    if (local == null) return server;
    BillSpan merge(BillSpan remote, BillSpan mine) {
      final names = remote.bills.map((b) => b.name.toLowerCase()).toSet();
      final pending = mine.bills
          .where((b) => b.id < 0 && !names.contains(b.name.toLowerCase()))
          .toList();
      if (pending.isEmpty) return remote;
      final extra = pending.fold<double>(0, (s, b) => s + b.amount);
      return BillSpan(
        totalAmount: remote.totalAmount + extra,
        bills: [...pending, ...remote.bills],
      );
    }

    final weekly = merge(server.weekly, local.weekly);
    final monthly = merge(server.monthly, local.monthly);
    final annually = merge(server.annually, local.annually);
    return UserBill(
      allTotalAmount:
          (weekly.totalAmount + monthly.totalAmount + annually.totalAmount)
              .round(),
      weekly: weekly,
      monthly: monthly,
      annually: annually,
    );
  }

  HttpResult<String> saveBill(Map<String, dynamic> data) async {
    return Http.post("bills/user/add", data,
        deserializer: (json) => json["message"]);
  }

  HttpResult<String> editBill(Map<String, dynamic> data, int id) async {
    return Http.put("user/bill/update/$id", data,
        deserializer: (json) => json["message"]);
  }

  HttpResult<String> deleteBill(int id) async {
    return Http.delete("user/bill/delete/$id",
        deserializer: (json) => json["message"]);
  }

  // Add new subscription type
  HttpResult<String> saveNewBillType(Map<String, dynamic> data) async {
    // TODO! Update to newly created andpoint for this
    return Http.post("bills/category/add", data,
        deserializer: (json) => json["message"]);
  }
}

// Budget service
class BudgetService {
  HttpResult<BudgetResponse> fetchUserBudgets() async {
    return Http.get("budget/user/list",
        deserializer: (json) => BudgetResponse.fromJson(json));
  }

  HttpResult<List<FormBudgetSpan>> fetchFormBudgetSpans() async {
    return Http.get("budget/types",
        deserializer: (json) => List.from(
            json["budget_types"].map((e) => FormBudgetSpan.fromJson(e))));
  }

  HttpResult<List<FormBudgetType>> fetchBudgets() async {
    return Http.get("budget/list",
        deserializer: (json) => List<FormBudgetType>.from(
            json["budgets"].map((e) => FormBudgetType.fromJson(e))));
  }

  HttpResult<String> saveBudget(Map<String, dynamic> data) async {
    return Http.post("budget/user/add", data,
        deserializer: (json) => json["message"]);
  }

  // Add new budget type
  HttpResult<String> saveNewBudgetType(Map<String, dynamic> data) async {
    // TODO! Update to newly created andpoint for this
    return Http.post("budget/category/add", data,
        deserializer: (json) => json["message"]);
  }
}

// TODO! Check this
class SubscriptionService {
//   // Fetch user bills
  HttpResult<UserSubscriptions> fetchUserSubscriptions() async {
    return Http.get("subscriptions/user/list",
        deserializer: (json) => UserSubscriptions.fromJson(json));
  }

  // Create bill
  HttpResult<List<FormSubscriptionSpans>> fetchSubscriptionsSpans() async {
    return Http.get("subscriptions/types",
        deserializer: (json) => List.from(json["subscriptions_types"]
            .map((e) => FormSubscriptionSpans.fromJson(e))));
  }

  HttpResult<List<FormSubscription>> fetchSubscriptions() async {
    return Http.get("subscriptions/list",
        deserializer: (json) => List<FormSubscription>.from(
            json["subscriptions"].map((e) => FormSubscription.fromJson(e))));
  }

  HttpResult<String> saveSubscription(Map<String, dynamic> data) async {
    return Http.post("subscriptions/user/add", data,
        deserializer: (json) => json["message"]);
  }

  HttpResult<String> cancelSubscription(int id) async {
    return Http.delete("subscriptions/delete/$id",
        deserializer: (json) => json["message"]);
  }

  // Add new subscription type
  HttpResult<String> saveNewSubscriptionType(Map<String, dynamic> data) async {
    // TODO! Update to newly created andpoint for this
    return Http.post("subscription/category/add", data,
        deserializer: (json) => json["message"]);
  }
}

// Articles service
class ArticleService {
  HttpResult<List<ArticleCategory>> fetchArticles() async {
    return Http.get(
      "finance/posts",
      deserializer: (json) => List<ArticleCategory>.from(
        json["data"].map(
          (e) => ArticleCategory.fromJson(e),
        ),
      ),
    );
  }

  HttpResult<List<Article>> fetchBookmarked() async {
    return Http.get(
      "bookmarked-articles",
      deserializer: (json) => List<Article>.from(
        json["data"].map(
          (e) => Article.fromJson(e),
        ),
      ),
    );
  }
}

// notifications
class NotificationsService {
  HttpResult<List<NotificationModel>> fetchNotifications() async {
    return Http.get(
      "app/notifications",
      deserializer: (json) => List<NotificationModel>.from(
        json["notifications"].map(
          (e) => NotificationModel.fromJson(e),
        ),
      ),
    );
  }

  HttpResult<String> readNotification(int id) async {
    return Http.put(
      "app/notifications/mark-as-read/$id",
      {},
      deserializer: (json) => json["message"],
    );
  }

  HttpResult<NotificationModel> deleteNotification(int id) async {
    return Http.delete(
      "app/notifications/delete/$id",
      deserializer: (json) => NotificationModel.fromJson(json),
    );
  }
}

// Membership
class MembershipService {
  HttpResult<MembershipResponse> fetchOptions() async {
    return Http.get("get/package/plans",
        deserializer: (json) => MembershipResponse.fromJson(json));
  }

  HttpResult<String> subscribeToPlan(int planId) async {
    return Http.post("plan/payment/mpesa", {"plan_id": planId},
        deserializer: (json) => json["message"]);
  }
}

class PlannedPaymentService {
  HttpResult<List<PlannedPayment>> fetchPlannedPayment() async {
    return Http.get("planned/payments/list",
        deserializer: (json) => plannedPaymentsFromJson(json["data"]));
  }

  HttpResult<PlannedPayment> addPlannedPayment(
      {required PlannedPaymentRequest request}) async {
    final body = Map<String, dynamic>.from(request.toJson());
    if (body['subcategory_id'] == 0) {
      body.remove('subcategory_id');
    }
    return Http.post("planned/payment/create", body,
        deserializer: (json) => PlannedPayment.fromJson(json["data"]));
  }

  HttpResult<PlannedPayment> plannedPaymentDetails({required int id}) async {
    return Http.get("planned/payment/show/$id",
        deserializer: (json) => PlannedPayment.fromJson(json["data"]));
  }

  HttpResult<PlannedPayment> updatePlannedPayment(
      {required int id, required PlannedPaymentRequest request}) async {
    final body = Map<String, dynamic>.from(request.toJson());
    if (body['subcategory_id'] == 0) {
      body.remove('subcategory_id');
    }
    return Http.put("planned/payment/update/$id", body,
        deserializer: (json) => PlannedPayment.fromJson(json['data']));
  }

  HttpResult<String> deletePlannedPayment({required int id}) async {
    return Http.delete("planned/payment/delete/$id",
        deserializer: (json) => json['message']);
  }

  HttpResult<String> createPaymentHistory({required int id}) async {
    return Http.post("planned/payments/mark-as-paid/$id", {},
        deserializer: (json) => json['message']);
  }
}

class PlanningService {
  // MARK: Goals
  HttpResult<List<Goals>> getGoals() async {
    return Http.get(
      "goals",
      deserializer: (json) {
        return List<Goals>.from(
          (json as List).map(
            (e) => Goals.fromJson(e as Map<String, dynamic>),
          ),
        );
      },
    );
  }

  HttpResult<Goals> getSpecificGoals(int goalId) async {
    return Http.get(
      "goals/$goalId",
      deserializer: (data) {
        if (data is Map && data['goal'] is Map) {
          return Goals.fromJson(Map<String, dynamic>.from(data['goal'] as Map));
        }
        return Goals.fromJson(Map<String, dynamic>.from(data as Map));
      },
    );
  }

  HttpResult<String> createGoals(Map<String, dynamic> goals) async {
    return Http.post(
      "goals",
      goals,
      deserializer: (data) => data['message'],
    );
  }

  HttpResult<Goals> updateGoals(Goals goals, int goalId) async {
    return Http.put(
      "goals/$goalId",
      goals,
      deserializer: (data) {
        if (data is Map && data.containsKey('message') && !data.containsKey('id')) {
          // Older API returned only message — keep local goal as success payload.
          return goals;
        }
        return Goals.fromJson(Map<String, dynamic>.from(data as Map));
      },
    );
  }

  HttpResult<String> updateGoalStatus(int goalId, String status) async {
    return Http.put(
      "goal/update/status/$goalId",
      {"status": status},
      deserializer: (data) => data['message'],
    );
  }

  HttpResult<String> deleteGoal(int goalId) async {
    return Http.delete(
      "goals/$goalId",
      deserializer: (data) => data["message"],
    );
  }

  // MARK: planned payments

  HttpResult<List<PlannedPayments>> getPlannedPayments() async {
    return Http.get(
      "planned-payments",
      deserializer: (data) =>
          (data as List).map((item) => PlannedPayments.fromJson(item)).toList(),
    );
  }

  // HttpResult<PlannedPayments> getSpecificPlannedPayment(
  //     int plannedPaymentId) async {
  //   return Http.get(
  //     "planned-payments/$plannedPaymentId",
  //     deserializer: (json) {
  //       PlannedPayments plannedPayment = PlannedPayments.fromJson(json);

  //       List<PaymentHistory> paymentHistories =
  //           (json['payment-histories'] as List)
  //               .map((historyJson) => PaymentHistory.fromJson(historyJson))
  //               .toList();

  //       plannedPayment =
  //           plannedPayment.copyWith(paymentHistories: paymentHistories);

  //       return plannedPayment;
  //     },
  //   );
  // }

  HttpResult<PlannedPayments> createPlannedPayments(
      Map<String, dynamic> plannedPayments) async {
    return Http.post(
      "planned-payments",
      plannedPayments,
      deserializer: (data) => PlannedPayments.fromJson(data),
    );
  }

  HttpResult<PlannedPayments> updatePlannedPayments(
      PlannedPayments plannedPayments, int plannedPaymentId) async {
    return Http.put(
      "planned-payments/$plannedPaymentId",
      plannedPayments,
      deserializer: (data) => PlannedPayments.fromJson(data),
    );
  }

  HttpResult<PlannedPayments> deletePlannedPayments(
      int plannedPaymentsId) async {
    return Http.delete(
      "planned_payments/$plannedPaymentsId",
      deserializer: (data) => data['message'],
    );
  }

  // MARK: payment histories

  HttpResult<PlannedPayments> createPaymentHistory(
      Map<String, dynamic> paymentHistory) async {
    return Http.post(
      "planned_payments",
      paymentHistory,
      deserializer: (data) => PlannedPayments.fromJson(data),
    );
  }

  HttpResult<PlannedPayments> updatePaymentHistory(
      Map<String, dynamic> paymentHistory) async {
    return Http.put(
      "planned_payments",
      paymentHistory,
      deserializer: (data) => PlannedPayments.fromJson(data),
    );
  }

  // MARK: Budgets

  HttpResult<UserBudgets> getUserBudgets() async {
    return Http.get(
      "budgets/user/list",
      deserializer: (e) {
        final map = Map<String, dynamic>.from(e as Map);
        map['message'] = map['message']?.toString() ?? '';
        if (map['user_budgets'] == null && map['budgets'] != null) {
          map['user_budgets'] = map['budgets'];
        }
        map['user_budgets'] ??= const <dynamic>[];
        // Amounts may arrive as numbers — normalize before model parse.
        final list = map['user_budgets'];
        if (list is List) {
          map['user_budgets'] = list.map((item) {
            if (item is! Map) return item;
            final row = Map<String, dynamic>.from(item);
            if (row['amount'] != null) row['amount'] = row['amount'].toString();
            if (row['budget_limit_amount'] != null) {
              row['budget_limit_amount'] =
                  row['budget_limit_amount'].toString();
            }
            return row;
          }).toList();
        }
        return UserBudgets.fromJson(map);
      },
    );
  }

  HttpResult<SingleBudgetResponse> getSpecificUserBudget(int budgetId) async {
    return Http.get(
      "budget/show/$budgetId",
      deserializer: (data) => SingleBudgetResponse.fromJson(data),
    );
  }

  HttpResult<String> createUserBudget(Map<String, dynamic> userBudget) async {
    return Http.post(
      "budget/user/create",
      userBudget,
      deserializer: (data) => data['message']?.toString() ?? 'Budget created',
    );
  }

  HttpResult<String> updateUserBudget(
      Map<String, dynamic> userBudget, int budgetId) async {
    return Http.put(
      "budget/update/$budgetId",
      userBudget,
      deserializer: (data) => data['message'],
    );
  }

  HttpResult<String> deleteUserBudget(int budgetId) async {
    return Http.delete(
      "budget/delete/$budgetId",
      deserializer: (data) => data["message"],
    );
  }

}
