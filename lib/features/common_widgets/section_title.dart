import 'package:flutter/material.dart';

Widget buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
