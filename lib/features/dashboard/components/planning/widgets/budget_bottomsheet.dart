import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/budgets/budget.dart';
import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/budget/bloc.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;
import 'package:lucide_icons/lucide_icons.dart';

class NewBudgetBottomSheet extends StatefulWidget {
  const NewBudgetBottomSheet({Key? key, this.budget, this.update = false})
      : super(key: key);

  final UserBudget? budget;
  final bool update;

  @override
  State<NewBudgetBottomSheet> createState() => _NewBudgetBottomSheetState();
}

class _NewBudgetBottomSheetState extends State<NewBudgetBottomSheet> {
  late TextEditingController _amountController;
  late TextEditingController _budgetLimitAmountController;
  final _formKey = GlobalKey<FormState>();
  FormBudgetSpan? selectedBudgetSpan;
  Wallet? selectedWallet;
  int selectedType = 1; // 1 expense, 2 income
  int _currentStep = 0;
  int _stepDirection = 1;
  category_.Category? selectedCategoryIncome;
  category_.Category? selectedCategoryExpence;
  category_.SubCategory? selectedSubCategory;

  static const _steps = <({String title, IconData icon})>[
    (title: 'Details', icon: LucideIcons.fileText),
    (title: 'Category', icon: LucideIcons.network),
    (title: 'Subcategory', icon: LucideIcons.list),
  ];

  /// Backend accepts weekly|monthly|yearly ("Annually" → yearly).
  String _normalizeResetPeriod(String name) {
    final lower = name.trim().toLowerCase();
    if (lower == 'annually' || lower == 'annual') return 'yearly';
    return lower;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.budget?.amount.toString() ?? '0',
    );
    _budgetLimitAmountController = TextEditingController(
      text: widget.budget?.budgetLimitAmount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _budgetLimitAmountController.dispose();
    super.dispose();
  }

  void _ensureFormLoaded(BuildContext context) {
    if (context.read<BudgetBloc>().state.formStatus == ServiceStatus.initial) {
      context.read<BudgetBloc>().add(NewBudgetForm());
    }
    final expenses = context.read<ExpenseBloc>();
    if (expenses.state.categories.data.isEmpty) {
      expenses.add(LoadCategories());
    }
    final incomes = context.read<IncomeBloc>();
    if (incomes.state.incomeTypes.isEmpty) {
      incomes.add(FetchIncomeTypes());
    }
    final wallets = context.read<WalletsBloc>();
    if (wallets.state.wallets.isEmpty) {
      wallets.add(RefreshWallets());
    }
  }

  void _goNext() {
    if (_currentStep == 0 && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentStep == 1) {
      final selected =
          selectedType == 2 ? selectedCategoryIncome : selectedCategoryExpence;
      if (selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }
    }
    setState(() {
      _stepDirection = 1;
      _currentStep++;
    });
  }

  void _goBack() {
    if (_currentStep == 0) return;
    setState(() {
      _stepDirection = -1;
      _currentStep--;
    });
  }

  void _save() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      setState(() => _currentStep = 0);
      return;
    }
    final category = selectedType == 2
        ? selectedCategoryIncome
        : selectedCategoryExpence;
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      setState(() => _currentStep = 1);
      return;
    }
    if (selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account')),
      );
      setState(() => _currentStep = 0);
      return;
    }
    if (selectedBudgetSpan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reset period')),
      );
      setState(() => _currentStep = 0);
      return;
    }

    final amount = double.tryParse(
          _amountController.text.trim().replaceAll(',', ''),
        ) ??
        0;
    final limit = double.tryParse(
          _budgetLimitAmountController.text.trim().replaceAll(',', ''),
        ) ??
        0;

    final payload = <String, dynamic>{
      'category_id': category.id,
      'category_name': category.name,
      'amount': amount,
      'budget_limit_amount': limit,
      'reset_period': _normalizeResetPeriod(selectedBudgetSpan!.name),
      'type': selectedBudgetSpan!.id,
      'associated_wallet': selectedWallet!.bankId,
      'wallet_id': selectedWallet!.id,
      'wallet_name': selectedWallet!.name,
      'budget_name': category.name,
    };
    if (selectedSubCategory != null) {
      payload['subcategory_id'] = selectedSubCategory!.id;
      payload['subcategory_name'] = selectedSubCategory!.name;
    }

    if (widget.update) {
      context.read<UserBudgetBloc>().add(
            UpdateUserBudgetEvent(widget.budget!.id ?? 0, payload),
          );
    } else {
      context.read<UserBudgetBloc>().add(CreateUserBudgetEvent(payload));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    _ensureFormLoaded(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              _buildHeader(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final offset = Tween<Offset>(
                        begin: Offset(0.06 * _stepDirection, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: offset, child: child),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey(_currentStep),
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStepper(),
                          const SizedBox(height: 16),
                          if (_currentStep == 0) ...[
                            _buildIntroCard(),
                            const SizedBox(height: 18),
                          ],
                          _getStepContent(_currentStep),
                          if (_currentStep == 0) ...[
                            const SizedBox(height: 16),
                            _buildStayInControlCard(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.update ? 'Edit Budget' : 'New Budget',
                  style: HomeDesign.text(
                    size: 22,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set limits and stay on track',
                  style: HomeDesign.text(
                    size: 13,
                    color: HomeDesign.muted,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFF3F4F6),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.pop(),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(LucideIcons.x, size: 18, color: HomeDesign.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: SizedBox(
                    height: 2.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        children: [
                          const ColoredBox(color: Color(0xFFE5E7EB)),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: i <= _currentStep
                                ? 1
                                : (i == _currentStep + 1 ? 0.5 : 0),
                            child: const ColoredBox(color: HomeDesign.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            _StepDot(
              label: _steps[i].title,
              icon: _steps[i].icon,
              active: i == _currentStep,
              done: i < _currentStep,
              onTap: () {
                if (i > _currentStep &&
                    _currentStep == 0 &&
                    !(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                setState(() {
                  _stepDirection = i >= _currentStep ? 1 : -1;
                  _currentStep = i;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 56,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 10,
                  child: Container(
                    width: 40,
                    height: 34,
                    decoration: BoxDecoration(
                      color: HomeDesign.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(LucideIcons.wallet,
                        size: 20, color: Colors.white),
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 0,
                  child: Transform.rotate(
                    angle: -0.25,
                    child: Container(
                      width: 18,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF34D399),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 4,
                  child: Transform.rotate(
                    angle: 0.15,
                    child: Container(
                      width: 18,
                      height: 28,
                      decoration: BoxDecoration(
                        color: HomeDesign.greenDeep,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.pieChart,
                        size: 13, color: Color(0xFF7C3AED)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.update ? 'Update your budget' : 'Create a budget',
                  style: HomeDesign.text(
                    size: 14,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Give your budget a name, set your limits, and start managing your spending smarter.',
                  style: HomeDesign.text(
                    size: 12,
                    color: HomeDesign.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStayInControlCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: HomeDesign.green, width: 1.6),
            ),
            child: const Icon(
              LucideIcons.shieldCheck,
              size: 20,
              color: HomeDesign.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay in control',
                  style: HomeDesign.text(
                    size: 13,
                    weight: FontWeight.w700,
                    color: HomeDesign.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "We'll help you track your spending and notify you when you're close to your limit.",
                  style: HomeDesign.text(
                    size: 12,
                    color: HomeDesign.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final isLast = _currentStep >= 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F1F3))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Material(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  if (_currentStep > 0) {
                    _goBack();
                  } else {
                    context.pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    _currentStep > 0 ? 'Back' : 'Discard',
                    textAlign: TextAlign.center,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: isLast ? _save : _goNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeDesign.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast ? 'Save' : 'Next',
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (!isLast) ...[
                    const SizedBox(width: 6),
                    const Icon(LucideIcons.arrowRight, size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return _getStepZero();
      case 1:
        return _getStepOne();
      case 2:
        return _getStepTwo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getStepZero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget details',
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const SizedBox(height: 14),
        _FieldBlock(
          icon: LucideIcons.calendar,
          label: 'Period',
          child: _getBudgetResetPeriodDropdown(),
        ),
        const SizedBox(height: 14),
        _FieldBlock(
          icon: LucideIcons.flag,
          label: 'Budget limit (KES)',
          child: _moneyField(
            controller: _budgetLimitAmountController,
            hint: '0.00',
            validatorMessage: 'Budget limit is required',
          ),
        ),
        const SizedBox(height: 14),
        _FieldBlock(
          icon: LucideIcons.landmark,
          label: 'Associated account',
          child: _getAssociatedAccountDropdown(),
        ),
      ],
    );
  }

  Widget _moneyField({
    required TextEditingController controller,
    required String hint,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      style: HomeDesign.text(
        size: 14,
        weight: FontWeight.w600,
        color: HomeDesign.ink,
      ),
      decoration: _inputDecoration(hint),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return validatorMessage;
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: HomeDesign.text(size: 14, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HomeDesign.green, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HomeDesign.expense),
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? HomeDesign.mint : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? HomeDesign.green : const Color(0xFFE5E7EB),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: HomeDesign.text(
              size: 13,
              weight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? HomeDesign.greenDeep : HomeDesign.ink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a category',
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Is this budget for spending or income?',
          style: HomeDesign.text(size: 12.5, color: HomeDesign.muted),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _chip(
              label: 'Expense',
              selected: selectedType != 2,
              onTap: () => setState(() {
                selectedType = 1;
                selectedCategoryIncome = null;
                selectedSubCategory = null;
              }),
            ),
            const SizedBox(width: 8),
            _chip(
              label: 'Income',
              selected: selectedType == 2,
              onTap: () => setState(() {
                selectedType = 2;
                selectedCategoryExpence = null;
                selectedSubCategory = null;
              }),
            ),
          ],
        ),
        const SizedBox(height: 14),
        selectedType == 2
            ? _getIncomeTypeCategories()
            : _getExpenseTypeCategories(),
      ],
    );
  }

  Widget _getStepTwo() {
    final category =
        selectedType == 2 ? selectedCategoryIncome : selectedCategoryExpence;
    final subs = category?.subcategories ?? const <category_.SubCategory>[];

    if (category == null) {
      return _emptyHint('Select a category first');
    }
    if (subs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(LucideIcons.checkCircle2,
                color: HomeDesign.green, size: 40),
            const SizedBox(height: 12),
            Text(
              'No subcategories for this category',
              textAlign: TextAlign.center,
              style: HomeDesign.text(
                size: 14,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You can save this budget without a subcategory.',
              textAlign: TextAlign.center,
              style: HomeDesign.text(size: 12.5, color: HomeDesign.muted),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a subcategory',
          style: HomeDesign.text(
            size: 15,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Optional — tap one to narrow this budget.',
          style: HomeDesign.text(size: 12.5, color: HomeDesign.muted),
        ),
        const SizedBox(height: 14),
        ...subs.map(
          (e) => _selectableRow(
            title: e.name,
            imageUrl: e.image,
            selected: selectedSubCategory?.id == e.id,
            onTap: () => setState(() => selectedSubCategory = e),
          ),
        ),
      ],
    );
  }

  Widget _getBudgetResetPeriodDropdown() {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        if (state.formStatus == ServiceStatus.loading ||
            state.status == ServiceStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (state.formStatus == ServiceStatus.loadingFailure ||
            state.status == ServiceStatus.loadingFailure) {
          return _emptyHint('Failed to load reset periods');
        }

        final budgetSpans = state.formBudgetSpans;
        if (budgetSpans.isEmpty) {
          return _emptyHint('No reset periods available');
        }

        selectedBudgetSpan ??= budgetSpans.first;
        if (!budgetSpans.contains(selectedBudgetSpan)) {
          selectedBudgetSpan = budgetSpans.first;
        }

        return DropdownButtonFormField<FormBudgetSpan>(
          value: selectedBudgetSpan,
          icon: const Icon(LucideIcons.chevronDown,
              size: 18, color: HomeDesign.muted),
          items: budgetSpans
              .map(
                (e) => DropdownMenuItem<FormBudgetSpan>(
                  value: e,
                  child: Text(
                    e.name,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedBudgetSpan = value),
          validator: (value) {
            if (selectedBudgetSpan == null || value == null) {
              return 'Please select a reset period';
            }
            return null;
          },
          decoration: _inputDecoration('Select period'),
        );
      },
    );
  }

  Widget _getAssociatedAccountDropdown() {
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return _emptyHint('Failed to load wallets');
        }

        final wallets = state.wallets;
        if (wallets.isEmpty) {
          return _emptyHint('No wallets available');
        }

        if (selectedWallet != null && !wallets.contains(selectedWallet)) {
          selectedWallet = null;
        }

        return DropdownButtonFormField<Wallet>(
          value: selectedWallet,
          hint: Text(
            'Select account',
            style: HomeDesign.text(size: 14, color: const Color(0xFF9CA3AF)),
          ),
          icon: const Icon(LucideIcons.chevronDown,
              size: 18, color: HomeDesign.muted),
          items: wallets
              .map(
                (e) => DropdownMenuItem<Wallet>(
                  value: e,
                  child: Text(
                    e.institutionName?.isNotEmpty == true
                        ? e.institutionName!
                        : e.name,
                    overflow: TextOverflow.ellipsis,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedWallet = value),
          validator: (value) {
            if (selectedWallet == null || value == null) {
              return 'Please select an account';
            }
            return null;
          },
          decoration: _inputDecoration('Select account'),
        );
      },
    );
  }

  Widget _getIncomeTypeCategories() {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        if (state.incomeTypes.isEmpty) {
          return _emptyHint('No income categories available');
        }
        return Column(
          children: state.incomeTypes
              .map(
                (e) => _selectableRow(
                  title: e.name,
                  imageUrl: e.image,
                  selected: selectedCategoryIncome?.id == e.id,
                  onTap: () => setState(() {
                    selectedCategoryIncome = e;
                    selectedSubCategory = null;
                  }),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _getExpenseTypeCategories() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        final items = state.categories.data;
        if (items.isEmpty) {
          return _emptyHint('No expense categories available');
        }
        return Column(
          children: items
              .map(
                (e) => _selectableRow(
                  title: e.name,
                  imageUrl: e.image,
                  selected: selectedCategoryExpence?.id == e.id,
                  onTap: () => setState(() {
                    selectedCategoryExpence = e;
                    selectedSubCategory = null;
                  }),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _selectableRow({
    required String title,
    required String? imageUrl,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? HomeDesign.green : const Color(0xFFE5E7EB),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CategoryLogoImage(
                    imageUrl: imageUrl,
                    width: 34,
                    height: 34,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: HomeDesign.ink,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? LucideIcons.checkCircle2
                      : LucideIcons.circle,
                  color: selected ? HomeDesign.green : const Color(0xFFD1D5DB),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyHint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: HomeDesign.text(size: 13, color: HomeDesign.muted),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.icon,
    required this.active,
    required this.done,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active || done ? HomeDesign.green : const Color(0xFF9CA3AF);
    final bg = active || done ? HomeDesign.green : const Color(0xFFF3F4F6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              done && !active ? LucideIcons.check : icon,
              size: 18,
              color: active || done ? Colors.white : color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: HomeDesign.text(
              size: 11,
              weight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? HomeDesign.green : HomeDesign.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.icon,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.only(top: 22),
          decoration: BoxDecoration(
            color: HomeDesign.mint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: HomeDesign.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: HomeDesign.text(
                      size: 12.5,
                      weight: FontWeight.w500,
                      color: HomeDesign.muted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.helpCircle,
                    size: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              child,
            ],
          ),
        ),
      ],
    );
  }
}
