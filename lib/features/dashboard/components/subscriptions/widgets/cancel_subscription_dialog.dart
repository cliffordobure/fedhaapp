import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/features/app/blocs/subscriptions/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelSubDialog extends StatefulWidget {
  final Subscription subscription;
  const CancelSubDialog({super.key, required this.subscription});

  @override
  State<CancelSubDialog> createState() => _CancelSubDialogState();
}

class _CancelSubDialogState extends State<CancelSubDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          height: 350,
          width: double.maxFinite,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Cancel Subscription",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Center(
                  child: Text(
                    "Are you sure you want to cancel your ${widget.subscription.name} Subscription?",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Back",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SubscriptionsBloc>()
                            .add(CancelSubscriptions(widget.subscription.id));
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text("Yes,Cancel",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.whiteColor,
                                  )),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
