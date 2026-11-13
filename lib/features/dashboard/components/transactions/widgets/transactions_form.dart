import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/string_utils.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  Wallet? selectedWallet;

  dynamic selectedCategoryIncome;
  dynamic selectedCategoryExpence;

  late String type;
  List<String> transactionTypes = ["Income", "Expense"];

  @override
  void initState() {
    type = transactionTypes.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "This is the status of categories ${context.read<IncomeBloc>().state.status}");
    debugPrint(
        "This is the status of categories ${context.read<ExpenseBloc>().state.status}");
    if (context.read<IncomeBloc>().state.status == ServiceStatus.initial) {
      context.read<IncomeBloc>().add(StartIncome());
    }
    if (context.read<ExpenseBloc>().state.status == ServiceStatus.initial) {
      context.read<ExpenseBloc>().add(StartExpense());
    }
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add new transaction",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 16,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transaction Type",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: const Color(0XFF555555),
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<String>(
                            value: type,
                            items: transactionTypes
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e, // Set the value to the item
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                type = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please select a category";
                              }
                              return null;
                            },
                            decoration: getDropDownDecoration(
                                context, true, "Select Type")),
                      ],
                    ),
                    Text(
                      "Category",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: const Color(0XFF555555),
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    type == transactionTypes.first
                        ? BlocBuilder<IncomeBloc, IncomeState>(
                            builder: (context, state) {
                              debugPrint(state.income.toString());

                              // if (state.status == ServiceStatus.loading) {
                              //   return const CircularProgressIndicator();
                              // }
                              // if (state.status ==
                              //     ServiceStatus.loadingFailure) {
                              //   return const Center(
                              //     child: Text("Failed to load categories"),
                              //   );
                              // }
                              return DropdownButtonFormField<category.Category>(
                                value: selectedCategoryIncome,
                                items: state.incomeTypes
                                    .map(
                                      (e) =>
                                          DropdownMenuItem<category.Category>(
                                        value: e, // Set the value to the item
                                        child: SizedBox(
                                          width: 250,
                                          child: Text(e.name),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategoryIncome = value;
                                  });
                                },
                                validator: (value) {
                                  if (selectedCategoryIncome == null ||
                                      value == null) {
                                    return "Please select a category";
                                  }
                                  return null;
                                },
                                decoration: getDropDownDecoration(
                                    context, true, "Select income category"),
                              );
                            },
                          )
                        : BlocBuilder<ExpenseBloc, ExpenseState>(
                            builder: (context, state) {
                              debugPrint(state.expenses.toString());

                              // if (state.status == ServiceStatus.loading) {
                              //   return const CircularProgressIndicator();
                              // }
                              // if (state.status ==
                              //     ServiceStatus.loadingFailure) {
                              //   return const Center(
                              //     child: Text("Failed to load categories"),
                              //   );
                              // }
                              return DropdownButtonFormField<category.Category>(
                                  value: selectedCategoryExpence,
                                  items: state.categories.data
                                      .map(
                                        (e) =>
                                            DropdownMenuItem<category.Category>(
                                          value: e, // Set the value to the item
                                          child: Text(e.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategoryExpence = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (selectedCategoryExpence == null ||
                                        value == null) {
                                      return "Please select a category";
                                    }
                                    return null;
                                  },
                                  decoration: getDropDownDecoration(context,
                                      true, "Select expense category"));
                            },
                          )
                  ],
                ),

                // Transaction name
                DefaultInputField(
                  inputAction: TextInputAction.done,
                  textEditingController: _nameController,
                  title: 'Name',
                  hide: false,
                  validator: (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Transaction name is required";
                    }
                    return null;
                  },
                  onSaved: (onSavedVal) {},
                  hintText: "Mama mboga X",
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Associated wallet",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: const Color(0XFF555555),
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<WalletsBloc, WalletsState>(
                      builder: (context, state) {
                        if (state.status == ServiceStatus.loading) {
                          return const CircularProgressIndicator();
                        }
                        if (state.status == ServiceStatus.loadingFailure) {
                          return const Center(
                            child: Text("Failed to load wallets"),
                          );
                        }

                        final wallets = state.wallets;

                        if (wallets.isEmpty) {
                          return const Text("You don't have any saved wallet");
                        }

                        // Ensure selectedWallet is a valid value
                        if (!wallets.contains(selectedWallet)) {
                          selectedWallet =
                              wallets.first; // or any other default value
                        }

                        return DropdownButtonFormField<Wallet>(
                            value: selectedWallet,
                            items: wallets
                                .map((e) => DropdownMenuItem<Wallet>(
                                      value: e, // Set the value to the item
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.greyColor,
                                                    width: 1),
                                                shape: BoxShape.circle),
                                            child: ClipOval(
                                              child: BankLogoImage(
                                                name: e.name,
                                                shortname: e.shortname,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            e.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(color: Colors.black),
                                          )
                                        ],
                                      ),
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
                            decoration: getDropDownDecoration(
                                context, true, "Select wallet"));
                      },
                    )
                  ],
                ),
                DefaultInputField(
                  inputAction: TextInputAction.done,
                  textEditingController: _codeController,
                  inputtype: TextInputType.name,
                  // ignore: unrelated_type_equality_checks
                  title: selectedWallet != Null
                      ? selectedWallet?.institutionName == "M-Pesa"
                          ? "Transaction code"
                          : "Reference code"
                      : "Transaction code",
                  hide: false,
                  validator: (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return null;
                    } else {
                      if (onValidateVal!.length < 10 ||
                          onValidateVal.length > 12) {
                        return 'Invalid Code. ';
                      }
                      if (!RegExp(r"^[a-zA-Z]").hasMatch(onValidateVal!)) {
                        return 'Invalid Code .';
                      }

                      if (RegExp(r"[^\w_ ]").hasMatch(onValidateVal!)) {
                        return 'cannot contain special characters.';
                      }
                    }

                    return null;
                  },
                  onSaved: (onSavedVal) {},
                  hintText: "HKJHDKKJSD",
                ),
                Row(
                  children: [
                    // Amount
                    Expanded(
                      child: DefaultInputField(
                        inputAction: TextInputAction.done,
                        textEditingController: _amountController,
                        inputtype: TextInputType.number,
                        title: 'Amount',
                        hide: false,
                        validator: (onValidateVal) {
                          if (onValidateVal.isEmpty) {
                            return "Transaction amount is required";
                          }
                          return null;
                        },
                        onSaved: (onSavedVal) {},
                        hintText: "1000",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    // Charges
                    Expanded(
                      child: DefaultInputField(
                        inputAction: TextInputAction.done,
                        textEditingController: _chargesController,
                        inputtype: TextInputType.number,
                        title: 'Charges',
                        hide: false,
                        validator: (onValidateVal) {
                          if (onValidateVal.isEmpty) {
                            return "Transaction charges is required";
                          }
                          return null;
                        },
                        onSaved: (onSavedVal) {},
                        hintText: "10",
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            // validate form
                            final form = _formKey.currentState;
                            if (form!.validate() && selectedWallet != null) {
                              context.read<TransactionsBloc>().add(
                                    UploadTransaction(
                                      data: TransactionData(
                                          categoryId:
                                              type == transactionTypes.first
                                                  ? selectedCategoryIncome.id
                                                  : selectedCategoryExpence.id,
                                          name: _nameController.text,
                                          wallet: selectedWallet!.id,
                                          amount: double.parse(
                                              _amountController.text),
                                          code: _codeController.text != ""
                                              ? _codeController.text
                                              : generateRandomString()
                                                  .toUpperCase(),
                                          charges: double.parse(
                                              _chargesController.text),
                                          datetime: DateTime.now(),
                                          type: type.toLowerCase() == "income"
                                              ? "credit"
                                              : "debit"),
                                    ),
                                  );
                              // close the dialog
                              context.pop();
                            } else {
                              showError("Fill the form correctly");
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: AppColors.whiteColor),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
