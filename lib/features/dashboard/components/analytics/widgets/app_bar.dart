import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.darkBlueColor,
          ),
    ),
    centerTitle: true,
  );
}
