import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NewGoalsBottomSheet extends StatefulWidget {
  const NewGoalsBottomSheet({Key? key}) : super(key: key);

  @override
  State<NewGoalsBottomSheet> createState() => _NewGoalsBottomSheetState();
}

class _NewGoalsBottomSheetState extends State<NewGoalsBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _desiredTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Color> colors = [
    AppColors.primaryColor,
    const Color(0xFFE91E63),
    const Color(0xFFF9A825),
    const Color(0xFF1E88E5),
    const Color(0xFFFB8C00),
    AppColors.darkBlueColor,
  ];

  DateTime selectedDate = DateTime.now();
  int _selectedColor = 0;
  bool reminder = true;
  IconData _selectedIcon = Icons.directions_car;

  final List<IconData> _iconOptions = const [
    Icons.directions_car,
    Icons.home,
    Icons.flight,
    Icons.school,
    Icons.savings,
    Icons.favorite,
    Icons.phone_iphone,
    Icons.laptop,
    Icons.shopping_bag,
    Icons.fitness_center,
    Icons.pets,
    Icons.celebration,
    Icons.emoji_events,
    Icons.account_balance,
    Icons.local_hospital,
    Icons.restaurant,
  ];

  @override
  void initState() {
    super.initState();
    _desiredTimeController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _desiredTimeController.dispose();
    super.dispose();
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
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
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
            DateFormat('yyyy-MM-dd').format(pickerDate);
      });
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final hexCode =
        colors[_selectedColor].value.toRadixString(16).padLeft(8, '0');

    context.read<GoalsBloc>().add(
          AddGoalsEvent({
            'name': _goalNameController.text.trim(),
            'desired_date': _desiredTimeController.text.trim(),
            'target_amount':
                double.tryParse(_targetAmountController.text.trim()),
            'amount_saved': double.tryParse(_amountController.text.trim()),
            'color': hexCode,
            'icon': _selectedIcon.toString(),
          }),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Keyboard inset is applied by the sheet opener (like planned payments).
    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'New goal',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.darkBlueColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: AppColors.fadeBlackColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set a target and track your progress',
                        style: TextStyle(
                          color: AppColors.fadeBlackColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      DefaultInputField(
                        textEditingController: _goalNameController,
                        inputtype: TextInputType.name,
                        title: 'Goal name',
                        inputAction: TextInputAction.next,
                        hide: false,
                        validator: (v) =>
                            v.isEmpty ? 'Name is required' : null,
                        onSaved: (_) {},
                        borderRadius: BorderRadius.circular(12),
                        hintText: 'e.g. Emergency fund, New car',
                      ),
                      const SizedBox(height: 8),
                      DefaultInputField(
                        textEditingController: _desiredTimeController,
                        inputtype: TextInputType.text,
                        title: 'Target date',
                        inputAction: TextInputAction.next,
                        hide: false,
                        readOnly: true,
                        onTap: _pickDate,
                        suffix: IconButton(
                          onPressed: _pickDate,
                          icon: Icon(
                            LucideIcons.calendar,
                            color: AppColors.fadeBlackColor,
                            size: 18,
                          ),
                        ),
                        validator: (v) =>
                            v.isEmpty ? 'Date is required' : null,
                        onSaved: (_) {},
                        borderRadius: BorderRadius.circular(12),
                        hintText: 'Select date',
                      ),
                      const SizedBox(height: 8),
                      DefaultInputField(
                        textEditingController: _targetAmountController,
                        inputtype: TextInputType.number,
                        title: 'Target amount (KES)',
                        inputAction: TextInputAction.next,
                        hide: false,
                        validator: (v) =>
                            v.isEmpty ? 'Target amount is required' : null,
                        onSaved: (_) {},
                        borderRadius: BorderRadius.circular(12),
                        hintText: '0',
                      ),
                      const SizedBox(height: 8),
                      DefaultInputField(
                        textEditingController: _amountController,
                        inputtype: TextInputType.number,
                        title: 'Already saved (KES)',
                        inputAction: TextInputAction.done,
                        hide: false,
                        validator: (v) =>
                            v.isEmpty ? 'Saved amount is required' : null,
                        onSaved: (_) {},
                        borderRadius: BorderRadius.circular(12),
                        hintText: '0',
                      ),
                      const SizedBox(height: 12),
                      _sectionLabel('Color'),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(colors.length, (index) {
                          final selected = _selectedColor == index;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedColor = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.darkBlueColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors[index].withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      _sectionLabel('Icon'),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.45),
                          ),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _iconOptions.map((icon) {
                            final selected = _selectedIcon == icon;
                            return InkWell(
                              onTap: () =>
                                  setState(() => _selectedIcon = icon),
                              borderRadius: BorderRadius.circular(10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 42,
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? colors[_selectedColor].withOpacity(0.15)
                                      : AppColors.scaffoldBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? colors[_selectedColor]
                                        : AppColors.greyColor.withOpacity(0.35),
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  size: 20,
                                  color: selected
                                      ? colors[_selectedColor]
                                      : AppColors.darkColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Send reminders to stay on track',
                                style: TextStyle(
                                  color: AppColors.darkBlueColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Switch.adaptive(
                              value: reminder,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value) {
                                setState(() => reminder = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                  top: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.35),
                  ),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Discard',
                      style: TextStyle(color: AppColors.fadeBlackColor),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.whiteColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add goal'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.darkBlueColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
