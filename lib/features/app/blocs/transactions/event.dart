part of 'bloc.dart';

abstract class TransactionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartTransactions extends TransactionsEvent {}

class RefreshTransactions extends TransactionsEvent {}

/// Show transactions in the UI immediately (SMS / offline), sync later.
class AddLocalTransactions extends TransactionsEvent {
  final List<Transaction> transactions;
  AddLocalTransactions({required this.transactions});
}

/// Clear allocation auto-match prompts after the UI handled them.
class ClearPendingAllocationMatches extends TransactionsEvent {}

/// Replace the in-memory list from local cache (e.g. after wallet delete).
class ApplyLocalTransactions extends TransactionsEvent {
  final List<Transaction> transactions;
  final double total;
  ApplyLocalTransactions({
    required this.transactions,
    required this.total,
  });
}

class FilterTransactions extends TransactionsEvent {
  final String? keyword;
  FilterTransactions({this.keyword});
  @override
  List<Object?> get props => [keyword];
}

class ToggleCategorySelected extends TransactionsEvent {
  final int selected;
  ToggleCategorySelected({required this.selected});

  @override
  List<Object?> get props => [selected];
}

// pagination events
class LoadNextPageEvent extends TransactionsEvent {}

class ClearTransactions extends TransactionsEvent {}

class FilterByType extends TransactionsEvent {
  final TransactionsFilter filter;

  FilterByType({required this.filter});
}

class UploadTransaction extends TransactionsEvent {
  final TransactionData data;

  UploadTransaction({required this.data});

  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

class UploadMultipleTransaction extends TransactionsEvent {
  final List<TransactionData> data;

  UploadMultipleTransaction({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateCategory extends TransactionsEvent {
  final int categoryId;
  final int? subcategoryId;
  final String transactionId;

  UpdateCategory(
      {required this.categoryId,
      this.subcategoryId,
      required this.transactionId});
}

class UpdateTransaction extends TransactionsEvent {
  final int transactionId;
  /// SMS / local rows are keyed by code when server id is missing/negative.
  final String? transactionCode;
  final String? narration;
  final double? amount;

  UpdateTransaction({
    required this.transactionId,
    this.transactionCode,
    this.narration,
    this.amount,
  });

  @override
  List<Object?> get props =>
      [transactionId, transactionCode, narration, amount];
}

class DeleteTransaction extends TransactionsEvent {
  final int transactionId;
  final String? transactionCode;

  DeleteTransaction({
    required this.transactionId,
    this.transactionCode,
  });

  @override
  List<Object?> get props => [transactionId, transactionCode];
}

// class UpdatedCategory extends TransactionsEvent {
//   final String message;

//   UpdatedCategory({required this.message});
// }
