import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;

class IncomeForm extends StatefulWidget {
  const IncomeForm({Key? key}) : super(key: key);

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  Wallet? selectedWallet;
  category_.Category? incomeType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<WalletsBloc>().state.status == ServiceStatus.initial) {
      context.read<WalletsBloc>().add(StartWalletBloc());
    }

    if (context.read<IncomeBloc>().state.incomeTypes.isEmpty) {
      context.read<IncomeBloc>().add(FetchIncomeTypes());
    }

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        // height: 350,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Income Category",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                // Start
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Income type",
                      style: theme.displayMedium!.copyWith(
                          color: const Color(0XFF555555),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<IncomeBloc, IncomeState>(
                      builder: (context, state) {
                        if (state.formStatus == ServiceStatus.loading) {
                          return const CircularProgressIndicator();
                        }
                        if (state.formStatus == ServiceStatus.loadingFailure) {
                          return const Center(
                            child: Text("Failed to load income types"),
                          );
                        }

                        final incomes = state.incomeTypes;

                        if (incomes.isEmpty) {
                          return const Text("No income type found");
                        }

                        // Ensure selectedWallet is a valid value
                        if (!incomes.contains(incomeType)) {
                          incomeType =
                              incomes.first; // or any other default value
                        }

                        return DropdownButtonFormField<category_.Category>(
                            value: incomeType,
                            items: incomes
                                .map((e) =>
                                    DropdownMenuItem<category_.Category>(
                                      value: e, // Set the value to the item
                                      child: Row(
                                        children: [
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
                                incomeType = value;
                              });
                            },
                            validator: (value) {
                              if (incomeType == null || value == null) {
                                return "Please select a income category";
                              }
                              return null;
                            },
                            decoration: getDropDownDecoration(
                                context, true, "Select income type"));
                      },
                    )
                  ],
                ),
                Container(
                  height: 16,
                ),

                // Wallets combobox
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Associated wallet",
                      style: theme.displayMedium!.copyWith(
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
                Container(
                  height: 16,
                ),

                // End
                DefaultInputField(
                    textEditingController: _descriptionController,
                    hintText: "Income Information",
                    inputAction: TextInputAction.done,
                    title: "Description"),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              context
                                  .read<IncomeBloc>()
                                  .add(SaveIncome(formData: {
                                    "income_id": incomeType!.id,
                                    "description":
                                        _descriptionController.text.trim(),
                                    "wallet_id": selectedWallet!.bankId
                                  }));
                              context.pop();
                            }
                          },
                          child: Text(
                            "Add Category",
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
