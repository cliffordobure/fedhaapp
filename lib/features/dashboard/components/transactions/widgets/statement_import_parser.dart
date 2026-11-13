import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

/// One row parsed from a bank/M-Pesa statement before import.
class StatementRow {
  const StatementRow({
    required this.date,
    required this.amount,
    required this.narration,
    required this.isCredit,
    this.charges = 0,
    this.balance,
    this.reference,
  });

  final DateTime date;
  final double amount;
  final String narration;
  final bool isCredit;
  final double charges;
  final double? balance;
  final String? reference;

  String get stableCode {
    final ref = (reference ?? '').trim();
    if (ref.isNotEmpty) return 'STMT_$ref';
    final day = DateFormat('yyyyMMdd').format(date);
    final key =
        '$day|${amount.toStringAsFixed(2)}|${isCredit ? 'C' : 'D'}|${narration.toLowerCase()}';
    return 'STMT_${key.hashCode.abs()}';
  }
}

class StatementParseResult {
  const StatementParseResult({
    required this.rows,
    required this.sourceName,
    this.warnings = const [],
  });

  final List<StatementRow> rows;
  final String sourceName;
  final List<String> warnings;
}

/// Parses CSV, Excel (.xlsx), or simple text-based PDF statements.
class StatementImportParser {
  StatementImportParser._();

  static Future<StatementParseResult> parseFile(File file) async {
    final name = file.path.split(RegExp(r'[\\/]')).last.toLowerCase();
    final bytes = await file.readAsBytes();
    return parseBytes(bytes, fileName: name);
  }

  static Future<StatementParseResult> parseBytes(
    List<int> bytes, {
    required String fileName,
  }) async {
    final name = fileName.toLowerCase();

    if (name.endsWith('.csv') || name.endsWith('.txt')) {
      return _parseDelimited(utf8.decode(bytes, allowMalformed: true), name);
    }
    if (name.endsWith('.xlsx') || name.endsWith('.xls')) {
      return _parseExcel(bytes, name);
    }
    if (name.endsWith('.pdf')) {
      return _parsePdfText(bytes, name);
    }
    // Sniff: ZIP/xlsx starts with PK
    if (bytes.length > 2 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
      return _parseExcel(bytes, name);
    }
    if (bytes.length > 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return _parsePdfText(bytes, name);
    }
    return _parseDelimited(utf8.decode(bytes, allowMalformed: true), name);
  }

  static StatementParseResult _parseExcel(List<int> bytes, String name) {
    final excel = Excel.decodeBytes(bytes);
    final warnings = <String>[];
    final rows = <StatementRow>[];

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null || sheet.rows.isEmpty) continue;

      final asStrings = sheet.rows
          .map(
            (r) => r
                .map((c) => (c?.value?.toString() ?? '').trim())
                .toList(growable: false),
          )
          .where((r) => r.any((c) => c.isNotEmpty))
          .toList();

      if (asStrings.isEmpty) continue;
      final parsed = _parseTable(asStrings);
      rows.addAll(parsed.$1);
      warnings.addAll(parsed.$2);
      if (rows.isNotEmpty) break;
    }

    if (rows.isEmpty) {
      warnings.add('No transaction rows found in the spreadsheet.');
    }
    return StatementParseResult(
      rows: rows,
      sourceName: name,
      warnings: warnings,
    );
  }

  static StatementParseResult _parseDelimited(String raw, String name) {
    final lines = const LineSplitter()
        .convert(raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n'))
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      return StatementParseResult(
        rows: const [],
        sourceName: name,
        warnings: const ['File is empty.'],
      );
    }

    final delimiter = lines.first.contains('\t')
        ? '\t'
        : (lines.first.split(',').length >=
                lines.first.split(';').length
            ? ','
            : ';');

    final table = lines
        .map((l) => _splitCsvLine(l, delimiter))
        .where((r) => r.any((c) => c.trim().isNotEmpty))
        .toList();
    final parsed = _parseTable(table);
    return StatementParseResult(
      rows: parsed.$1,
      sourceName: name,
      warnings: parsed.$2,
    );
  }

  static StatementParseResult _parsePdfText(List<int> bytes, String name) {
    final extracted = _extractPdfStrings(bytes);
    final warnings = <String>[
      'PDF import uses text extraction — Excel/CSV is more accurate when available.',
    ];
    if (extracted.trim().isEmpty) {
      return StatementParseResult(
        rows: const [],
        sourceName: name,
        warnings: [
          ...warnings,
          'Could not read text from this PDF. Export the statement as Excel or CSV and try again.',
        ],
      );
    }

    // Prefer line-oriented parsing when the PDF yielded readable lines.
    final lines = extracted
        .split(RegExp(r'[\n\r]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final rows = <StatementRow>[];
    for (final line in lines) {
      final row = _parseLooseTransactionLine(line);
      if (row != null) rows.add(row);
    }

    if (rows.isEmpty) {
      // Fall back: treat whitespace-separated chunks as a pseudo-table.
      final table = lines
          .map((l) => l.split(RegExp(r'\s{2,}|\t')).map((e) => e.trim()).toList())
          .where((r) => r.length >= 2)
          .toList();
      final parsed = _parseTable(table);
      rows.addAll(parsed.$1);
      warnings.addAll(parsed.$2);
    }

    if (rows.isEmpty) {
      warnings.add(
        'No transactions detected in the PDF. Try an Excel/CSV export from your bank.',
      );
    }
    return StatementParseResult(
      rows: rows,
      sourceName: name,
      warnings: warnings,
    );
  }

  /// Best-effort PDF string extraction (literal strings in content streams).
  static String _extractPdfStrings(List<int> bytes) {
    final raw = latin1.decode(bytes, allowInvalid: true);
    final buf = StringBuffer();
    final lit = RegExp(r'\((?:\\.|[^\\)])*\)\s*Tj', multiLine: true);
    for (final m in lit.allMatches(raw)) {
      var s = m.group(0)!;
      s = s.replaceAll(RegExp(r'\)\s*Tj$'), '');
      if (s.startsWith('(')) s = s.substring(1);
      s = s
          .replaceAll(r'\n', '\n')
          .replaceAll(r'\r', '\n')
          .replaceAll(r'\t', ' ')
          .replaceAll(r'\(', '(')
          .replaceAll(r'\)', ')')
          .replaceAll(r'\\', r'\');
      buf.writeln(s);
    }
    // Also grab bare date/amount-looking fragments from the stream.
    final dates = RegExp(
      r'\d{1,4}[/-]\d{1,2}[/-]\d{1,4}',
    ).allMatches(raw);
    if (buf.isEmpty && dates.isNotEmpty) {
      buf.write(raw.replaceAll(RegExp(r'[^\x20-\x7E\n]'), ' '));
    }
    return buf.toString();
  }

  static (List<StatementRow>, List<String>) _parseTable(
    List<List<String>> table,
  ) {
    final warnings = <String>[];
    if (table.isEmpty) return (const [], warnings);

    var headerIdx = 0;
    var mapping = _mapHeaders(table.first.map((e) => e.toLowerCase()).toList());
    // Find a header-looking row within the first 15 lines.
    for (var i = 0; i < math.min(15, table.length); i++) {
      final candidate =
          _mapHeaders(table[i].map((e) => e.toLowerCase()).toList());
      if (candidate.date >= 0 &&
          (candidate.amount >= 0 ||
              candidate.debit >= 0 ||
              candidate.credit >= 0)) {
        headerIdx = i;
        mapping = candidate;
        break;
      }
    }

    if (mapping.date < 0 ||
        (mapping.amount < 0 && mapping.debit < 0 && mapping.credit < 0)) {
      // No header — try heuristic on every row.
      final rows = <StatementRow>[];
      for (final cells in table) {
        final line = cells.join('  ');
        final row = _parseLooseTransactionLine(line);
        if (row != null) rows.add(row);
      }
      if (rows.isEmpty) {
        warnings.add('Could not detect Date / Amount columns.');
      }
      return (rows, warnings);
    }

    final rows = <StatementRow>[];
    for (var i = headerIdx + 1; i < table.length; i++) {
      final cells = table[i];
      String at(int idx) =>
          (idx >= 0 && idx < cells.length) ? cells[idx].trim() : '';

      final date = _parseDate(at(mapping.date));
      if (date == null) continue;

      double? amount;
      var isCredit = false;
      if (mapping.amount >= 0) {
        amount = _parseAmount(at(mapping.amount));
        final typeCell = at(mapping.type).toLowerCase();
        isCredit = typeCell.contains('credit') ||
            typeCell.contains('cr') ||
            typeCell.contains('in') ||
            typeCell.contains('deposit') ||
            typeCell.contains('received') ||
            (amount != null && amount < 0
                ? false
                : typeCell.contains('debit')
                    ? false
                    : mapping.defaultCredit);
        if (amount != null && amount < 0) {
          amount = amount.abs();
          isCredit = false;
        }
      } else {
        final debit = _parseAmount(at(mapping.debit));
        final credit = _parseAmount(at(mapping.credit));
        if (credit != null && credit > 0) {
          amount = credit;
          isCredit = true;
        } else if (debit != null && debit > 0) {
          amount = debit;
          isCredit = false;
        }
      }
      if (amount == null || amount <= 0) continue;

      final narration = [
        at(mapping.narration),
        at(mapping.details),
      ].where((s) => s.isNotEmpty).join(' — ');
      final charges = _parseAmount(at(mapping.charges)) ?? 0;
      final balance = _parseAmount(at(mapping.balance));
      final reference = at(mapping.reference);

      rows.add(
        StatementRow(
          date: date,
          amount: amount,
          narration: narration.isEmpty ? 'Statement transaction' : narration,
          isCredit: isCredit,
          charges: charges,
          balance: balance,
          reference: reference.isEmpty ? null : reference,
        ),
      );
    }
    return (rows, warnings);
  }

  static StatementRow? _parseLooseTransactionLine(String line) {
    final dateMatch = RegExp(
      r'(\d{1,4}[/-]\d{1,2}[/-]\d{1,4}|\d{1,2}\s+[A-Za-z]{3,9}\s+\d{2,4})',
    ).firstMatch(line);
    if (dateMatch == null) return null;
    final date = _parseDate(dateMatch.group(1)!);
    if (date == null) return null;

    final amounts = RegExp(r'(?<![A-Za-z])(-?\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?|-?\d+\.\d{1,2})')
        .allMatches(line)
        .map((m) => _parseAmount(m.group(1)!))
        .whereType<double>()
        .where((a) => a.abs() > 0)
        .toList();
    if (amounts.isEmpty) return null;

    final amount = amounts.first.abs();
    final lower = line.toLowerCase();
    final isCredit = lower.contains('credit') ||
        lower.contains(' deposit') ||
        lower.contains('received') ||
        lower.contains('cr ') ||
        RegExp(r'\bcr\b').hasMatch(lower);

    final narration = line
        .replaceFirst(dateMatch.group(0)!, '')
        .replaceAll(RegExp(r'-?\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return StatementRow(
      date: date,
      amount: amount,
      narration: narration.isEmpty ? 'Statement transaction' : narration,
      isCredit: isCredit,
    );
  }

  static _HeaderMap _mapHeaders(List<String> headers) {
    int find(List<String> keys) {
      for (var i = 0; i < headers.length; i++) {
        final h = headers[i];
        for (final k in keys) {
          if (h.contains(k)) return i;
        }
      }
      return -1;
    }

    return _HeaderMap(
      date: find(['date', 'trans date', 'txn date', 'value date', 'posted']),
      amount: find(['amount', 'amt', 'value', 'transaction amount']),
      debit: find(['debit', 'withdrawal', 'money out', 'paid out', 'dr']),
      credit: find(['credit', 'deposit', 'money in', 'paid in', 'cr']),
      narration: find([
        'narration',
        'description',
        'details',
        'particular',
        'memo',
        'payee',
        'transaction details',
      ]),
      details: find(['beneficiary', 'from', 'to', 'counterparty']),
      type: find(['type', 'nature', 'dr/cr', 'transaction type', 'status']),
      charges: find(['charge', 'fee', 'cost']),
      balance: find(['balance', 'running']),
      reference: find(['ref', 'receipt', 'code', 'id', 'transaction id']),
      defaultCredit: false,
    );
  }

  static DateTime? _parseDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    final formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('d/M/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('d-M-yyyy'),
      DateFormat('dd/MM/yy'),
      DateFormat('d/M/yy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('dd MMM yyyy'),
      DateFormat('d MMM yyyy'),
      DateFormat('dd MMMM yyyy'),
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('dd/MM/yyyy HH:mm'),
    ];
    for (final f in formats) {
      try {
        return f.parseLoose(s);
      } catch (_) {}
    }
    return DateTime.tryParse(s);
  }

  static double? _parseAmount(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return null;
    s = s
        .replaceAll('KES', '')
        .replaceAll('Ksh', '')
        .replaceAll('ksh', '')
        .replaceAll('USD', '')
        .replaceAll(RegExp(r'[^\d,.\-]'), '')
        .trim();
    if (s.isEmpty) return null;
    // European format 1.234,56 → 1234.56
    if (RegExp(r'^\d{1,3}(\.\d{3})+,\d+$').hasMatch(s)) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
    } else {
      s = s.replaceAll(',', '');
    }
    return double.tryParse(s);
  }

  static List<String> _splitCsvLine(String line, String delimiter) {
    final out = <String>[];
    final buf = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buf.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (ch == delimiter && !inQuotes) {
        out.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    out.add(buf.toString());
    return out;
  }
}

class _HeaderMap {
  const _HeaderMap({
    required this.date,
    required this.amount,
    required this.debit,
    required this.credit,
    required this.narration,
    required this.details,
    required this.type,
    required this.charges,
    required this.balance,
    required this.reference,
    required this.defaultCredit,
  });

  final int date;
  final int amount;
  final int debit;
  final int credit;
  final int narration;
  final int details;
  final int type;
  final int charges;
  final int balance;
  final int reference;
  final bool defaultCredit;
}
