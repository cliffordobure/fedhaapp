import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/features/dashboard/components/subscriptions/widgets/cancel_subscription_dialog.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';


class SubscriptionDetail extends StatelessWidget {
  final Subscription subscription;
  const SubscriptionDetail({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        title: Text("Subscriptions",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
                color: AppColors.darkBlueColor,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/Images/Background.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        // decoration: BoxDecoration(
                        //   color: Colors.black26,
                        //   image: DecorationImage(
                        //     image: NetworkImage(subscription.img),
                        //   ),
                        // ),
                        child: Image.network(subscription.img),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          // Text(
                          //   subscription.subscriptionType,
                          //   style: Theme.of(context).textTheme.bodyMedium,
                          // ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status:",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyColor),
                      ),
                      Text(subscription.status == 1 ? "Active" : "Inactive",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment:",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyColor),
                      ),
                      Text("Ksh. ${subscription.amount}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next Payment:",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyColor),
                      ),
                      Text(formatTileDate(subscription.nextPaymentDate),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FullWidthButton(
                        color: Colors.red,
                        btnheight: 50,
                        text: "Cancel Subscription",
                        // child: Text("Cancel Subscription",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.dangerColor),),
                        action: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CancelSubDialog(
                                  subscription: subscription,
                                );
                              });
                        }),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Back to subscriptions",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greyColor),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}