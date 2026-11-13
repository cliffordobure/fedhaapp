import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsTotals {
  const AnalyticsTotals({required this.income, required this.expense});
  final double income;
  final double expense;
  double get net => income - expense;
  double get flow => income + expense;
  double get incomeShare => flow <= 0 ? 0.5 : (income / flow).clamp(0.0, 1.0);
  double get expenseShare => 1 - incomeShare;
  double get savingsRate =>
      income <= 0.009 ? 0 : ((income - expense) / income).clamp(-5.0, 5.0);
}

class CategorySlice {
  const CategorySlice({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
  });
  final int id;
  final String name;
  final double amount;
  final Color color;
}

class TimeBucket {
  const TimeBucket({
    required this.label,
    required this.income,
    required this.expense,
  });
  final String label;
  final double income;
  final double expense;
  double get net => income - expense;
}

class TxBrief {
  const TxBrief({
    required this.tx,
    required this.title,
    required this.amount,
  });
  final Transaction tx;
  final String title;
  final double amount;
}

const List<Color> kAnalyticsPalette = [
  Color(0xFF0F9D58),
  Color(0xFFE25555),
  Color(0xFF2E86AB),
  Color(0xFFE8A838),
  Color(0xFF5B8DEF),
  Color(0xFF7B6CF6),
  Color(0xFF14B8A6),
  Color(0xFFF97316),
  Color(0xFF0B3D2E),
  Color(0xFFD64550),
];

DateTimeRange analyticsRange(DateTime? start, DateTime? end) {
  final now = DateTime.now();
  final s = start ?? DateTime(now.year, now.month, 1);
  final eRaw = end ?? now;
  final e = DateTime(eRaw.year, eRaw.month, eRaw.day, 23, 59, 59);
  return DateTimeRange(start: s, end: e);
}

bool _inRange(Transaction t, DateTimeRange range) {
  final date = t.date ?? t.createdAt;
  if (date == null) return true;
  return !date.isBefore(range.start) && !date.isAfter(range.end);
}

AnalyticsTotals totalsFor({
  required List<Transaction> txs,
  required DateTime? start,
  required DateTime? end,
  int? walletId,
  TransactionType? type,
}) {
  final range = analyticsRange(start, end);
  var income = 0.0;
  var expense = 0.0;
  for (final t in txs) {
    if (walletId != null && t.walletId != walletId) continue;
    if (narrationIsInternalTransfer(t.narration)) continue;
    if (!_inRange(t, range)) continue;
    if (type != null && t.type != type) continue;
    if (t.type == TransactionType.credit) {
      income += t.amount;
    } else {
      expense += t.amount + (t.charges ?? 0);
    }
  }
  return AnalyticsTotals(income: income, expense: expense);
}

double pctChange(double current, double previous) {
  if (previous.abs() < 0.009) {
    if (current.abs() < 0.009) return 0;
    return 100;
  }
  return ((current - previous) / previous.abs()) * 100;
}

AnalyticsTotals previousPeriodTotals({
  required List<Transaction> txs,
  required DateTime? start,
  required DateTime? end,
}) {
  final range = analyticsRange(start, end);
  final days = range.end.difference(range.start).inDays + 1;
  final prevEnd = range.start.subtract(const Duration(days: 1));
  final prevStart = prevEnd.subtract(Duration(days: days - 1));
  return totalsFor(txs: txs, start: prevStart, end: prevEnd);
}

List<CategorySlice> categoryBreakdown({
  required List<Transaction> txs,
  required DateTime? start,
  required DateTime? end,
  required TransactionType type,
  required Map<int, String> categoryNames,
  int limit = 8,
}) {
  final range = analyticsRange(start, end);
  final map = <int, double>{};
  for (final t in txs) {
    if (t.type != type) continue;
    if (narrationIsInternalTransfer(t.narration)) continue;
    if (!_inRange(t, range)) continue;
    final id = t.categoryId ?? 0;
    final amt = type == TransactionType.credit
        ? t.amount
        : t.amount + (t.charges ?? 0);
    map[id] = (map[id] ?? 0) + amt;
  }
  final entries = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top = entries.take(limit).toList();
  return [
    for (var i = 0; i < top.length; i++)
      CategorySlice(
        id: top[i].key,
        name: top[i].key == 0
            ? 'Uncategorized'
            : (categoryNames[top[i].key] ?? 'Category ${top[i].key}'),
        amount: top[i].value,
        color: kAnalyticsPalette[i % kAnalyticsPalette.length],
      ),
  ];
}

/// Last [count] calendar months income/expense.
List<TimeBucket> monthlyBuckets({
  required List<Transaction> txs,
  int count = 6,
}) {
  final now = DateTime.now();
  final out = <TimeBucket>[];
  for (var i = count - 1; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    final t = totalsFor(txs: txs, start: month, end: end);
    out.add(TimeBucket(
      label: DateFormat('MMM').format(month),
      income: t.income,
      expense: t.expense,
    ));
  }
  return out;
}

/// Day-of-week expense averages (Mon–Sun).
List<TimeBucket> weekdaySpend({
  required List<Transaction> txs,
  required DateTime? start,
  required DateTime? end,
}) {
  final range = analyticsRange(start, end);
  final sums = List<double>.filled(7, 0);
  final counts = List<int>.filled(7, 0);
  for (final t in txs) {
    if (t.type != TransactionType.debit) continue;
    if (narrationIsInternalTransfer(t.narration)) continue;
    if (!_inRange(t, range)) continue;
    final d = t.date ?? t.createdAt;
    if (d == null) continue;
    final idx = d.weekday - 1; // Mon=0
    sums[idx] += t.amount + (t.charges ?? 0);
    counts[idx] += 1;
  }
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return [
    for (var i = 0; i < 7; i++)
      TimeBucket(
        label: labels[i],
        income: 0,
        expense: counts[i] == 0 ? 0 : sums[i],
      ),
  ];
}

List<TxBrief> topTransactions({
  required List<Transaction> txs,
  required DateTime? start,
  required DateTime? end,
  required TransactionType type,
  int limit = 5,
}) {
  final range = analyticsRange(start, end);
  final list = <TxBrief>[];
  for (final t in txs) {
    if (t.type != type) continue;
    if (narrationIsInternalTransfer(t.narration)) continue;
    if (!_inRange(t, range)) continue;
    final amt = type == TransactionType.credit
        ? t.amount
        : t.amount + (t.charges ?? 0);
    final title = t.narration.trim().isEmpty ? 'Transaction' : t.narration;
    list.add(TxBrief(tx: t, title: title, amount: amt));
  }
  list.sort((a, b) => b.amount.compareTo(a.amount));
  return list.take(limit).toList();
}

String formatAnalyticsMoney(double amount, {bool compact = true}) {
  final abs = amount.abs();
  if (compact && abs >= 100000) {
    return NumberFormat.compactCurrency(
      locale: 'en_US',
      symbol: 'KES ',
      decimalDigits: 1,
    ).format(amount);
  }
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: 'KES ',
    decimalDigits: 0,
  ).format(amount);
}
