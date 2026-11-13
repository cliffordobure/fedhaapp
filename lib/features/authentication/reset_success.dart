import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetSuccess extends StatelessWidget {
  const ResetSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/Images/Background.png',
                ),
                fit: BoxFit.cover),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(
                    Icons.check,
                    size: 32,
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Container(
                  padding: EdgeInsets.all(10.w),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text("Reset Successful",
                          style: theme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 20.h),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            "You have successfully changed your password",
                            textAlign: TextAlign.center,
                            style: theme.displayMedium,
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Text(
                            "Please use your new password when logging in.",
                            textAlign: TextAlign.center,
                            style: theme.displayMedium,
                          )),
                      SizedBox(height: 30.h),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Container()),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .25),
                      FullWidthButton(
                        btnheight: 50.h,
                        action: () {
                          context.goNamed(Routes.login);
                        },
                        text: "Login",
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
