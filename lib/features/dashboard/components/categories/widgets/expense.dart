import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget({super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  bool concealed = false;
  final TextEditingController _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (context.read<ExpenseBloc>().state.status == ServiceStatus.initial) {
      context.read<ExpenseBloc>().add(StartExpense());
    }
    return Column(children: [
      Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total Transactions",
              style: TextStyle(color: AppColors.whiteColor),
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      return RichText(
                        text: TextSpan(
                          text: "KES ",
                          children: [
                            TextSpan(
                              text: concealed
                                  ? "${state.total}"
                                      .replaceAll(RegExp(r'.'), '*')
                                  : formatAmount(state.total),
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      concealed = !concealed;
                      setState(() {});
                    },
                    icon: Icon(
                      concealed
                          ? CupertinoIcons.eye_slash_fill
                          : CupertinoIcons.eye_fill,
                      color: AppColors.whiteColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      // Search button
      Container(
        padding: const EdgeInsets.only(top: 16),
        margin: EdgeInsets.only(top: 0.h),
        child: TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          validator: (onValidateVal) {
            return null;
          },
          onSaved: (String? onSavedVal) {},
          onChanged: (value) {
            context.read<ExpenseBloc>().add(FilterExpense(keyword: value));
          },
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 6.sp,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
            suffixIcon: _searchController.text.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: 5.h),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 25.h,
                        color: const Color(0xff919191),
                      ),
                      onPressed: () {
                        // Clear search field
                        _searchController.text = "";
                        setState(() {});
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 5.h),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 25.h,
                        color: const Color(0xff919191),
                      ),
                      onPressed: () {
                        // Clear search field
                        _searchController.text = "";
                        setState(() {});
                      },
                    ),
                  ),
            helperText: "",
            hintText: "Search all expenses",
            hintStyle: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.black26),
            fillColor: Colors.grey.withOpacity(.1),
          ),
        ),
      ),

      BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state.status == ServiceStatus.loading) {
            return Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).width -
                      AppBar().preferredSize.height),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          }
          if (state.status == ServiceStatus.loadingFailure) {
            return Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).width -
                      AppBar().preferredSize.height),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text("Failed to load income data"),
              ),
            );
          }

          return state.expenses.data.isNotEmpty
              ? ExpenseCategoryList(
                  data: state.filteredExpenses.data,
                )
              : const Center(
                  child: Text("No transactions found"),
                );
        },
      ),
      const SizedBox(
        height: 32,
      )
    ]);
  }
}

// expense list data
class ExpenseCategoryList extends StatefulWidget {
  const ExpenseCategoryList({super.key, required this.data});
  final List<category.Category> data;

  @override
  State<ExpenseCategoryList> createState() => _ExpenseCategoryListState();
}

class _ExpenseCategoryListState extends State<ExpenseCategoryList> {
  int opened = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.data.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: ExpansionTile(
            shape: const Border(),
            initiallyExpanded: index == opened,
            backgroundColor: Colors.white,
            onExpansionChanged: (value) {
              if (value) {
                setState(() {
                  opened = index;
                });
              }
            },
            tilePadding: EdgeInsets.zero,
            title: Text(widget.data[index].name),
            children: const [
              // ListView.separated(
              //   padding: const EdgeInsets.symmetric(vertical: 0),
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: widget.data[index].transactions.take(10).length,
              //   itemBuilder: (context, index_) => TransactionTile(
              //     transaction:
              //         widget.data[index].transactions.take(10).toList()[index_],
              //     onTapCallback: () {
              //       // show categorize dialog
              //       showDialog(
              //           context: context,
              //           builder: (context) {
              //             return CategoriseExpenseWidget(
              //               category: widget.data[index],
              //               transaction: widget.data[index].transactions
              //                   .take(10)
              //                   .toList()[index_],
              //             );
              //           });
              //     },
              //   ),
              //   separatorBuilder: (context, nIndex) =>
              //       Divider(color: AppColors.greyColor),
              // ),
              // widget.data[index].transactions.length > 10
              //     ? Align(
              //         alignment: Alignment.centerRight,
              //         child: TextButton(
              //           style: const ButtonStyle(
              //               padding: MaterialStatePropertyAll(
              //                   EdgeInsets.symmetric(vertical: 8))),
              //           onPressed: () {
              //             context.pushNamed(Routes.categoryExpenses,
              //                 extra: widget.data[index]);
              //           },
              //           child: const Text("View all"),
              //         ),
              //       )
              //     : const SizedBox.shrink()
            ]),
      ),
    );
  }
}

class CategoriseExpenseWidget extends StatefulWidget {
  const CategoriseExpenseWidget(
      {super.key, required this.category_, required this.transaction});
  final category.Category category_;
  final Transaction transaction;

  @override
  State<CategoriseExpenseWidget> createState() =>
      _CategoriseExpenseWidgetState();
}

class _CategoriseExpenseWidgetState extends State<CategoriseExpenseWidget> {
  late category.Category? category_;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
// Initialize category with the category passed
    setState(() {
      category_ = widget.category_;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Update Expense category",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              // Expense categories
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  return DropdownButtonFormField<category.Category>(
                    value: category_,
                    items: state.expenses.data
                        .map(
                          (e) => DropdownMenuItem<category.Category>(
                            value: e, // Set the value to the item
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        category_ = value;
                      });
                    },
                    validator: (value) {
                      if (category_ == null || value == null) {
                        return "Please pick a category";
                      }
                      return null;
                    },
                    decoration:
                        getDropDownDecoration(context, true, "Select category"),
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    FullWidthButton(
                      action: () {
                        final form = _formKey.currentState;

                        if (form!.validate()) {
                          form.save();
                          context.read<ExpenseBloc>().add(CategoriseExpense(
                              transaction: widget.transaction.transactionId,
                              category: category_!.id));
                          // close dialog
                          context.pop();
                        } else {
                          showError("Please select a category!");
                        }
                      },
                      text: "Save category",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
