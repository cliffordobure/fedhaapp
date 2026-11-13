import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

enum GraphType { daily, weekly, monthly, yearly }

class Transaction {
  final String category;
  final double amount;
  final DateTime date;

  Transaction(this.category, this.amount, this.date);
}

class CategoryData {
  final String category;
  final double totalAmount;
  final DateTime date;

  CategoryData(this.category, this.totalAmount, this.date);
}

class AnalyticsGraph extends StatelessWidget {
  final List<Transaction> transactions;
  final GraphType type;

  const AnalyticsGraph(
      {super.key, required this.transactions, required this.type});

  List<CategoryData> _processData() {
    Map<String, Map<DateTime, double>> categoryData = {};

    for (var transaction in transactions) {
      DateTime normalizedDate = _normalizeDate(transaction.date);
      categoryData.putIfAbsent(transaction.category, () => {});
      categoryData[transaction.category]!.update(
        normalizedDate,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    List<CategoryData> result = [];
    categoryData.forEach((category, dateAmounts) {
      dateAmounts.forEach((date, amount) {
        result.add(CategoryData(category, amount, date));
      });
    });

    return result;
  }

  DateTime _normalizeDate(DateTime date) {
    switch (type) {
      case GraphType.daily:
        return DateTime(date.year, date.month, date.day);
      case GraphType.weekly:
        return date.subtract(Duration(days: date.weekday - 1));
      case GraphType.monthly:
        return DateTime(date.year, date.month);
      case GraphType.yearly:
        return DateTime(date.year);
    }
  }

  String _formatDate(DateTime date) {
    switch (type) {
      case GraphType.daily:
        return DateFormat('MMM d').format(date);
      case GraphType.weekly:
        return '${DateFormat('MMM d').format(date)} - ${DateFormat('MMM d').format(date.add(const Duration(days: 6)))}';
      case GraphType.monthly:
        return DateFormat('MMM yyyy').format(date);
      case GraphType.yearly:
        return DateFormat('yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _processData();
    final uniqueCategories = data.map((e) => e.category).toSet().toList();

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: uniqueCategories.map((category) {
        final categoryData = data.where((d) => d.category == category).toList();
        return StackedColumnSeries<CategoryData, String>(
          dataSource: categoryData,
          xValueMapper: (CategoryData data, _) => _formatDate(data.date),
          yValueMapper: (CategoryData data, _) => data.totalAmount,
          name: category,
        );
      }).toList(),
    );
  }
}
