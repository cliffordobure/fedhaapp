import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/categories/categories.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  Wallet? selectedWallet;
  Category? category;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<WalletsBloc>().state.status == ServiceStatus.initial) {
      context.read<WalletsBloc>().add(StartWalletBloc());
    }
    if (context.read<ExpenseBloc>().state.categories.data.isEmpty) {
      context.read<ExpenseBloc>().add(LoadCategories());
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
                        "Add Expense Category",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: theme.displayMedium!.copyWith(
                          color: const Color(0XFF555555),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        if (state.formStatus == ServiceStatus.loading) {
                          return const CircularProgressIndicator();
                        }
                        if (state.formStatus == ServiceStatus.loadingFailure) {
                          return const Center(
                            child: Text("Failed to load categories"),
                          );
                        }

                        final categories = state.categories;

                        if (categories.data.isEmpty) {
                          return const Text("There are no saved categories");
                        }

                        // Ensure selectedWallet is a valid value
                        if (!categories.data.contains(category)) {
                          category = categories
                              .data.first; // or any other default value
                        }

                        return DropdownButtonFormField<Category>(
                            value: category,
                            items: categories.data
                                .map((e) => DropdownMenuItem<Category>(
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
                                category = value;
                              });
                            },
                            validator: (value) {
                              if (category == null || value == null) {
                                return "Please select a expense category";
                              }
                              return null;
                            },
                            decoration: getDropDownDecoration(
                                context, true, "Select category"));
                      },
                    )
                  ],
                ),
                Container(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "wallet",
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
                              context.read<ExpenseBloc>().add(SaveCategory(
                                      formData: {
                                        "expense_id": category!.id,
                                        "wallet_id": selectedWallet!.bankId
                                      }));
                              context.pop();
                            } else {
                              showError("Fill form correctly");
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
