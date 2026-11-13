import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

Widget buildSegmentedButton(
    List<ButtonSegment<String>> segments,
    Set<String> selected,
    void Function(Set<String>)? onSegmentSelectionChanged) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    width: double.infinity,
    child: SegmentedButton<String>(
      showSelectedIcon: false,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryColor;
          }
          return null;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.whiteColor;
          }
          return null;
        }),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(color: AppColors.greyColor),
        ),
      ),
      segments: segments,
      selected: selected,
      onSelectionChanged: onSegmentSelectionChanged,
    ),
  );
}
