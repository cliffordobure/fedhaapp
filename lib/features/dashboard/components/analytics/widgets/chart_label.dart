import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';

class ChartLabel extends StatelessWidget {
  const ChartLabel(
      {super.key,
      required this.title,
      required this.amount,
      required this.indicatorValue,
      required this.barColor});
  final String title;
  final double amount;
  final double indicatorValue;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.titleMedium!
                .copyWith(fontSize: 16, color: AppColors.greyColor)),
        Text("Ksh. ${formatAmount(amount)}",
            style: theme.titleMedium!.copyWith(color: const Color(0xff919191))),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: MediaQuery.of(context).size.width * .30,
          height: 7,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: indicatorValue,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              backgroundColor: AppColors.greyColor,
            ),
          ),
        ),
      ],
    );
  }
}
