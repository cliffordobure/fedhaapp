import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultComboBox extends StatefulWidget {
  final List<String> items;
  final Widget? prefix;
  final String? hintText;
  final Widget? suffix;
  final String title;
  final BorderRadius? borderRadius;
  final Function(String?)? onSaved;
  const DefaultComboBox(
      {super.key,
      required this.items,
      this.prefix,
      this.suffix,
      this.hintText,
      required this.title,
      this.borderRadius,
      this.onSaved});

  @override
  State<DefaultComboBox> createState() => _DefaultComboBoxState();
}

class _DefaultComboBoxState extends State<DefaultComboBox> {
  late String dropdownValue;
  late List<String> dropDownItems;

  @override
  void initState() {
    dropDownItems = widget.items;
    dropdownValue = dropDownItems.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: const Color(0XFF555555), fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(top: 0.h),
            child: DropdownButtonFormField(
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.black26),
              icon: const Icon(CupertinoIcons.chevron_down),
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  fontSize: 6.sp,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                suffixIcon: widget.suffix,
                prefixIcon: widget.prefix,
                helperText: "",
                hintText: widget.hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.black26),
                fillColor: Colors.grey.withOpacity(.1),
                filled: false,
              ),
              value: dropdownValue,
              onSaved: widget.onSaved,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items:
                  dropDownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
