import 'package:fedha/features/app/blocs/graphs/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphTabs extends StatefulWidget {
  const GraphTabs({super.key});

  @override
  State<GraphTabs> createState() => _GraphTabsState();
}

class _GraphTabsState extends State<GraphTabs> {
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return BlocBuilder<GraphsBloc, GraphsState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (int index) async {
              context.read<GraphsBloc>().add(TabChanged(selected: index));
            },
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            selectedBorderColor: AppColors.primaryColor,
            selectedColor: AppColors.whiteColor,
            fillColor: AppColors.primaryColor,
            color: AppColors.darkColor,
            constraints: BoxConstraints(
              minHeight: 40.0,
              minWidth: (MediaQuery.of(context).size.width - 36) / 3,
            ),
            isSelected: state.tabs,
            textStyle: theme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            children: const [
              Text(
                'This week',
              ),
              Text(
                'This Month',
              ),
              Text(
                'Custom',
              )
            ],
          ),
        );
      },
    );
  }
}
