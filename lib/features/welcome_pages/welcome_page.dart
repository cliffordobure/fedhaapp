import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController controller = PageController();
  var currentPageValue = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return PageView.builder(
        controller: controller,
        itemCount: 3,
        itemBuilder: (context, position) {
          return Scaffold(
            backgroundColor: position == 0
                ? AppColors.darkBlueColor
                : position == 1
                    ? AppColors.darkGreenColor
                    : AppColors.primaryColor,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          // Save boarded
                          AppPreferences().onboard();

                          context.goNamed(Routes.register);
                        },
                        child: Text(
                          "Skip",
                          style: theme.bodyMedium
                              ?.copyWith(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Image.asset(
                        position == 0
                            ? "assets/Images/Rectangle 1264.png"
                            : position == 1
                                ? "assets/Images/Rectangle -1.png"
                                : "assets/Images/sincerely-media-SWOLvJ4-ZTQ-unsplash.png",
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 37,
                      ),
                      FittedBox(
                        child: Text(
                          position == 0
                              ? "Manage Your Finances"
                              : position == 1
                                  ? "Boost your Savings"
                                  : "Track Bill Payments",
                          style: theme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      FittedBox(
                        child: Text(
                          position == 0
                              ? "Your journey to Financial Freedom!"
                              : position == 1
                                  ? "We have made it easy for you to save by showing you the numbers."
                                  : "Stay updated on your bills and subscriptions.",
                          style: theme.displaySmall
                              ?.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                                3,
                                (index) => Icon(Icons.fiber_manual_record,
                                    color: position != index
                                        ? const Color(0XFFFFFFFF)
                                            .withOpacity(.2)
                                        : Colors.grey,
                                    size: 12)),
                          ),
                          IconButton(
                            onPressed: () {
                              if (position == 2) {
                                // Save boarded
                                AppPreferences().onboard();
                                context.goNamed(Routes.register);
                              } else {
                                setState(() {
                                  controller.nextPage(
                                      curve: Curves.decelerate,
                                      duration:
                                          const Duration(milliseconds: 300));
                                });
                              }
                            },
                            icon: Container(
                              height: 46,
                              width: 46,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 16,
                                weight: 10,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
