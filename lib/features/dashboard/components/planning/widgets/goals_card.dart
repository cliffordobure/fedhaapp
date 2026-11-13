import 'package:fedha/data/models/goals/goals.dart';
import 'package:fedha/features/app/blocs/goals/goals_bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.value,
    required this.indicatorColor,
    required this.iconBgColor,
    required this.description,
    required this.goalId,
    this.goalStatus = 'active',
  });
  final String text, description;
  final double value;
  final Color indicatorColor;
  final IconData icon;
  final Color iconBgColor;
  final Function onPressed;
  final int goalId;
  final String goalStatus;

  @override
  Widget build(BuildContext context) {
    final status = goalStatus.toLowerCase();
    final isPaused = status == 'pending';

    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlueColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconBgColor,
                    size: 20,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    handleSelectedOption(
                      value,
                      context,
                      goalId,
                      Goals(status: goalStatus),
                    );
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      if (isPaused)
                        const PopupMenuItem<String>(
                          value: 'Activate',
                          child: Text('Activate'),
                        )
                      else if (status != 'archived')
                        const PopupMenuItem<String>(
                          value: 'Pause',
                          child: Text('Pause'),
                        ),
                      if (status != 'archived')
                        const PopupMenuItem<String>(
                          value: 'Achieved',
                          child: Text('Mark as Achieved'),
                        ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                  child: Icon(Icons.more_vert, color: AppColors.fadeBlackColor),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fadeBlackColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                value: value.clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: AppColors.greyColor.withOpacity(0.45),
                color: indicatorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void handleSelectedOption(
    String value, BuildContext context, int goalId, Goals goal) {
  switch (value) {
    case 'Pause':
      context.read<GoalsBloc>().add(UpdateGoalStatusEvent(goalId, "pending"));
      break;
    case 'Activate':
      context.read<GoalsBloc>().add(UpdateGoalStatusEvent(goalId, "active"));
      break;
    case 'Achieved':
      context.read<GoalsBloc>().add(UpdateGoalStatusEvent(goalId, "archived"));
      break;
    case 'Delete':
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete goal'),
            content: const Text('Are you sure you want to delete this Goal?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ).then(
        (value) {
          if (value == true) {
            context.read<GoalsBloc>().add(DeleteGoalEvent(goalId));
          } else if (value == false) {
            showSimpleNotification(const Text("Deletion canceled"),
                background: Colors.red, foreground: Colors.white);
          }
        },
      );
      break;
    default:
      break;
  }
}
