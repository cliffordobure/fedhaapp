import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(height: AppBar().preferredSize.height),
        Image.asset(
          "assets/Images/ic_launcher.png",
          height: 100.h,
          width: 100.w,
        ),
        Text(
          title,
          style: theme.titleLarge?.copyWith(
            color: AppColors.darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: theme.displayMedium?.copyWith(
            color: AppColors.darkBlueColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
