import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullWidthButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? btnheight;
  final double? fontsize;
  final VoidCallback action;
  final ShapeBorder? shape;

  const FullWidthButton(
      {Key? key,
      this.text,
      this.child,
      this.color,
      this.btnheight,
      required this.action,
      this.fontsize,
      this.shape,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return MaterialButton(
      color: color ?? AppColors.primaryColor,
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      shape: shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
      onPressed: action,
      child: child ??
          Text("$text",
              style: theme.titleMedium!.copyWith(color: Colors.white)),
    );
  }
}
