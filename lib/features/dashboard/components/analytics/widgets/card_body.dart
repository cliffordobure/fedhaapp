import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

enum TitleType { income, expense }

class CardBdy extends StatelessWidget {
  final TitleType title;
  final String subtitle;
  const CardBdy({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title == TitleType.income
              ? Text("Income",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppColors.darkBlueColor))
              : Text("Expense",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: AppColors.darkBlueColor)),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
          )
        ],
      ),
    );
  }
}
