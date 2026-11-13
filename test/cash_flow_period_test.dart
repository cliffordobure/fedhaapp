import 'package:fedha/utils/analytics_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cashFlowPeriodRange', () {
    final now = DateTime(2026, 9, 27, 15, 30); // Sunday

    test('Day is today only', () {
      final range = cashFlowPeriodRange('this_day', now: now);
      expect(range.start, DateTime(2026, 9, 27));
      expect(range.end.year, 2026);
      expect(range.end.month, 9);
      expect(range.end.day, 27);
    });

    test('Week starts Monday', () {
      final range = cashFlowPeriodRange('this_week', now: now);
      expect(range.start, DateTime(2026, 9, 21)); // Monday
      expect(range.end.day, 27);
    });

    test('Month starts on the 1st', () {
      final range = cashFlowPeriodRange('this_month', now: now);
      expect(range.start, DateTime(2026, 9, 1));
    });

    test('Year starts Jan 1', () {
      final range = cashFlowPeriodRange('this_year', now: now);
      expect(range.start, DateTime(2026, 1, 1));
    });

    test('labels cover Day Week Month Year', () {
      expect(kCashFlowPeriods.map((e) => e.label).toList(),
          ['Day', 'Week', 'Month', 'Year']);
    });
  });
}
