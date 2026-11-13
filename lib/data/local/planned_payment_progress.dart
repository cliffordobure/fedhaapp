import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/data/services/local_data_cache.dart';

/// Payment progress derived from linked transactions + payment history.
class PlannedPaymentProgress {
  const PlannedPaymentProgress({
    required this.targetAmount,
    required this.paidAmount,
    required this.status,
  });

  final double targetAmount;
  final double paidAmount;

  /// `paid` | `partially_paid` | `pending`
  final String status;

  bool get isPaid => status == 'paid';
  bool get isPartial => status == 'partially_paid';
  double get remaining =>
      (targetAmount - paidAmount).clamp(0, double.infinity);
  double get ratio =>
      targetAmount <= 0 ? 0 : (paidAmount / targetAmount).clamp(0.0, 1.0);

  String get label {
    switch (status) {
      case 'paid':
        return 'Paid';
      case 'partially_paid':
        return 'Partially paid';
      default:
        return 'Pending';
    }
  }
}

double parsePlannedAmount(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[^0-9.\-]'), '');
  return double.tryParse(cleaned) ?? 0;
}

String normalizePlannedStatus(dynamic status) {
  final s = '$status'.trim().toLowerCase().replaceAll(' ', '_');
  if (s.contains('partial')) return 'partially_paid';
  if (s == 'paid' || s == 'completed' || s == 'done') return 'paid';
  return 'pending';
}

String normalizePlannedFrequency(String? frequency) {
  final f = (frequency ?? '').trim().toLowerCase();
  if (f == 'daily' || f == 'day') return 'daily';
  if (f == 'weekly' || f == 'week') return 'weekly';
  if (f == 'monthly' || f == 'month') return 'monthly';
  return 'once';
}

/// Inclusive start / exclusive end for the current due cycle.
({DateTime start, DateTime end}) plannedPaymentPeriodBounds({
  required String frequency,
  DateTime? now,
}) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  switch (normalizePlannedFrequency(frequency)) {
    case 'daily':
      return (start: today, end: today.add(const Duration(days: 1)));
    case 'weekly':
      final start = today.subtract(Duration(days: today.weekday - 1));
      return (start: start, end: start.add(const Duration(days: 7)));
    case 'monthly':
      final start = DateTime(today.year, today.month, 1);
      return (start: start, end: DateTime(today.year, today.month + 1, 1));
    case 'once':
    default:
      return (start: DateTime(1970), end: DateTime(2100));
  }
}

DateTime? _dateOnlyFrom(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final dt = DateTime.tryParse(raw.trim());
  if (dt == null) return null;
  return DateTime(dt.year, dt.month, dt.day);
}

bool isPaidAtInPeriod({
  required String paidAt,
  required DateTime start,
  required DateTime end,
}) {
  final d = _dateOnlyFrom(paidAt);
  if (d == null) return false;
  return !d.isBefore(start) && d.isBefore(end);
}

double historyTotalInPeriod({
  required List<PaymentHistory?>? histories,
  required String frequency,
  DateTime? now,
}) {
  final bounds = plannedPaymentPeriodBounds(frequency: frequency, now: now);
  return (histories ?? const [])
      .whereType<PaymentHistory>()
      .where(
        (h) => isPaidAtInPeriod(
          paidAt: h.paidAt.isNotEmpty ? h.paidAt : (h.createdAt ?? ''),
          start: bounds.start,
          end: bounds.end,
        ),
      )
      .fold<double>(0, (sum, h) => sum + parsePlannedAmount(h.amount));
}

PlannedPaymentProgress progressFromAmounts({
  required double target,
  required double linkedTotal,
  required double historyTotal,
}) {
  // Prefer the larger of linked txs vs recorded history (avoid double-count).
  final paid = linkedTotal >= historyTotal ? linkedTotal : historyTotal;
  final status = paid <= 0.009
      ? 'pending'
      : (paid + 0.009 >= target ? 'paid' : 'partially_paid');
  return PlannedPaymentProgress(
    targetAmount: target,
    paidAmount: paid,
    status: status,
  );
}

/// Progress for the current frequency cycle (once / day / week / month).
PlannedPaymentProgress progressForPlannedPayment({
  required PlannedPayment payment,
  double linkedTotal = 0,
  DateTime? now,
}) {
  return progressFromAmounts(
    target: parsePlannedAmount(payment.amount),
    linkedTotal: linkedTotal,
    historyTotal: historyTotalInPeriod(
      histories: payment.paymentHistory,
      frequency: payment.frequency,
      now: now,
    ),
  );
}

/// Whether this payment can accept another "Mark as paid" for the current cycle.
bool canMarkPlannedPaymentPaid({
  required PlannedPayment payment,
  double linkedTotal = 0,
  DateTime? now,
}) {
  return !progressForPlannedPayment(
    payment: payment,
    linkedTotal: linkedTotal,
    now: now,
  ).isPaid;
}

/// Recompute status from SQLite links + history and persist on the payment.
Future<PlannedPaymentProgress?> refreshPlannedPaymentLinkStatus({
  required LocalDataCache cache,
  required int plannedPaymentId,
}) async {
  if (plannedPaymentId == 0) return null;

  final list = await cache.loadPlannedPayments() ?? const <PlannedPayment>[];
  PlannedPayment? payment;
  for (final p in list) {
    if (p.id == plannedPaymentId) {
      payment = p;
      break;
    }
  }
  if (payment == null) return null;

  final links = await cache.loadLinksForEntity(
    entityType: AllocationEntityType.plannedPayment,
    entityId: plannedPaymentId,
  );
  final linkedTotal =
      links.fold<double>(0, (sum, l) => sum + l.linkedAmount.abs());

  final progress = progressForPlannedPayment(
    payment: payment,
    linkedTotal: linkedTotal,
  );

  if (normalizePlannedStatus(payment.status) != progress.status) {
    final updated = payment.copyWith(
      status: progress.status,
      updatedAt: DateTime.now().toIso8601String(),
    );
    final next = list
        .map((p) => p.id == plannedPaymentId ? updated : p)
        .toList(growable: false);
    await cache.savePlannedPayments(next);
  }

  return progress;
}
