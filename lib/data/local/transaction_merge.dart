import 'package:fedha/data/models/transactions/transactions.dart';

/// Merge local + server transactions without duplicates.
///
/// Prefers server rows (positive [Transaction.id]) when the same
/// [Transaction.transactionId] exists in both lists. Also collapses near-
/// identical SMS/server pairs that somehow got different codes.
List<Transaction> mergeTransactionsDeduped(
  List<Transaction> primary, {
  List<Transaction> secondary = const [],
  bool preferPrimary = true,
}) {
  final byCode = <String, Transaction>{};

  void upsert(Transaction t, {required bool isPrimary}) {
    final code = t.transactionId.trim();
    if (code.isEmpty) return;
    final existing = byCode[code];
    if (existing == null) {
      byCode[code] = t;
      return;
    }
    byCode[code] = _prefer(existing, t, preferFirst: isPrimary == preferPrimary);
  }

  if (preferPrimary) {
    for (final t in primary) {
      upsert(t, isPrimary: true);
    }
    for (final t in secondary) {
      upsert(t, isPrimary: false);
    }
  } else {
    for (final t in secondary) {
      upsert(t, isPrimary: false);
    }
    for (final t in primary) {
      upsert(t, isPrimary: true);
    }
  }

  final withoutCode = <Transaction>[
    ...primary.where((t) => t.transactionId.trim().isEmpty),
    ...secondary.where((t) => t.transactionId.trim().isEmpty),
  ];

  final merged = <Transaction>[...byCode.values];
  for (final t in withoutCode) {
    if (!merged.any((e) => _sameFingerprint(e, t))) {
      merged.add(t);
    }
  }

  return _dedupeByFingerprint(merged)
    ..sort((a, b) {
      final ad = a.date ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.date ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });
}

Transaction _prefer(Transaction a, Transaction b, {required bool preferFirst}) {
  // Always prefer a real server id over an optimistic local id.
  if (a.id > 0 && b.id <= 0) return a;
  if (b.id > 0 && a.id <= 0) return b;
  return preferFirst ? a : b;
}

List<Transaction> _dedupeByFingerprint(List<Transaction> input) {
  final out = <Transaction>[];
  for (final t in input) {
    final idx = out.indexWhere((e) => _sameFingerprint(e, t));
    if (idx < 0) {
      out.add(t);
      continue;
    }
    out[idx] = _prefer(out[idx], t, preferFirst: out[idx].id > 0);
  }
  return out;
}

/// Same money movement even if transaction codes differ slightly.
bool _sameFingerprint(Transaction a, Transaction b) {
  if (a.transactionId.isNotEmpty &&
      b.transactionId.isNotEmpty &&
      a.transactionId == b.transactionId) {
    return true;
  }
  if (a.type != b.type) return false;
  if (a.walletId != null && b.walletId != null && a.walletId != b.walletId) {
    return false;
  }
  if ((a.amount - b.amount).abs() > 0.009) return false;

  final ad = a.date ?? a.createdAt;
  final bd = b.date ?? b.createdAt;
  if (ad == null || bd == null) {
    return _normNarration(a.narration) == _normNarration(b.narration) &&
        _normNarration(a.narration).isNotEmpty;
  }
  if (ad.difference(bd).inMinutes.abs() > 2) return false;

  final na = _normNarration(a.narration);
  final nb = _normNarration(b.narration);
  // Only treat empty↔empty as a match. An empty narration must not swallow
  // a newly created manual transaction that has a description.
  if (na.isEmpty && nb.isEmpty) return true;
  if (na.isEmpty || nb.isEmpty) return false;
  return na == nb || na.contains(nb) || nb.contains(na);
}

String _normNarration(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
}
