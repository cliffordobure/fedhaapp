import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;

class IncomeWidget extends StatefulWidget {
  const IncomeWidget({
    super.key,
  });

  @override
  State<IncomeWidget> createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends State<IncomeWidget> {
  bool concealed = false;
  final TextEditingController _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (context.read<IncomeBloc>().state.status == ServiceStatus.initial) {
      context.read<IncomeBloc>().add(StartIncome());
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
                  BlocBuilder<IncomeBloc, IncomeState>(
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
            context.read<IncomeBloc>().add(FilterIncome(keyword: value));
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
            hintText: "Search all incomes",
            hintStyle: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.black26),
            fillColor: Colors.grey.withOpacity(.1),
          ),
        ),
      ),

      BlocBuilder<IncomeBloc, IncomeState>(
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

          return state.income.isNotEmpty
              ? IncomeCategoryList(
                  data: state.filteredIncome,
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

// Income category list
class IncomeCategoryList extends StatefulWidget {
  const IncomeCategoryList({super.key, required this.data});
  final List<category_.Category> data;

  @override
  State<IncomeCategoryList> createState() => _IncomeCategoryListState();
}

class _IncomeCategoryListState extends State<IncomeCategoryList> {
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
              //             return CategoriseIncomeWidget(
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
              //             style: const ButtonStyle(
              //                 padding: MaterialStatePropertyAll(
              //                     EdgeInsets.symmetric(vertical: 8))),
              //             onPressed: () {
              //               context.pushNamed(Routes.categoryIncome,
              //                   extra: widget.data[index]);
              //             },
              //             child: const Text("View all")),
              //       )
              //     : const SizedBox.shrink()
            ]),
      ),
    );
  }
}

class CategoriseIncomeWidget extends StatefulWidget {
  const CategoriseIncomeWidget(
      {super.key, required this.category, required this.transaction});
  final category_.Category category;
  final Transaction transaction;

  @override
  State<CategoriseIncomeWidget> createState() => _CategoriseIncomeWidgetState();
}

class _CategoriseIncomeWidgetState extends State<CategoriseIncomeWidget> {
  late category_.Category? category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
// Initialize category with the category passed
    setState(() {
      category = widget.category;
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
                "Update Income category",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              // Expense categories
              BlocBuilder<IncomeBloc, IncomeState>(
                builder: (context, state) {
                  return DropdownButtonFormField<category_.Category>(
                    value: category,
                    items: state.income
                        .map(
                          (e) => DropdownMenuItem<category_.Category>(
                            value: e, // Set the value to the item
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                    validator: (value) {
                      if (category == null || value == null) {
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
                          context.read<IncomeBloc>().add(CategoriseIncome(
                              transaction: widget.transaction.transactionId,
                              category: category!.id));
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
