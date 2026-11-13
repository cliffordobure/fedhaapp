part of 'bloc.dart';

class ExpenseState extends Equatable {
  final categoryType.CategoryResponse filteredExpenses;
  final categoryType.CategoryResponse expenses;
  final double total;
  final categoryType.CategoryResponse categories;
  final categoryType.Category? selectedCategory;
  final List<categoryType.SubCategory>? selectedSubCategory;
  final CategoryColorManager colorManager;
  final ServiceStatus status;
  final ServiceStatus formStatus;
  ExpenseState({
    this.filteredExpenses = const categoryType.CategoryResponse(
        status: 404, message: "not fetched", success: false, data: []),
    this.expenses = const categoryType.CategoryResponse(
        status: 404, message: "not fetched", success: false, data: []),
    this.categories = const categoryType.CategoryResponse(
        status: 404, message: "not fetched", success: false, data: []),
    this.total = 0,
    this.selectedCategory,
    this.selectedSubCategory,
    this.status = ServiceStatus.initial,
    this.formStatus = ServiceStatus.initial,
    CategoryColorManager? colorManager,
  }) : colorManager = colorManager ?? CategoryColorManager();

  get incomeTypes => null;

  ExpenseState copyWith(
      {ServiceStatus? status,
      ServiceStatus? formStatus,
      categoryType.CategoryResponse? filteredExpenses,
      categoryType.CategoryResponse? expenses,
      ApplicationMessage? message,
      categoryType.CategoryResponse? categories,
      double? total,
      categoryType.Category? selectedCategory,
      List<categoryType.SubCategory>? selectedSubCategory,
      CategoryColorManager? colorManager}) {
    return ExpenseState(
        filteredExpenses: filteredExpenses ?? this.filteredExpenses,
        expenses: expenses ?? this.expenses,
        total: total ?? this.total,
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
        colorManager: this.colorManager);
  }

  @override
  List<Object?> get props => [
        filteredExpenses,
        expenses,
        total,
        status,
        categories,
        formStatus,
        selectedCategory,
        colorManager,
        selectedSubCategory,
      ];
}
