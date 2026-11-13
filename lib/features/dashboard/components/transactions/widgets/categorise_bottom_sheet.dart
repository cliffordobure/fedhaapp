import 'package:easy_stepper/easy_stepper.dart';
import 'package:fedha/common/category_logo.dart';
import 'package:fedha/common/stepper_bottom_sheet.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelectionSheet extends StatefulWidget {
  final TransactionType transactionType;
  final String transactionId;

  const CategorySelectionSheet({
    Key? key,
    required this.transactionType,
    required this.transactionId,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelectionSheetState createState() => _CategorySelectionSheetState();
}

class _CategorySelectionSheetState extends State<CategorySelectionSheet> {
  category_.Category? selectedCategory;
  category_.SubCategory? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: StepperBottomSheet(
        title: "",
        steps: const [
          EasyStep(title: 'Categories', icon: Icon(Icons.category)),
          EasyStep(title: 'Sub-categories', icon: Icon(Icons.list)),
        ],
        stepContents: [
          _buildCategoryList(),
          _buildSubcategoryList(),
        ],
        onSave: () {
          final bloc = context.read<TransactionsBloc>();

          if (!bloc.isClosed) {
            bloc.add(UpdateCategory(
              categoryId: selectedCategory!.id,
              subcategoryId: selectedSubCategory?.id,
              transactionId: widget.transactionId,
            ));
          }
          Navigator.pop(context);
        },
        onNext: () {
          // Optional: Handle any actions when the "Next" button is pressed
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return widget.transactionType == TransactionType.debit
        ? BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              return _buildCategoryListWidget(state.categories.data);
            },
          )
        : BlocBuilder<IncomeBloc, IncomeState>(
            builder: (context, state) {
              return _buildCategoryListWidget(state.incomeTypes);
            },
          );
  }

  Widget _buildCategoryListWidget(List<category_.Category> categories) {
    return SizedBox(
      height: 460,
      child: SingleChildScrollView(
        child: Column(
          children: categories.map((e) => _buildCategoryItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(category_.Category category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
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

  Widget _buildSubcategoryList() {
    if (selectedCategory == null) {
      return const Center(child: Text("Please select a category first"));
    }

    return SizedBox(
      height: 460,
      child: SingleChildScrollView(
        child: Column(
          children: selectedCategory!.subcategories
              .map((e) => _buildSubcategoryItem(e))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(category_.SubCategory subcategory) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubCategory = subcategory;
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
                  imageUrl: subcategory.image,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 8),
              Text(subcategory.name),
              const Spacer(),
              Radio<int>(
                value: subcategory.id,
                groupValue: selectedSubCategory?.id,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
