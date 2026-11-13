import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  const SubscriptionCard({super.key, required this.subscription});

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
      child: Text(
        label,
        style: TextStyle(
          color: label == "Inactive"
              ? AppColors.dangerColor
              : AppColors.primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),

      // The end action pane
      endActionPane: ActionPane(
        extentRatio: .25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            icon: CupertinoIcons.pen,
            onPressed: (BuildContext context) {},
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
          ),
          SlidableAction(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            icon: Icons.delete_forever,
            onPressed: (BuildContext context) {},
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          // View details
          context.pushNamed(Routes.subscriptionDetail, extra: subscription);
        },
        tileColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image.network(subscription.img),
        ),
        title: Text(
          subscription.name,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          formatDate(subscription.nextPaymentDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "Ksh ",
                  children: [
                    TextSpan(text: " -${subscription.amount}"),
                  ],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dangerColor),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              _buildChip(
                  subscription.status == 1 ? "Active" : "Inactive",
                  subscription.status == 1
                      ? AppColors.primaryColor.withOpacity(.2)
                      : AppColors.dangerColor.withOpacity(.2))
            ],
          ),
        ),
      ),
    );
  }
}
