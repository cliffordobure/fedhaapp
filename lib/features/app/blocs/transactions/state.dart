part of 'bloc.dart';

enum TransactionsFilter { ALL, DEBIT, CREDIT }

class TransactionsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final ServiceStatus loadNextstatus;
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final double total;
  final bool hasUpdated;
  final int categorySelected;
  final int currentPage;
  final String? nextPageUrl;
  final bool hasMoreData;
  final bool isCategoryUpdated;
  final TransactionsFilter currentFilter;
  /// New debit txs that may match a bill / planned payment / budget / goal.
  final List<Transaction> pendingAllocationMatches;

  const TransactionsState(
      {this.status = ServiceStatus.initial,
      this.loadNextstatus = ServiceStatus.initial,
      this.transactions = const [],
      this.filteredTransactions = const [],
      this.message,
      this.hasUpdated = false,
      this.total = 0,
      this.categorySelected = 0,
      this.currentPage = 1, // Start from page 1
      this.nextPageUrl,
      this.hasMoreData = false,
      this.isCategoryUpdated = false,
      this.currentFilter = TransactionsFilter.ALL,
      this.pendingAllocationMatches = const []});

  TransactionsState copyWith({
    ServiceStatus? status,
    ServiceStatus? loadNextstatus,
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    ApplicationMessage? message,
    int? categorySelected,
    double? total,
    int? currentPage,
    bool? hasUpdated,
    String? nextPageUrl,
    bool? hasMoreData,
    bool? isCategoryUpdated,
    TransactionsFilter? currentFilter,
    List<Transaction>? pendingAllocationMatches,
  }) {
    return TransactionsState(
        status: status ?? this.status,
        hasUpdated: hasUpdated ?? this.hasUpdated,
        loadNextstatus: loadNextstatus ?? this.loadNextstatus,
        transactions: transactions ?? this.transactions,
        filteredTransactions: filteredTransactions ?? this.filteredTransactions,
        message: message,
        total: total ?? this.total,
        categorySelected: categorySelected ?? this.categorySelected,
        currentPage: currentPage ?? this.currentPage,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        hasMoreData: hasMoreData ?? this.hasMoreData,
        isCategoryUpdated: isCategoryUpdated ?? this.isCategoryUpdated,
        currentFilter: currentFilter ?? this.currentFilter,
        pendingAllocationMatches:
            pendingAllocationMatches ?? this.pendingAllocationMatches);
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        filteredTransactions,
        message,
        total,
        categorySelected,
        currentPage,
        nextPageUrl,
        hasMoreData,
        loadNextstatus,
        currentFilter,
        hasUpdated,
        isCategoryUpdated,
        pendingAllocationMatches,
      ];
}
