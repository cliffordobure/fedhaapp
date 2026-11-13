part of 'bloc.dart';

abstract class BillsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartBillsBloc extends BillsEvent {}

class RefreshBills extends BillsEvent {}

class SpanSelected extends BillsEvent {
  final FinancialSpan span;

  SpanSelected(this.span);

  @override
  List<Object?> get props => [span];
}

class NewBill extends BillsEvent {
  final Map<String, dynamic> data;

  NewBill(this.data);

  @override
  List<Object?> get props => [data];
}

class EditBill extends BillsEvent {
  final Map<String, dynamic> data;
  final int id;

  EditBill(this.data, this.id);

  @override
  List<Object?> get props => [data, id];
}

class DeleteBill extends BillsEvent {
  final int id;

  DeleteBill(this.id);

  @override
  List<Object?> get props => [id];
}

class NewBillForm extends BillsEvent {}

// Create a new bill type
class NewBillType extends BillsEvent {
  final String name;

  NewBillType({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}

class RefreshBillTypes extends BillsEvent {}
