import 'package:fedha/features/dashboard/components/categories/category_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/common/button.dart';
import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/common_widgets/error_lottie.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/create_category_form.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_category_card.dart';
import 'package:fedha/theme/theme_constants.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.initial) {
          context.read<TransactionsBloc>().add(StartTransactions());
        }
        context.read<IncomeBloc>().add(FetchIncomeTypes());
        context.read<ExpenseBloc>().add(LoadCategories());

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ExpenseBloc>().add(RefreshExpense());
              context.read<IncomeBloc>().add(RefreshIncome());
            },
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        "Categories",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
            ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, TransactionsState state) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildCategoryToggle(context, state),
            const Divider(color: Colors.transparent),
            _buildCategoryList(context, state),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryToggle(BuildContext context, TransactionsState state) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildToggleButton(
              context, "Expense", 0, state.categorySelected == 0),
          _buildToggleButton(context, "Income", 1, state.categorySelected == 1),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      BuildContext context, String text, int index, bool isSelected) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context
              .read<TransactionsBloc>()
              .add(ToggleCategorySelected(selected: index));
        },
        child: Card(
          elevation: 0,
          color: isSelected ? AppColors.whiteColor : Colors.transparent,
          margin: EdgeInsets.zero,
          shape: const StadiumBorder(
              side: BorderSide(color: Colors.transparent, width: .5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, TransactionsState state) {
    if (state.status == ServiceStatus.loading) {
      return const Center(child: LogoLoader());
    }
    if (state.status == ServiceStatus.loadingFailure) {
      return _buildErrorWidget(state.message?.message ?? "An error occurred");
    }
    return state.categorySelected == 2 || state.categorySelected == 0
        ? _buildExpenseCategories(context)
        : _buildIncomeCategories(context);
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LottieError(message: message),
    );
  }

  Widget _buildExpenseCategories(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return const LogoLoader();
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(child: Text("Failed to load categories"));
        }
        if (state.categories.data.isEmpty) {
          return const Text("No categories found");
        }
        return Column(
          children: state.categories.data
              .map(
                  (category) => _buildCategoryCard(context, category, 0, state))
              .toList(),
        );
      },
    );
  }

  Widget _buildIncomeCategories(BuildContext context) {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return const LogoLoader();
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(child: Text("Failed to load categories"));
        }
        if (state.incomeTypes.isEmpty) {
          return const Text("No income categories");
        }
        return Column(
          children: state.incomeTypes
              .map(
                  (category) => _buildCategoryCard(context, category, 1, state))
              .toList(),
        );
      },
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, dynamic category, int categoryType, Object state) {
    Color bgColor;

    // Check if state is IncomeState or ExpenseState and handle accordingly
    if (state is IncomeState) {
      bgColor = state.colorManager.getColorForCategory(category.name);
    } else if (state is ExpenseState) {
      bgColor = state.colorManager.getColorForCategory(category.name);
    } else {
      bgColor = Colors.grey; // Fallback color in case of an unexpected state
    }

    return PlannedPaymentCategoryCard(
      onPressed: () =>
          _navigateToCategoryDetail(context, category, categoryType, bgColor),
      bgColor: bgColor,
      icon: category.image ?? getMaterialIcon(category.name),
      text: category.name,
      description: "Mpesa-Every Month on 9th",
      price: "-Ksh 1,530",
    );
  }

  void _navigateToCategoryDetail(
      BuildContext context, dynamic category, int categoryType, Color bgcolor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(
          bgcolor: bgcolor,
          category: category,
          categoryType: categoryType,
        ),
      ),
    );
  }
}

Future<void> categoryDialog(
    Widget form, CategoryTypes categoryType, BuildContext context) async {
  MediaQueryData mq = MediaQuery.of(context);

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        height: 160,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDialogButton(context, "Add Category", mq.size.width * 0.4,
                  () {
                Navigator.pop(context);
                showDialog(
                    context: context, builder: (BuildContext context) => form);
              }),
              _buildDialogButton(context, "New Category", mq.size.width * 0.4,
                  () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                    insetPadding: EdgeInsets.all(16),
                    child: CreateCategory(categoryType: ""),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDialogButton(
    BuildContext context, String text, double width, VoidCallback onPressed) {
  return GreenButton(
    text: text,
    width: width,
    onPressed: onPressed,
  );
}
