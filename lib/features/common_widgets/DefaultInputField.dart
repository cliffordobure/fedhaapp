import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultInputField extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final bool password;
  final bool isroundedPrefix;
  final bool hide;
  final Function? toggleHide;
  final bool textCenter;
  final Widget? suffix;
  final bool enabled;
  final TextInputType inputtype; // Entry type
  final TextInputAction inputAction; // next action
  final int? maxLength;
  final FocusNode? node;

  final double? height;
  final String? title;
  final bool hasTitle;
  final dynamic validator;
  final dynamic onSaved;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final bool? readOnly;
  final String? initVal;
  final TextEditingController? textEditingController;
  final BorderRadius? borderRadius;
  final int? maxLine;
  final dynamic inputFormatters;

  const DefaultInputField(
      {Key? key,
      this.title,
      this.hintText,
      this.node,
      this.height,
      this.prefix,
      this.inputtype = TextInputType.name,
      this.inputAction = TextInputAction.next,
      this.password = false,
      this.isroundedPrefix = true,
      this.hasTitle = true,
      this.hide = false,
      this.toggleHide,
      this.validator,
      this.onSaved,
      this.onChanged,
      this.onTap,
      this.inputFormatters,
      this.textCenter = false,
      this.suffix,
      this.textEditingController,
      this.borderRadius,
      this.enabled = true,
      this.readOnly,
      this.initVal,
      this.maxLine,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTitle ? Text(title ?? '', style: theme.labelMedium) : Container(),
        hasTitle
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox.shrink(),
        Container(
          margin: EdgeInsets.only(top: 0.h),
          child: TextFormField(
            //.
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: textEditingController,
            textInputAction: inputAction,
            // maxLength: maxLength,
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
            focusNode: node,
            onTap: onTap,
            initialValue: initVal,
            readOnly: readOnly ?? false,
            inputFormatters: inputFormatters,
            scrollPadding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              // Extra room so the field clears sticky sheet actions + keyboard.
              bottom: MediaQuery.viewInsetsOf(context).bottom + 120,
            ),

            keyboardType: inputtype,

            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0XFF555555),
            ),

            textAlign: textCenter ? TextAlign.center : TextAlign.start,
            obscureText: hide,

            decoration: InputDecoration(
              errorStyle: TextStyle(
                fontSize: 6.sp,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
              suffixIcon: suffix,
              prefixIcon: prefix,
              enabled: enabled,
              helperText: "",
              hintText: hintText,
              hintStyle: theme.displayMedium!.copyWith(color: Colors.black26),
              fillColor: Colors.white,
              filled: readOnly ?? false,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  // width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

InputDecoration getDropDownDecoration(
    BuildContext context, bool enabled, String hintText) {
  TextTheme theme = Theme.of(context).textTheme;
  return InputDecoration(
    errorStyle: TextStyle(
      fontSize: 6.sp,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
    enabled: enabled,
    helperText: "",
    hintText: hintText,
    hintStyle: theme.displayMedium!.copyWith(color: Colors.black26),
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(
        color: AppColors.greyColor,
        // width: 2.0,
      ),
    ),
  );
}
