import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// On-device log of payments made towards goals and budgets.
///
/// The API only stores the running total (`amount_saved` / `amount`), so the
/// individual payments are kept locally per entity.
class PaymentHistoryStore {
  PaymentHistoryStore._();

  static String _key(String entity, int id) => 'payment_history_${entity}_$id';

  static Future<List<Map<String, dynamic>>> load(String entity, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(entity, id));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> add(
    String entity,
    int id, {
    required double amount,
    String? note,
    DateTime? paidAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final rows = await load(entity, id);
    final now = DateTime.now();
    rows.add({
      'id': '${now.microsecondsSinceEpoch}',
      'amount': amount,
      if (note != null && note.isNotEmpty) 'note': note,
      'created_at': (paidAt ?? now).toIso8601String(),
    });
    rows.sort((a, b) =>
        '${b['created_at'] ?? ''}'.compareTo('${a['created_at'] ?? ''}'));
    await prefs.setString(_key(entity, id), jsonEncode(rows));
  }

  static Future<void> remove(String entity, int id, String paymentId) async {
    final prefs = await SharedPreferences.getInstance();
    final rows = await load(entity, id);
    rows.removeWhere((r) => _rowId(r) == paymentId);
    await prefs.setString(_key(entity, id), jsonEncode(rows));
  }

  /// Older rows have no `id`; fall back to their timestamp.
  static String rowId(Map<String, dynamic> row) => _rowId(row);

  static String _rowId(Map<String, dynamic> row) =>
      '${row['id'] ?? row['created_at'] ?? ''}';
}
