import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/models/planned_payment/planned_payment_request.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;
import 'package:lucide_icons/lucide_icons.dart';

class NewPlannedPaymentBottomSheet extends StatefulWidget {
  const NewPlannedPaymentBottomSheet({
    Key? key,
    this.payment,
    this.category = '',
    this.update = false,
  }) : super(key: key);

  final bool update;
  final String category;
  final PlannedPayment? payment;

  @override
  State<NewPlannedPaymentBottomSheet> createState() =>
      _NewPlannedPaymentBottomSheetState();
}

class _NewPlannedPaymentBottomSheetState
    extends State<NewPlannedPaymentBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _desiredTimeController;
  final _formKey = GlobalKey<FormState>();
  int? selectedType = 0;
  int? selectedCategoryType = 1; // 1 = expense, 2 = income
  int _currentStep = 0;
  int _stepDirection = 1;
  DateTime selectedDate = DateTime.now();

  category_.Category? selectedCategoryIncome;
  category_.Category? selectedCategoryExpence;
  category_.SubCategory? selectedSubCategory;

  static const _steps = <({String title, IconData icon})>[
    (title: 'Details', icon: LucideIcons.fileText),
    (title: 'Category', icon: LucideIcons.shapes),
    (title: 'Subcategory', icon: LucideIcons.list),
  ];

  @override
  void initState() {
    super.initState();

    selectedType = widget.payment?.frequency == 'monthly'
        ? 3
        : widget.payment?.frequency == 'weekly'
            ? 2
            : widget.payment?.frequency == 'daily'
                ? 1
                : 0; // once / does not repeat
    _amountController = TextEditingController(
      text: widget.payment != null ? widget.payment!.amount.toString() : '',
    );
    _desiredTimeController = TextEditingController(
      text: widget.payment != null
          ? widget.payment!.paymentDate.toString()
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _nameController = TextEditingController(
      text: widget.payment != null ? widget.payment!.name.toString() : '',
    );

    // Categories live on ExpenseBloc / IncomeBloc — load them when the
    // sheet opens (Planning may open before Home has fetched them).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ensureCategoriesLoaded();
    });
  }

  void _ensureCategoriesLoaded() {
    final expenses = context.read<ExpenseBloc>();
    if (expenses.state.categories.data.isEmpty) {
      expenses.add(LoadCategories());
    }
    final incomes = context.read<IncomeBloc>();
    if (incomes.state.incomeTypes.isEmpty) {
      incomes.add(FetchIncomeTypes());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _desiredTimeController.dispose();
    super.dispose();
  }

  String get _frequencyLabel {
    if (selectedType == 3) return 'monthly';
    if (selectedType == 2) return 'weekly';
    if (selectedType == 1) return 'daily';
    return 'once';
  }

  String get _frequencyDisplay {
    if (selectedType == 3) return 'Monthly';
    if (selectedType == 2) return 'Weekly';
    if (selectedType == 1) return 'Daily';
    return 'Does not repeat';
  }

  Future<void> _pickDate() async {
    final pickerDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HomeDesign.green,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
        _desiredTimeController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _pickFrequency() async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final options = [
          (0, 'Does not repeat'),
          (1, 'Daily'),
          (2, 'Weekly'),
          (3, 'Monthly'),
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final o in options)
                ListTile(
                  title: Text(
                    o.$2,
                    style: HomeDesign.text(
                      size: 14,
                      weight: selectedType == o.$1
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: HomeDesign.ink,
                    ),
                  ),
                  trailing: selectedType == o.$1
                      ? const Icon(LucideIcons.check, color: HomeDesign.green)
                      : null,
                  onTap: () => Navigator.pop(context, o.$1),
                ),
            ],
          ),
        );
      },
    );
    if (chosen != null && mounted) {
      HapticFeedback.selectionClick();
      setState(() => selectedType = chosen);
    }
  }

  void _setStep(int next) {
    if (next == _currentStep) return;
    HapticFeedback.selectionClick();
    if (next >= 1) _ensureCategoriesLoaded();
    setState(() {
      _stepDirection = next > _currentStep ? 1 : -1;
      _currentStep = next;
    });
  }

  void _goNext() {
    if (_currentStep == 0 && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentStep == 1) {
      final selected = selectedCategoryType == 2
          ? selectedCategoryIncome
          : selectedCategoryExpence;
      if (selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.darkBlueColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const Text('Please select a category'),
          ),
        );
        return;
      }
    }
    _setStep(_currentStep + 1);
  }

  void _goBack() {
    if (_currentStep > 0) _setStep(_currentStep - 1);
  }

  void _save() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      _setStep(0);
      return;
    }
    final categoryId = selectedCategoryType == 2
        ? selectedCategoryIncome?.id
        : selectedCategoryExpence?.id;
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.darkBlueColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text('Please select a category'),
        ),
      );
      _setStep(1);
      return;
    }

    HapticFeedback.mediumImpact();
    final request = PlannedPaymentRequest(
      subcategoryId: selectedSubCategory?.id ?? 0,
      name: _nameController.text.trim(),
      categoryId: categoryId,
      amount: _amountController.text,
      paymentDate: _desiredTimeController.text,
      frequency: _frequencyLabel,
    );

    context.read<PlannedPaymentBloc>().add(
          !widget.update
              ? PlannedPaymentEvent.added(request: request)
              : PlannedPaymentEvent.updated(
                  id: widget.payment?.id ?? 0,
                  request: request,
                ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final topPad = MediaQuery.paddingOf(context).top;

    return BlocListener<PlannedPaymentBloc, PlannedPaymentState>(
      listener: (context, state) {
        if (state.status == PlannedPaymentStatus.success) {
          context.pop();
        }
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          color: const Color(0xFFF5F7F6),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(height: topPad > 0 ? topPad : 8),
                _buildTopBar(),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offset = Tween<Offset>(
                          begin: Offset(0.08 * _stepDirection, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offset,
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        key: ValueKey(_currentStep),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        child: Column(
                          children: [
                            _buildHeroBanner(),
                            const SizedBox(height: 16),
                            _buildStepper(),
                            const SizedBox(height: 14),
                            _getStepContent(_currentStep),
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
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(
                  LucideIcons.arrowLeft,
                  size: 18,
                  color: HomeDesign.ink,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Planned Payments',
              textAlign: TextAlign.center,
              style: HomeDesign.text(
                size: 17,
                weight: FontWeight.w700,
                color: HomeDesign.ink,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => context.pushNamed(Routes.bills),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: HomeDesign.green.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.wallet,
                      size: 14,
                      color: HomeDesign.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Bills',
                      style: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w600,
                        color: HomeDesign.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A3326),
            Color(0xFF0B3D2E),
            Color(0xFF0F5C3D),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.update ? LucideIcons.pencil : LucideIcons.calendarClock,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.update
                      ? 'Edit planned payment'
                      : 'New planned payment',
                  style: HomeDesign.text(
                    size: 14,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Add the details of your payment so you never miss it.',
                  style: HomeDesign.text(
                    size: 11.5,
                    weight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white.withValues(alpha: 0.14),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.pop(),
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(LucideIcons.x, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: _currentStep >= i ? 1 : 0,
                    ),
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 3,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation(
                            HomeDesign.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            _StepBubble(
              index: i,
              label: _steps[i].title,
              icon: _steps[i].icon,
              active: _currentStep == i,
              completed: _currentStep > i,
              onTap: () {
                if (i > _currentStep) {
                  if (_currentStep == 0 &&
                      !(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  if (_currentStep == 1) {
                    final selected = selectedCategoryType == 2
                        ? selectedCategoryIncome
                        : selectedCategoryExpence;
                    if (selected == null) return;
                  }
                }
                _setStep(i);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final isLast = _currentStep >= 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => context.pop(),
            style: TextButton.styleFrom(
              foregroundColor: HomeDesign.muted,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
            child: Text(
              'Discard',
              style: HomeDesign.text(
                size: 14,
                weight: FontWeight.w500,
                color: HomeDesign.muted,
              ),
            ),
          ),
          const Spacer(),
          if (_currentStep > 0) ...[
            TextButton(
              onPressed: _goBack,
              child: Text(
                'Back',
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w600,
                  color: HomeDesign.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          ElevatedButton(
            onPressed: isLast ? _save : _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeDesign.green,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLast ? 'Save payment' : 'Continue',
                  style: HomeDesign.text(
                    size: 14,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isLast ? LucideIcons.check : LucideIcons.arrowRight,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardShell({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.greyColor.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionEyebrow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: HomeDesign.green,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: HomeDesign.text(
              size: 14,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeToggle({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryColor.withValues(alpha: 0.12)
                : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.greyColor.withValues(alpha: 0.45),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppColors.primaryColor
                    : AppColors.fadeBlackColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppColors.primaryColor
                      : AppColors.darkColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectableRow({
    required String title,
    required String? imageUrl,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final fallbackUrl = 'https://app.fedhatrac.com/images/categories';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryColor.withValues(alpha: 0.08)
                  : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withValues(alpha: 0.35),
                width: selected ? 1.6 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null &&
                          imageUrl.isNotEmpty &&
                          imageUrl != fallbackUrl
                      ? CategoryLogoImage(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                        )
                      : _categoryAvatar(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: selected ? 1 : 0.85,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected
                        ? AppColors.primaryColor
                        : AppColors.greyColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryAvatar() {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.18),
            AppColors.darkGreenColor.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        LucideIcons.shapes,
        color: AppColors.primaryColor,
        size: 18,
      ),
    );
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return _cardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionEyebrow('Payment details'),
              _LabeledField(
                label: 'Name',
                hint: 'What is this payment for?',
                child: _IconInput(
                  controller: _nameController,
                  icon: LucideIcons.tag,
                  hintText: 'e.g. Rent, Electricity',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Amount (KES)',
                hint: 'How much do you plan to pay?',
                child: _IconInput(
                  controller: _amountController,
                  icon: LucideIcons.wallet,
                  hintText: 'Enter amount',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Payment date',
                hint: 'When is this payment due?',
                child: _IconInput(
                  controller: _desiredTimeController,
                  icon: LucideIcons.calendar,
                  hintText: 'Select date',
                  readOnly: true,
                  onTap: _pickDate,
                  trailing: IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(
                      LucideIcons.calendar,
                      color: HomeDesign.green,
                      size: 18,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 14),
              _LabeledField(
                label: 'Repeat',
                hint: 'How often does this payment repeat?',
                child: InkWell(
                  onTap: _pickFrequency,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F6EC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            LucideIcons.refreshCw,
                            size: 16,
                            color: HomeDesign.green,
                          ),
                        ),
                      ),
                      suffixIcon: const Icon(
                        LucideIcons.chevronDown,
                        size: 18,
                        color: HomeDesign.ink,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    child: Text(
                      _frequencyDisplay,
                      style: HomeDesign.text(
                        size: 14,
                        weight: FontWeight.w600,
                        color: HomeDesign.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionEyebrow('Category type'),
                  Row(
                    children: [
                      _typeToggle(
                        label: 'Expense',
                        icon: LucideIcons.arrowUpRight,
                        selected: selectedCategoryType != 2,
                        onTap: () => setState(() {
                          selectedCategoryType = 1;
                          selectedCategoryIncome = null;
                          selectedSubCategory = null;
                        }),
                      ),
                      const SizedBox(width: 8),
                      _typeToggle(
                        label: 'Income',
                        icon: LucideIcons.arrowDownLeft,
                        selected: selectedCategoryType == 2,
                        onTap: () => setState(() {
                          selectedCategoryType = 2;
                          selectedCategoryExpence = null;
                          selectedSubCategory = null;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _sectionEyebrow(
              selectedCategoryType == 2
                  ? 'Income categories'
                  : 'Expense categories',
            ),
            if (selectedCategoryType == 2)
              BlocBuilder<IncomeBloc, IncomeState>(
                builder: (context, state) {
                  if (state.incomeTypes.isEmpty &&
                      state.formStatus == ServiceStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.incomeTypes.isEmpty) {
                    return _emptyListHint('No income categories available');
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
              )
            else
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  final items = state.categories.data;
                  if (items.isEmpty &&
                      state.formStatus == ServiceStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (items.isEmpty) {
                    return Column(
                      children: [
                        _emptyListHint('No expense categories available'),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            context.read<ExpenseBloc>().add(LoadCategories());
                          },
                          icon: const Icon(LucideIcons.refreshCw, size: 16),
                          label: const Text('Reload categories'),
                        ),
                      ],
                    );
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
              ),
          ],
        );

      case 2:
        final category = selectedCategoryType == 2
            ? selectedCategoryIncome
            : selectedCategoryExpence;
        final subs = category?.subcategories ?? const <category_.SubCategory>[];

        if (category == null) {
          return _emptyListHint('Select a category first');
        }
        if (subs.isEmpty) {
          return _cardShell(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.checkCircle2,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ready to save',
                  style: TextStyle(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No subcategories for “${category.name}”. You can save this payment as-is.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionEyebrow('Subcategory (optional)'),
                  Text(
                    'For ${category.name}',
                    style: TextStyle(
                      color: AppColors.fadeBlackColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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

      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget _emptyListHint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.inbox, color: AppColors.fadeBlackColor, size: 28),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.fadeBlackColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.child,
  });

  final String label;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: HomeDesign.text(
            size: 13,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          hint,
          style: HomeDesign.text(
            size: 11.5,
            weight: FontWeight.w400,
            color: HomeDesign.muted,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _IconInput extends StatelessWidget {
  const _IconInput({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.trailing,
    this.validator,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      style: HomeDesign.text(
        size: 14,
        weight: FontWeight.w600,
        color: HomeDesign.ink,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: HomeDesign.text(
          size: 13,
          weight: FontWeight.w400,
          color: HomeDesign.muted,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F6EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: HomeDesign.green),
          ),
        ),
        suffixIcon: trailing,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HomeDesign.green, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HomeDesign.expense),
        ),
      ),
    );
  }
}

class _StepBubble extends StatelessWidget {
  const _StepBubble({
    required this.index,
    required this.label,
    required this.icon,
    required this.active,
    required this.completed,
    required this.onTap,
  });

  final int index;
  final String label;
  final IconData icon;
  final bool active;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    if (completed || active) {
      bg = HomeDesign.green;
      fg = Colors.white;
    } else {
      bg = const Color(0xFFE5E7EB);
      fg = HomeDesign.muted;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: active ? 40 : 34,
            height: active ? 40 : 34,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: HomeDesign.green.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              completed && !active ? LucideIcons.check : icon,
              size: active ? 18 : 15,
              color: fg,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: HomeDesign.text(
              size: 11,
              weight: active ? FontWeight.w700 : FontWeight.w500,
              color: active || completed ? HomeDesign.green : HomeDesign.muted,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
