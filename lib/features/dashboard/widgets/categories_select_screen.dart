import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedha/common/button.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/common_widgets/error_lottie.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/create_category_form.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_category_card.dart';
import 'package:fedha/features/dashboard/components/planning/planning.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSelectScreen extends StatefulWidget {
  const CategoriesSelectScreen({super.key, required this.categorySelected});
  final int categorySelected;

  @override
  State<CategoriesSelectScreen> createState() => _CategoriesScreenState();
}

// ... rest of your code

class _CategoriesScreenState extends State<CategoriesSelectScreen> {
  @override
  Widget build(BuildContext context) {
    if (context.read<TransactionsBloc>().state.status ==
        ServiceStatus.initial) {
      context.read<TransactionsBloc>().add(StartTransactions());
    }
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            // title: Text(
            //   "Categories",
            //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //       fontSize: 18,
            //       color: AppColors.darkBlueColor,
            //       fontWeight: FontWeight.w700),
            // ),
            // centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ExpenseBloc>().add(RefreshExpense());
              context.read<IncomeBloc>().add(RefreshIncome());
            },
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).height,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Divider(
                          color: Colors.transparent,
                        ),
                        BlocBuilder<TransactionsBloc, TransactionsState>(
                          builder: (context, state) {
                            if (state.status == ServiceStatus.loading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            }
                            if (state.status == ServiceStatus.loadingFailure) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: LottieError(
                                  message: state.message?.message ??
                                      "An error occurred",
                                ),
                              );
                            }
                            return Container(
                              child: widget.categorySelected == 0
                                  ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: BlocBuilder<ExpenseBloc,
                                                ExpenseState>(
                                              builder: (context, state) {
                                                if (state.status ==
                                                    ServiceStatus.loading) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (state.status ==
                                                    ServiceStatus
                                                        .loadingFailure) {
                                                  return const Center(
                                                    child: Text(
                                                        "Failed to load categories"),
                                                  );
                                                }

                                                final budgets =
                                                    state.categories.data;

                                                if (budgets.isEmpty) {
                                                  return const Text(
                                                      "No categories found");
                                                }
                                                return Column(
                                                    children: List.generate(
                                                        state.categories.data
                                                            .length, (index) {
                                                  final category = state
                                                      .categories.data[index];
                                                  return PlannedPaymentCategoryCard(
                                                    onPressed: () {
                                                      // context.pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryDetailScreen(
                                                            category: category,
                                                            categoryType: context
                                                                .read<
                                                                    TransactionsBloc>()
                                                                .state
                                                                .categorySelected,
                                                            bgcolor: state
                                                                .colorManager
                                                                .getColorForCategory(
                                                                    category
                                                                        .name),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    bgColor: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                    icon: category.image,
                                                    text: category.name,
                                                    description:
                                                        "Mpesa-Every Month on 9th",
                                                    price: "-Ksh 1,530",
                                                  );
                                                }));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: BlocBuilder<IncomeBloc,
                                                IncomeState>(
                                              builder: (context, state) {
                                                if (state.status ==
                                                    ServiceStatus.loading) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (state.status ==
                                                    ServiceStatus
                                                        .loadingFailure) {
                                                  return const Center(
                                                    child: Text(
                                                        "Failed to load categories"),
                                                  );
                                                }

                                                final budgets =
                                                    state.incomeTypes;

                                                if (budgets.isEmpty) {
                                                  return const Text(
                                                      "No budgets categories");
                                                }
                                                return Column(
                                                    children: List.generate(
                                                        state.incomeTypes
                                                            .length, (index) {
                                                  final category =
                                                      state.incomeTypes[index];
                                                  return PlannedPaymentCategoryCard(
                                                    onPressed: () {
                                                      // context.pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryDetailScreen(
                                                            category: category,
                                                            categoryType: context
                                                                .read<
                                                                    TransactionsBloc>()
                                                                .state
                                                                .categorySelected,
                                                            bgcolor: state
                                                                .colorManager
                                                                .getColorForCategory(
                                                                    category
                                                                        .name),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    bgColor: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                    icon: getMaterialIcon(
                                                        category.name),
                                                    text: category.name,
                                                    description:
                                                        "Mpesa-Every Month on 9th",
                                                    price: "-Ksh 1,530",
                                                  );
                                                }));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future categoryDialog(Widget form, CategoryTypes categoryType, context) {
  MediaQueryData mq = MediaQuery.of(context);

  Widget form0 = form;
  // CategoryTypes categoryType0 = categoryType;

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        height: 160,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GreenButton(
              text: "Add Category",
              width: mq.size.width * 0.4,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return form0;
                    });

                Navigator.pop(context);
              },
            ),
            GreenButton(
              text: "New Category",
              width: mq.size.width * 0.4,
              onPressed: () {
                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: (context) => const Dialog(
                        insetPadding: EdgeInsets.all(16),
                        child: CreateCategory(
                          categoryType: "",
                        )));
              },
            )
          ],
        )),
      );
    },
  );
}
