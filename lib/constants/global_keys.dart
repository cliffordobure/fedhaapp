import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// Global showcase keys
final GlobalKey menuDrawerKey = GlobalKey();
final GlobalKey notificationsKey = GlobalKey();
final GlobalKey homeMenuKey = GlobalKey();
final GlobalKey transactionsMenuKey = GlobalKey();
final GlobalKey planningMenuKey = GlobalKey();
final GlobalKey budgetMenuKey = GlobalKey();
final GlobalKey analyticsMenuKey = GlobalKey();
final GlobalKey profileMenuKey = GlobalKey();
final GlobalKey newWalletKey = GlobalKey();

// Tutorial functions
List<TargetFocus> createTargets() {
  return [
    _createTarget(
      "menuDrawerKey",
      menuDrawerKey,
      "Drawer Menu",
      "Reveal more options by clicking this button.",
      ContentAlign.bottom,
      shape: ShapeLightFocus.Circle,
    ),
    _createTarget(
      "notificationsKey",
      notificationsKey,
      "Notifications",
      "Catch all news and updates right here",
      ContentAlign.bottom,
      shape: ShapeLightFocus.Circle,
    ),
    _createTarget(
      "newWalletKey",
      newWalletKey,
      "New Walllet",
      "From here, you can create your new wallet",
      ContentAlign.bottom,
      shape: ShapeLightFocus.Circle,
    ),
    _createTarget(
      "homeMenuKey",
      homeMenuKey,
      "Overview Menu",
      "Overview of your financial data, offers, and transactions is found in this tab.",
      ContentAlign.top,
      // imagePath: "assets/tutorial/home.png",
      shape: ShapeLightFocus.Circle,
    ),
    _createTarget(
      "planningMenuKey",
      planningMenuKey,
      "Planning Menu",
      "Set your budgets Goals, expenditure targets and budgets in this section",
      ContentAlign.top,
      // imagePath: "assets/tutorial/transactions.png",
      shape: ShapeLightFocus.Circle,
      radius: 5,
    ),
    _createTarget(
      "transactionsMenuKey",
      transactionsMenuKey,
      "Add New Transaction Menu",
      "From here you can add new transactions either manually or automatically",
      ContentAlign.top,
      shape: ShapeLightFocus.Circle,
      radius: 9,
    ),
    _createTarget(
      "analyticsMenuKey",
      analyticsMenuKey,
      "Analytics Section",
      "View your monetary management habits for a given duration",
      ContentAlign.top,
      // imagePath: "assets/tutorial/analytics.png",
      shape: ShapeLightFocus.Circle,
    ),
    _createTarget(
      "profileMenuKey",
      profileMenuKey,
      "Profile and Settings",
      "View your personal info here and make adjustments as desired.",
      ContentAlign.top,
      // imagePath: "assets/tutorial/complete.png",
      shape: ShapeLightFocus.Circle,
    ),
  ];
}

TargetFocus _createTarget(
  String identify,
  GlobalKey key,
  String title,
  String description,
  ContentAlign align, {
  String? imagePath,
  ShapeLightFocus shape = ShapeLightFocus.RRect,
  double? radius,
}) {
  return TargetFocus(
    identify: identify,
    keyTarget: key,
    alignSkip: Alignment.bottomRight,
    enableOverlayTab: true,
    contents: [
      TargetContent(
        align: align,
        builder: (context, controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(imagePath, height: 200),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.skip(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.next(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ],
    shape: shape,
    radius: radius,
  );
}
