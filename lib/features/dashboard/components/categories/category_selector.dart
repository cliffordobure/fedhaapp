import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelectionWidget extends StatefulWidget {
  final TransactionType transactionType;
  final Function(category.Category?) onCategorySelected;

  const CategorySelectionWidget({
    Key? key,
    required this.transactionType,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  category.Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return widget.transactionType == TransactionType.debit
        ? BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              return _buildCategoryList(state.categories.data);
            },
          )
        : BlocBuilder<IncomeBloc, IncomeState>(
            builder: (context, state) {
              return _buildCategoryList(state.incomeTypes);
            },
          );
  }

  Widget _buildCategoryList(List<category.Category> categories) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: categories.map((e) => _buildCategoryItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(category.Category category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          widget.onCategorySelected(category);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CategoryLogoImage(
                  imageUrl: category.image,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 8),
              Text(category.name),
              const Spacer(),
              Radio<int>(
                value: category.id,
                groupValue: selectedCategory?.id,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}