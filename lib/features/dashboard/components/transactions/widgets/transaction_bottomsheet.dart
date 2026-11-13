import 'package:easy_stepper/easy_stepper.dart';
import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/budget/bloc.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/string_utils.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionBottomSheet extends StatefulWidget {
  const TransactionBottomSheet({Key? key}) : super(key: key);

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _desiredTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int? selectedType;
  DateTime selectedDate = DateTime.now();
  Wallet? selectedWallet;
  category.Category? selectedCategoryIncome;
  category.Category? selectedCategoryExpence;
  int _currentStep = 0;
  category.SubCategory? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ensureCategoriesLoaded();
    });
  }

  /// Categories are loaded by the home sync, which may not have finished
  /// (or may have failed) by the time this sheet is opened.
  void _ensureCategoriesLoaded() {
    final expenses = context.read<ExpenseBloc>();
    if (expenses.state.categories.data.isEmpty &&
        expenses.state.formStatus != ServiceStatus.loading) {
      expenses.add(LoadCategories());
    }
    final incomes = context.read<IncomeBloc>();
    if (incomes.state.incomeTypes.isEmpty &&
        incomes.state.formStatus != ServiceStatus.loading) {
      incomes.add(FetchIncomeTypes());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<BudgetBloc>().state.formStatus == ServiceStatus.initial) {
      context.read<BudgetBloc>().add(NewBudgetForm());
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Add Transactions",
                          style: theme.titleMedium!.copyWith(
                              fontSize: 18,
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.w700))),
                  EasyStepper(
                    activeStep: _currentStep,
                    steps: const [
                      EasyStep(title: 'Details', icon: Icon(Icons.details)),
                      EasyStep(title: 'Categories', icon: Icon(Icons.category)),
                      EasyStep(title: 'Sub-categories', icon: Icon(Icons.list)),
                    ],
                    onStepReached: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _getStepContent(_currentStep),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _currentStep > 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              child: const Text(
                                'Previous',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : const SizedBox.shrink(),
                      _currentStep < 2
                          ? ElevatedButton(
                              onPressed: () {
                                if (_currentStep == 0 && selectedType == null) {
                                  showSnackBar(context,
                                      content:
                                          "Please select a transaction type before proceeding.",
                                      bgColor: Colors.red);
                                } else {
                                  if (_currentStep == 0) {
                                    _ensureCategoriesLoaded();
                                  }
                                  setState(() {
                                    _currentStep++;
                                  });
                                }
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _saveTransaction,
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text("Discard"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveTransaction() {
    if (selectedType == null) {
      _showSaveError('Select expense or income on the details step.');
      setState(() => _currentStep = 0);
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showSaveError('Enter an amount on the details step.');
      setState(() => _currentStep = 0);
      return;
    }

    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      _showSaveError('Enter a description on the details step.');
      setState(() => _currentStep = 0);
      return;
    }

    final wallets = context.read<WalletsBloc>().state.wallets;
    if (selectedWallet == null && wallets.isNotEmpty) {
      selectedWallet = wallets.first;
    }
    final wallet = selectedWallet;
    if (wallet == null) {
      _showSaveError('Add a wallet before saving a transaction.');
      setState(() => _currentStep = 0);
      return;
    }

    final category = selectedType == 1
        ? selectedCategoryExpence
        : selectedCategoryIncome;
    if (category == null) {
      _showSaveError('Select a category before saving.');
      setState(() => _currentStep = 1);
      return;
    }

    // Subcategory is optional. A chosen one is sent; skipping it still saves.
    context.read<TransactionsBloc>().add(
          UploadTransaction(
            data: TransactionData(
              amount: amount,
              categoryId: category.id,
              charges: 0,
              subcategoryId: selectedSubCategory?.id,
              wallet: wallet.id,
              code: generateRandomString().toUpperCase(),
              name: description,
              datetime: selectedDate,
              type: selectedType == 2 ? 'credit' : 'debit',
            ),
          ),
        );
    Navigator.of(context).pop();
  }

  void _showSaveError(String message) {
    showSnackBar(context, content: message, bgColor: Colors.red);
  }

  Future<void> getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
        _desiredTimeController.text =
            DateFormat.yMd().format(pickerDate).toString();
      });
    } else {
      debugPrint("Something is not right");
    }
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return _getTransactionDetailsStep();
      case 1:
        return selectedType == 2
            ? _getIncomeCategoriesStep()
            : _getExpenseCategoriesStep();
      case 2:
        return _getSubCategoriesStep();
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget _getTransactionDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTransactionTypeSelection(),
        const SizedBox(height: 20),
        _getDesiredDateField(),
        _getDescriptionField(),
        _getAmountField(),
        _getWalletSelection(),
      ],
    );
  }

  Widget _getTransactionTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Type", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getTransactionTypeButton(1, 'Expense'),
            _getTransactionTypeButton(2, 'Income'),
          ],
        ),
      ],
    );
  }

  Widget _getTransactionTypeButton(int type, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          color: selectedType == type ? Colors.green[200] : Colors.grey[200],
        ),
        child: Text(label),
      ),
    );
  }

  Widget _getDesiredDateField() {
    return DefaultInputField(
      textEditingController: _desiredTimeController,
      inputtype: TextInputType.none,
      readOnly: true,
      onTap: getDateFromUser,
      title: 'Desired Date',
      inputAction: TextInputAction.done,
      hide: false,
      suffix: IconButton(
        onPressed: getDateFromUser,
        icon: const Icon(
          Icons.access_time_rounded,
          color: Colors.grey,
        ),
      ),
      validator: (onValidateVal) {
        if (onValidateVal.isEmpty) {
          return "Date is required";
        }
        return null;
      },
      onSaved: (String? onSavedVal) {
        if (kDebugMode) {
          print("on saved calles");
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      hintText: "24th Mar 2024",
    );
  }

  Widget _getDescriptionField() {
    return DefaultInputField(
      textEditingController: _descriptionController,
      inputtype: TextInputType.text,
      title: 'Description',
      inputAction: TextInputAction.done,
      hide: false,
      validator: (onValidateVal) {
        if (onValidateVal.isEmpty) {
          return "Description is required";
        }
        return null;
      },
      onSaved: (String? onSavedVal) {
        if (kDebugMode) {
          print("on saved called");
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      hintText: "Grocery shopping",
    );
  }

  Widget _getAmountField() {
    return DefaultInputField(
      textEditingController: _amountController,
      inputtype: const TextInputType.numberWithOptions(decimal: true),
      title: 'Amount (Ksh)',
      inputAction: TextInputAction.done,
      hide: false,
      validator: (onValidateVal) {
        if (onValidateVal.isEmpty) {
          return "Amount is required";
        }
        return null;
      },
      onSaved: (String? onSavedVal) {
        if (kDebugMode) {
          print("on saved called");
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      hintText: "0",
    );
  }

  Widget _getWalletSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Associated Wallet",
            style: Theme.of(context).textTheme.labelMedium!),
        const SizedBox(height: 16),
        BlocBuilder<WalletsBloc, WalletsState>(
          builder: (context, state) {
            if (state.status == ServiceStatus.loading) {
              return const CircularProgressIndicator();
            }
            if (state.status == ServiceStatus.loadingFailure) {
              return const Center(
                child: Text("Failed to load Wallets"),
              );
            }

            final budgetSpans = state.wallets;

            if (budgetSpans.isEmpty) {
              return const Text("No Wallets listed");
            }

            if (!budgetSpans.contains(selectedWallet)) {
              selectedWallet = budgetSpans.first;
            }

            return DropdownButtonFormField<Wallet>(
              value: selectedWallet,
              items: budgetSpans
                  .map((e) => DropdownMenuItem<Wallet>(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedWallet = value;
                });
              },
              validator: (value) {
                if (selectedWallet == null || value == null) {
                  return "Please select a wallet";
                }
                return null;
              },
              decoration: getDropDownDecoration(context, true, "Select wallet"),
            );
          },
        ),
      ],
    );
  }

  Widget _getIncomeCategoriesStep() {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        return _categoryStepBody(
          categories: state.incomeTypes,
          selected: selectedCategoryIncome,
          status: state.formStatus,
          onRetry: () => context.read<IncomeBloc>().add(FetchIncomeTypes()),
        );
      },
    );
  }

  Widget _getExpenseCategoriesStep() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return _categoryStepBody(
          categories: state.categories.data,
          selected: selectedCategoryExpence,
          status: state.formStatus,
          onRetry: () => context.read<ExpenseBloc>().add(LoadCategories()),
        );
      },
    );
  }

  Widget _categoryStepBody({
    required List<category.Category> categories,
    required category.Category? selected,
    required ServiceStatus status,
    required VoidCallback onRetry,
  }) {
    if (categories.isEmpty &&
        (status == ServiceStatus.initial || status == ServiceStatus.loading)) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (categories.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No categories available'),
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Reload')),
            ],
          ),
        ),
      );
    }
    return _getCategorySelectionWidget(categories, selected);
  }

  Widget _getCategorySelectionWidget(
      List<category.Category> categories, category.Category? selectedCategory) {
    return SizedBox(
      height: 460,
      child: SingleChildScrollView(
        child: Column(
          children: categories
              .map((e) =>
                  _getCategoryWidget(e, selectedCategory?.id == e.id))
              .toList(),
        ),
      ),
    );
  }

  Widget _getCategoryWidget(category.Category category, bool isSelected) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedType == 2) {
              selectedCategoryIncome = category;
            } else {
              selectedCategoryExpence = category;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey),
              color: isSelected ? Colors.green[200] : Colors.grey[200],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CategoryLogoImage(
                    imageUrl: category.image,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Text(category.name),
                const Spacer(),
                Radio<int>(
                  value: category.id,
                  groupValue: selectedType == 2
                      ? selectedCategoryIncome?.id
                      : selectedCategoryExpence?.id,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSubCategoriesStep() {
    return selectedCategoryIncome != null || selectedCategoryExpence != null
        ? SizedBox(
            height: 460,
            child: SingleChildScrollView(
              child: Column(
                children: selectedType == 2
                    ? selectedCategoryIncome!.subcategories
                        .map((e) => _getSubCategoryWidget(
                            e, selectedSubCategory?.id == e.id))
                        .toList()
                    : selectedCategoryExpence!.subcategories
                        .map((e) => _getSubCategoryWidget(
                            e, selectedSubCategory?.id == e.id))
                        .toList(),
              ),
            ),
          )
        : const Center(child: Text("You are set! No Subcategories found"));
  }

  Widget _getSubCategoryWidget(
      category.SubCategory subCategory, bool isSelected) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSubCategory = subCategory;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey),
              color: isSelected ? Colors.green[200] : Colors.grey[200],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CategoryLogoImage(
                    imageUrl: subCategory.image,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Text(subCategory.name),
                const Spacer(),
                Radio<int>(
                  value: subCategory.id,
                  groupValue: selectedSubCategory?.id,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration getDropDownDecoration(
      BuildContext context, bool isDropdown, String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding:
          EdgeInsets.symmetric(vertical: isDropdown ? 0 : 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
