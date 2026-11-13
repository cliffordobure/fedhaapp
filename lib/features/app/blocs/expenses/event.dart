part of 'bloc.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartExpense extends ExpenseEvent {}

class RefreshExpense extends ExpenseEvent {}

class FilterExpense extends ExpenseEvent {
  final String? keyword;

  FilterExpense({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class LoadCategories extends ExpenseEvent {}

// form
class SaveCategory extends ExpenseEvent {
  final Map<String, dynamic> formData;

  SaveCategory({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class SaveExpenseSubCategory extends ExpenseEvent {
  final FormData data;

  SaveExpenseSubCategory({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateExpenseSubCategory extends ExpenseEvent {
  final int subcategoryId;
  final FormData data;

  UpdateExpenseSubCategory({required this.subcategoryId, required this.data});

  @override
  List<Object?> get props => [subcategoryId, data];
}

class DeleteExpenseSubCategory extends ExpenseEvent {
  final int subcategoryId;

  DeleteExpenseSubCategory({required this.subcategoryId});

  @override
  List<Object?> get props => [subcategoryId];
}

class CategoriseExpense extends ExpenseEvent {
  final String transaction;
  final int category;

  CategoriseExpense({required this.transaction, required this.category});

  @override
  List<Object?> get props => [transaction, category];
}

// Create a new expense type
class NewExpenseType extends ExpenseEvent {
  final String name;

  NewExpenseType({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}

class SelectCategory extends ExpenseEvent {
  final categoryType.Category category;

  SelectCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class SelectSubCategory extends ExpenseEvent {
  final List<categoryType.SubCategory> subcategory;

  SelectSubCategory({required this.subcategory});

  @override
  List<Object?> get props => [subcategory];
}

class GetExpenseCategoryEvent extends ExpenseEvent {
  final int id;

  GetExpenseCategoryEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
