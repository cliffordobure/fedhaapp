import 'package:fedha/common/category_logo.dart';
import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/models/categories/categories.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/create_subcategory.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../planning/planned_payment/widgets/planned_payment_card.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen(
      {super.key,
      required this.category,
      required this.categoryType,
      required this.bgcolor});
  final Category category;
  final int categoryType;
  final Color bgcolor;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryType == 0) {
      context.read<ExpenseBloc>().add(LoadCategories());
    } else {
      context.read<IncomeBloc>().add(FetchIncomeTypes());
    }
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        if (widget.categoryType == 0) {
          context.read<ExpenseBloc>().add(LoadCategories());
        } else {
          context.read<IncomeBloc>().add(FetchIncomeTypes());
        }
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/Images/Background.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(CupertinoIcons.back)),
              backgroundColor: Colors.transparent,
              title: Text(
                widget.category.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: widget.bgcolor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: widget.category.image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: CategoryLogoImage(
                                              imageUrl: widget.category.image,
                                              width: 30,
                                              height: 30,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          )),
                                // Positioned(
                                //   right: 0,
                                //   bottom: 0,
                                //   child: GestureDetector(
                                //     onTap: () {},
                                //     child: Container(
                                //       padding: const EdgeInsets.all(2),
                                //       decoration: const BoxDecoration(
                                //         color: Colors.white,
                                //         shape: BoxShape.circle,
                                //       ),
                                //       child: const Icon(
                                //         Icons.edit,
                                //         size: 14,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.category.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Text("Sub-Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                insetPadding: const EdgeInsets.all(16),
                                child: CreateSubCategory(
                                  category: widget.category.id,
                                  categoryType: widget.categoryType,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryColor),
                            height: 25,
                            width: 50,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.category.subcategories.isEmpty)
                      const Center(child: Text("No Subcategories found")),
                    if (widget.category.subcategories.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                            height: 200, // Set a fixed height for the SizedBox
                            child: _buildSubcategoryList()),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSubcategoryList() {
    if (widget.categoryType == 1) {
      // Income category
      return BlocBuilder<IncomeBloc, IncomeState>(
        builder: (context, state) {
          if (state.formStatus == ServiceStatus.loading) {
            return const Center(
              child: SizedBox(child: LogoLoader()),
            );
          }
          if (state.formStatus == ServiceStatus.loadingFailure) {
            return const Center(
              child: Text("Failed to load subcategories"),
            );
          }

          final subcategories = widget.category.subcategories;

          if (subcategories.isEmpty) {
            return const Text("There are no saved subcategories");
          }

          debugPrint("This is the categoryType: ${widget.categoryType}");
          Category? categoryWithId = state.incomeTypes.firstWhere(
            (category) => category.id == widget.category.id,
          );

          return ListView.builder(
            itemCount: categoryWithId.subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = categoryWithId.subcategories[index];
              return PlannedPaymentCard(
                onPressed: () {
                  // TODO: Add an action for subcategory
                },
                subcategory: subcategory,
                displayCard: true,
                bgColor: AppColors.primaryColor.withOpacity(0.3),
                icon: Icons.category,
                text: subcategory.name,
                description: subcategory.name,
                price: "",
                category: widget.category.id,
                categoryType: widget.categoryType,
              );
            },
          );
        },
      );
    } else {
      // Expense category
      return BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
        if (state.formStatus == ServiceStatus.loading) {
          return const Center(
            child: SizedBox(child: LogoLoader()),
          );
        }
        if (state.formStatus == ServiceStatus.loadingFailure) {
          return const Center(
            child: Text("Failed to load subcategories"),
          );
        }

        final subcategories = widget.category.subcategories;

        if (subcategories.isEmpty) {
          return const Text("There are no saved subcategories");
        }
        Category? categoryWithId = state.categories.data.firstWhere(
          (category) => category.id == widget.category.id,
        );

        return ListView.builder(
          itemCount: categoryWithId.subcategories.length,
          itemBuilder: (context, index) {
            final subcategory = categoryWithId.subcategories[index];
            return PlannedPaymentCard(
              onPressed: () {
                // TODO: Add an action for subcategory
              },
              subcategory: subcategory,
              displayCard: true,
              bgColor: AppColors.primaryColor.withOpacity(0.3),
              icon: LucideIcons.wifi,
              text: subcategory.name,
              description: subcategory.name,
              price: "",
              category: widget.category.id,
              categoryType: widget.categoryType,
            );
          },
        );
      });
    }
  }
}
