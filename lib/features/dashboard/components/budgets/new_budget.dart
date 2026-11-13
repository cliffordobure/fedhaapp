import 'package:fedha/data/models/budgets/budget.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/budget/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NewBudgetScreen extends StatefulWidget {
  const NewBudgetScreen({Key? key}) : super(key: key);

  @override
  State<NewBudgetScreen> createState() => _NewBudgetScreenState();
}

class _NewBudgetScreenState extends State<NewBudgetScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _newBudgetTypeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FormBudgetType? selectedBudget;
  FormBudgetSpan? selectedBudgetSpan;

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
              child: Text("New Budget",
                  style: theme.titleMedium!.copyWith(
                      fontSize: 18,
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w700))),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color(0XFF555555),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                      if (state.status == ServiceStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      if (state.status == ServiceStatus.loadingFailure) {
                        return const Center(
                          child: Text("Failed to load budgets"),
                        );
                      }

                      final budgets = state.formBudgetTypes;

                      if (budgets.isEmpty) {
                        return const Text("No budgets listed");
                      }

                      // Ensure selectedBudget is a valid value
                      if (!budgets.contains(selectedBudget)) {
                        selectedBudget =
                            budgets.first; // or any other default value
                      }

                      return DropdownButtonFormField<FormBudgetType>(
                          value: selectedBudget,
                          items: [
                            ...budgets,
                            const FormBudgetType(
                                id: -1, name: "Other (Add New)")
                          ]
                              .map(
                                (e) => DropdownMenuItem<FormBudgetType>(
                                  value: e, // Set the value to the item
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            // Create a new budget type field
                            if (value!.name.toLowerCase().contains("other")) {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        insetPadding: const EdgeInsets.all(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Specify budget name",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              DefaultInputField(
                                                textEditingController:
                                                    _newBudgetTypeController,
                                                inputtype: TextInputType.text,
                                                title: 'Name',
                                                inputAction:
                                                    TextInputAction.done,
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
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                hintText: "Name of budget",
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  children: [
                                                    FullWidthButton(
                                                      action: () {
                                                        context
                                                            .read<BudgetBloc>()
                                                            .add(
                                                              NewBudgetType(
                                                                  name: _newBudgetTypeController
                                                                      .text
                                                                      .trim()),
                                                            );
                                                        // Close dialog
                                                        context.pop();
                                                      },
                                                      text: "Add Budget Type",
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                            "Dismiss"))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            } else {
                              setState(() {
                                selectedBudget = value;
                              });
                            }
                          },
                          validator: (value) {
                            if (selectedBudget == null || value == null) {
                              return "Please select a budget";
                            }
                            return null;
                          },
                          decoration: getDropDownDecoration(
                              context, true, "Select budget"));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Budget Type",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color(0XFF555555),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                      if (state.status == ServiceStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      if (state.status == ServiceStatus.loadingFailure) {
                        return const Center(
                          child: Text("Failed to load bills"),
                        );
                      }

                      final budgetSpans = state.formBudgetSpans;

                      if (budgetSpans.isEmpty) {
                        return const Text("No categories listed");
                      }

                      // Ensure selectedBudgetSpan is a valid value
                      if (!budgetSpans.contains(selectedBudgetSpan)) {
                        selectedBudgetSpan =
                            budgetSpans.first; // or any other default value
                      }

                      return DropdownButtonFormField<FormBudgetSpan>(
                          value: selectedBudgetSpan,
                          items: budgetSpans
                              .map((e) => DropdownMenuItem<FormBudgetSpan>(
                                    value: e, // Set the value to the item
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBudgetSpan = value;
                            });
                          },
                          validator: (value) {
                            if (selectedBudgetSpan == null || value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                          decoration: getDropDownDecoration(
                              context, true, "Select Budget span"));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DefaultInputField(
                    textEditingController: _amountController,
                    inputtype: TextInputType.number,
                    title: 'Amount',
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
                        print("on saved calles");
                      }
                    },
                    borderRadius: BorderRadius.circular(20.r),
                    hintText: "Amount in Ksh.",
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        FullWidthButton(
                          action: () {
                            final form = _formKey.currentState;

                            if (form!.validate()) {
                              context.read<BudgetBloc>().add(
                                    NewBudget({
                                      "budget_id": selectedBudget?.id,
                                      "amount": _amountController.text.trim(),
                                      "type": selectedBudgetSpan?.id
                                    }),
                                  );
                            }
                          },
                          text: "Create Budget",
                        ),
                        // TextButton(
                        //     onPressed: () {
                        //       context.pop();
                        //     },
                        //     child: const Text("Cancel"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
