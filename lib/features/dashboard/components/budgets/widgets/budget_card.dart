import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/budgets/budget.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: AppColors.whiteColor,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRect(
              child: CategoryLogoImage(
                imageUrl: budget.img,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            budget.budgetName,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Ksh ${budget.amount}",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.greyColor),
          ),
          // trailing: const Icon(CupertinoIcons.chevron_right),
        ),
      ],
    );
  }
}
