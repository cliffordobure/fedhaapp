part of 'bloc.dart';

class IncomeState extends Equatable {
  final List<category_.Category> filteredIncome;
  final List<category_.Category> income;
  final double total;
  final List<category_.Category> incomeTypes;
  final category_.Category? selectedIncomeType;
  final List<category_.SubCategory>? selectedSubCategory;
  final category_.Category? selectedCategory;
  final ServiceStatus status;
  final ServiceStatus formStatus;
  final CategoryColorManager colorManager;

  IncomeState({
    this.filteredIncome = const [],
    this.income = const [],
    this.incomeTypes = const [],
    this.selectedCategory,
    this.selectedIncomeType,
    this.selectedSubCategory,
    this.total = 0,
    this.status = ServiceStatus.initial,
    this.formStatus = ServiceStatus.initial,
    CategoryColorManager? colorManager,
  }) : colorManager = colorManager ?? CategoryColorManager();

  get categories => null;

  IncomeState copyWith(
      {ServiceStatus? status,
      ServiceStatus? formStatus,
      List<category_.Category>? filteredIncome,
      List<category_.Category>? income,
      ApplicationMessage? message,
      List<category_.Category>? incomeTypes,
      double? total,
      category_.Category? selectedIncomeType,
      List<category_.SubCategory>? selectedSubCategory,
      category_.Category? selectedCategory,
      List<category_.SubCategory>? selectedIncomeSubCategory,
      CategoryColorManager? colorManager}) {
    return IncomeState(
        filteredIncome: filteredIncome ?? this.filteredIncome,
        income: income ?? this.income,
        total: total ?? this.total,
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        incomeTypes: incomeTypes ?? this.incomeTypes,
        selectedIncomeType: selectedIncomeType ?? this.selectedIncomeType,
        selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        colorManager: this.colorManager);
  }

  @override
  List<Object?> get props => [
        filteredIncome,
        income,
        total,
        incomeTypes,
        status,
        formStatus,
        selectedIncomeType,
        selectedSubCategory,
        colorManager
      ];
}
