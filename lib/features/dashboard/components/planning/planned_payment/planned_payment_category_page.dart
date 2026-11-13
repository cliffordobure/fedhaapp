import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/budget/bloc.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_payement_bottomsheet.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/planned_category_card.dart';

class PlannedPaymentCategoryScreen extends StatefulWidget {
  const PlannedPaymentCategoryScreen({super.key});

  @override
  State<PlannedPaymentCategoryScreen> createState() =>
      _PlannedPaymentCategoryScreenState();
}

class _PlannedPaymentCategoryScreenState
    extends State<PlannedPaymentCategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(NewBudgetForm());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state.status == ServiceStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == ServiceStatus.loadingFailure) {
                      return const Center(
                          child: Text("Failed to load categories"));
                    }

                    final budgets = state.categories.data;

                    if (budgets.isEmpty) {
                      return const Center(child: Text("No budgets categories"));
                    }

                    return Column(
                      children: List.generate(budgets.length, (index) {
                        final category = budgets[index];
                        return PlannedPaymentCategoryCard(
                          onPressed: () {
                            context.pop();
                            showModalBottomSheet(
                              showDragHandle: true,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) => FractionallySizedBox(
                                heightFactor: 0.83,
                                child: NewPlannedPaymentBottomSheet(
                                  category: category.name,
                                ),
                              ),
                            );
                          },
                          bgColor: AppColors.primaryColor.withOpacity(0.3),
                          icon: getMaterialIcon(category.name),
                          text: category.name,
                          description: "Mpesa-Every Month on 9th",
                          price: "-Ksh 1,530",
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
