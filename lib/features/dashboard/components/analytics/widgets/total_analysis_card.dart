import 'dart:ui';

import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = const MediaQueryData().size;

    return SizedBox(
      width: double.infinity,
      height: screenSize.height * 0.4,
      child: const Card(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
