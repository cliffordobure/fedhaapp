/// Shared analytics / cash-flow period keys and date ranges.
///
/// UI labels: Day, Week, Month, Year (+ optional Custom).
const kCashFlowPeriods = <({String key, String label})>[
  (key: 'this_day', label: 'Day'),
  (key: 'this_week', label: 'Week'),
  (key: 'this_month', label: 'Month'),
  (key: 'this_year', label: 'Year'),
];

String cashFlowPeriodLabel(String period) {
  switch (period) {
    case 'this_day':
      return 'Day';
    case 'this_week':
      return 'Week';
    case 'this_year':
      return 'Year';
    case 'custom':
      return 'Custom';
    case 'this_month':
    default:
      return 'Month';
  }
}

/// Inclusive local date range for [period].
({DateTime start, DateTime end}) cashFlowPeriodRange(
  String period, {
  DateTime? startDate,
  DateTime? endDate,
  DateTime? now,
}) {
  final n = now ?? DateTime.now();
  final endOfToday = DateTime(n.year, n.month, n.day, 23, 59, 59);

  if (period == 'custom' && startDate != null && endDate != null) {
    return (
      start: DateTime(startDate.year, startDate.month, startDate.day),
      end: DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
    );
  }

  switch (period) {
    case 'this_day':
    case 'today':
    case 'daily':
      return (
        start: DateTime(n.year, n.month, n.day),
        end: endOfToday,
      );
    case 'this_week':
    case 'weekly':
      final start = n.subtract(Duration(days: n.weekday - 1));
      return (
        start: DateTime(start.year, start.month, start.day),
        end: endOfToday,
      );
    case 'this_year':
      return (start: DateTime(n.year, 1, 1), end: endOfToday);
    case 'this_month':
    default:
      return (start: DateTime(n.year, n.month, 1), end: endOfToday);
  }
}

bool dateInCashFlowPeriod(DateTime? date, String period,
    {DateTime? startDate, DateTime? endDate}) {
  if (date == null) return false;
  final range = cashFlowPeriodRange(
    period,
    startDate: startDate,
    endDate: endDate,
  );
  return !date.isBefore(range.start) && !date.isAfter(range.end);
}
