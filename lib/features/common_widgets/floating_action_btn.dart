import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class ActionBtn extends StatelessWidget {
  const ActionBtn({super.key, required this.onPressed, this.icon});
  final Function() onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      onPressed: onPressed,
      child: icon ?? const Icon(Icons.add),
    );
  }
}
