part of 'bloc.dart';

class BillsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;
  final ServiceStatus formStatus;
  final List<BillExpense> billExpenses;
  final List<BillType> billTypes;
  final UserBill? bill;
  final FinancialSpan? span;
  final BillSpan? selected;

  const BillsState(
      {this.status = ServiceStatus.initial,
      this.formStatus = ServiceStatus.initial,
      this.message,
      this.billExpenses = const [],
      this.billTypes = const [],
      this.bill,
      this.span,
      this.selected});

  BillsState copyWith(
      {ServiceStatus? status,
      ServiceStatus? formStatus,
      ApplicationMessage? message,
      List<BillExpense>? billExpenses,
      List<BillType>? billTypes,
      FinancialSpan? span,
      UserBill? bill,
      BillSpan? selected}) {
    return BillsState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      message: message,
      billExpenses: billExpenses ?? this.billExpenses,
      billTypes: billTypes ?? this.billTypes,
      bill: bill ?? this.bill,
      span: span ?? this.span,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        billExpenses,
        billTypes,
        bill,
        span,
        selected,
        formStatus
      ];
}
