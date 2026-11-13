part of 'bloc.dart';

abstract class IncomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveIncomeSubCategory extends IncomeEvent {
  final FormData data;

  SaveIncomeSubCategory({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateIncomeSubCategory extends IncomeEvent {
  final int subcategoryId;
  final FormData data;

  UpdateIncomeSubCategory({required this.subcategoryId, required this.data});

  @override
  List<Object?> get props => [subcategoryId, data];
}

class DeleteIncomeSubCategory extends IncomeEvent {
  final int subcategoryId;

  DeleteIncomeSubCategory({required this.subcategoryId});

  @override
  List<Object?> get props => [subcategoryId];
}

class StartIncome extends IncomeEvent {}

class RefreshIncome extends IncomeEvent {}

class FilterIncome extends IncomeEvent {
  final String? keyword;

  FilterIncome({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class FetchIncomeTypes extends IncomeEvent {}

class SaveIncome extends IncomeEvent {
  final Map<String, dynamic> formData;

  SaveIncome({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class CategoriseIncome extends IncomeEvent {
  final String transaction;
  final int category;

  CategoriseIncome({required this.transaction, required this.category});

  @override
  List<Object?> get props => [transaction, category];
}

class SelectIncomeType extends IncomeEvent {
  final category_.Category incomeType;

  SelectIncomeType({required this.incomeType});

  @override
  List<Object?> get props => [incomeType];
}

class SelectIncomeSubCategory extends IncomeEvent {
  final List<category_.SubCategory> incomeSubCategory;

  SelectIncomeSubCategory({required this.incomeSubCategory});

  @override
  List<Object?> get props => [incomeSubCategory];
}

class GetIncomeCategoryEvent extends IncomeEvent {
  final int categoryId;

  GetIncomeCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
