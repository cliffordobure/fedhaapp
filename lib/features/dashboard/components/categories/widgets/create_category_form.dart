import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

enum CategoryTypes { income, expense }

class CreateCategory extends StatelessWidget {
  final String categoryType;
  const CreateCategory({super.key, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    final TextEditingController newCategoryTypeController =
        TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Specify Category",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          DefaultInputField(
            textEditingController: newCategoryTypeController,
            inputtype: TextInputType.text,
            title: 'Name',
            inputAction: TextInputAction.done,
            hide: false,
            validator: (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Name";
              }
              return null;
            },
            onSaved: (String? onSavedVal) {
              if (kDebugMode) {
                print("on saved calles");
              }
            },
            borderRadius: BorderRadius.circular(20.r),
            hintText: "Name of Category",
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                FullWidthButton(
                  action: () async {
                    categoryType == CategoryTypes.expense
                        ? context.read<ExpenseBloc>().add(SaveCategory(
                                formData: {
                                  "name": newCategoryTypeController.text.trim()
                                }))
                        : context.read<IncomeBloc>().add(SaveIncome(formData: {
                              "name": newCategoryTypeController.text.trim()
                            }));

                    context.pop();
                  },
                  text: "Create Category",
                ),
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("Dismiss"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
