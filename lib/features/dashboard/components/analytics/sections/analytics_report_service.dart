import 'dart:io';

import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_compute.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

enum AnalyticsReportFormat { pdf, excel }

class AnalyticsReportRequest {
  const AnalyticsReportRequest({
    required this.transactions,
    required this.wallets,
    required this.startDate,
    required this.endDate,
    required this.periodLabel,
    required this.format,
    this.includeTransactions = true,
    this.includeCategories = true,
    this.includeAccounts = true,
  });

  final List<Transaction> transactions;
  final List<Wallet> wallets;
  final DateTime? startDate;
  final DateTime? endDate;
  final String periodLabel;
  final AnalyticsReportFormat format;
  final bool includeTransactions;
  final bool includeCategories;
  final bool includeAccounts;
}

class AnalyticsReportService {
  AnalyticsReportService._();

  static final _money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 2);
  static final _date = DateFormat('d MMM yyyy');
  static final _dateTime = DateFormat('d MMM yyyy, HH:mm');

  static Future<File> generate(AnalyticsReportRequest request) async {
    final names = await _loadCategoryNames();
    final data = _buildData(request, names);
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    if (request.format == AnalyticsReportFormat.pdf) {
      final file = File('${dir.path}/fedha_analytics_$stamp.pdf');
      await file.writeAsBytes(await _buildPdf(request, data));
      return file;
    }
    final file = File('${dir.path}/fedha_analytics_$stamp.csv');
    await file.writeAsString(_buildCsv(request, data), flush: true);
    return file;
  }

  static Future<void> generateAndShare(AnalyticsReportRequest request) async {
    final file = await generate(request);
    final mime = request.format == AnalyticsReportFormat.pdf
        ? 'application/pdf'
        : 'text/csv';
    await Share.shareXFiles(
      [XFile(file.path, mimeType: mime, name: file.uri.pathSegments.last)],
      subject: 'Fedha analytics report — ${request.periodLabel}',
      text:
          'Fedha analytics report for ${request.periodLabel} (${_rangeLabel(request)}).',
    );
  }

  static String _rangeLabel(AnalyticsReportRequest r) {
    final range = analyticsRange(r.startDate, r.endDate);
    return '${_date.format(range.start)} – ${_date.format(range.end)}';
  }

  static Future<Map<int, String>> _loadCategoryNames() async {
    final cache = service<LocalDataCache>();
    final map = <int, String>{};
    final income = await cache.loadIncomeCategories() ?? const [];
    final expense = await cache.loadExpenseCategories();
    for (final c in income) {
      map[c.id] = c.name;
    }
    for (final c in expense?.data ?? const []) {
      map[c.id] = c.name;
    }
    return map;
  }

  static _ReportData _buildData(
    AnalyticsReportRequest request,
    Map<int, String> names,
  ) {
    final totals = totalsFor(
      txs: request.transactions,
      start: request.startDate,
      end: request.endDate,
    );
    final prev = previousPeriodTotals(
      txs: request.transactions,
      start: request.startDate,
      end: request.endDate,
    );
    final incomeCats = categoryBreakdown(
      txs: request.transactions,
      start: request.startDate,
      end: request.endDate,
      type: TransactionType.credit,
      categoryNames: names,
      limit: 20,
    );
    final expenseCats = categoryBreakdown(
      txs: request.transactions,
      start: request.startDate,
      end: request.endDate,
      type: TransactionType.debit,
      categoryNames: names,
      limit: 20,
    );
    final months = monthlyBuckets(txs: request.transactions, count: 6);
    final accounts = <_AccountRow>[];
    for (final w in request.wallets) {
      final t = totalsFor(
        txs: request.transactions,
        start: request.startDate,
        end: request.endDate,
        walletId: w.id,
      );
      final name = w.institutionName?.isNotEmpty == true
          ? w.institutionName!
          : w.name;
      accounts.add(_AccountRow(name: name, income: t.income, expense: t.expense));
    }
    final range = analyticsRange(request.startDate, request.endDate);
    final txs = request.transactions.where((t) {
      if (narrationIsInternalTransfer(t.narration)) return false;
      final d = t.date ?? t.createdAt;
      if (d == null) return true;
      return !d.isBefore(range.start) && !d.isAfter(range.end);
    }).toList()
      ..sort((a, b) {
        final ad = a.date ?? a.createdAt ?? DateTime(1970);
        final bd = b.date ?? b.createdAt ?? DateTime(1970);
        return bd.compareTo(ad);
      });

    return _ReportData(
      totals: totals,
      previous: prev,
      incomeCats: incomeCats,
      expenseCats: expenseCats,
      months: months,
      accounts: accounts,
      transactions: txs,
    );
  }

  static Future<List<int>> _buildPdf(
    AnalyticsReportRequest request,
    _ReportData data,
  ) async {
    final doc = pw.Document();
    final range = _rangeLabel(request);
    final green = PdfColor.fromInt(0xFF0B3D2E);
    final muted = PdfColor.fromInt(0xFF6B7280);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Fedha Analytics Report',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: green,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${request.periodLabel} · $range',
              style: pw.TextStyle(fontSize: 11, color: muted),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(color: PdfColor.fromInt(0xFFE5E7EB)),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (ctx) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated ${_dateTime.format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 9, color: muted),
            ),
            pw.Text(
              'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: muted),
            ),
          ],
        ),
        build: (ctx) => [
          pw.Text('Summary',
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold, color: green)),
          pw.SizedBox(height: 8),
          _pdfKv('Total income', _money.format(data.totals.income)),
          _pdfKv('Total expense', _money.format(data.totals.expense)),
          _pdfKv('Net cashflow', _money.format(data.totals.net)),
          _pdfKv(
            'Savings rate',
            '${(data.totals.savingsRate * 100).toStringAsFixed(1)}%',
          ),
          _pdfKv(
            'vs previous period (net)',
            '${pctChange(data.totals.net, data.previous.net).toStringAsFixed(1)}%',
          ),
          pw.SizedBox(height: 16),
          pw.Text('6-month snapshot',
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold, color: green)),
          pw.SizedBox(height: 8),
          _pdfTable(
            headers: const ['Month', 'Income', 'Expense', 'Net'],
            rows: [
              for (final m in data.months)
                [
                  m.label,
                  _money.format(m.income),
                  _money.format(m.expense),
                  _money.format(m.net),
                ],
            ],
          ),
          if (request.includeCategories) ...[
            pw.SizedBox(height: 16),
            pw.Text('Income by category',
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: green)),
            pw.SizedBox(height: 8),
            if (data.incomeCats.isEmpty)
              pw.Text('No income categories in this period.',
                  style: pw.TextStyle(fontSize: 10, color: muted))
            else
              _pdfTable(
                headers: const ['Category', 'Amount'],
                rows: [
                  for (final c in data.incomeCats)
                    [c.name, _money.format(c.amount)],
                ],
              ),
            pw.SizedBox(height: 16),
            pw.Text('Expense by category',
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: green)),
            pw.SizedBox(height: 8),
            if (data.expenseCats.isEmpty)
              pw.Text('No expense categories in this period.',
                  style: pw.TextStyle(fontSize: 10, color: muted))
            else
              _pdfTable(
                headers: const ['Category', 'Amount'],
                rows: [
                  for (final c in data.expenseCats)
                    [c.name, _money.format(c.amount)],
                ],
              ),
          ],
          if (request.includeAccounts) ...[
            pw.SizedBox(height: 16),
            pw.Text('By account',
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: green)),
            pw.SizedBox(height: 8),
            if (data.accounts.isEmpty)
              pw.Text('No wallets available.',
                  style: pw.TextStyle(fontSize: 10, color: muted))
            else
              _pdfTable(
                headers: const ['Account', 'Income', 'Expense', 'Net'],
                rows: [
                  for (final a in data.accounts)
                    [
                      a.name,
                      _money.format(a.income),
                      _money.format(a.expense),
                      _money.format(a.income - a.expense),
                    ],
                ],
              ),
          ],
          if (request.includeTransactions) ...[
            pw.SizedBox(height: 16),
            pw.Text('Transactions',
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: green)),
            pw.SizedBox(height: 8),
            if (data.transactions.isEmpty)
              pw.Text('No transactions in this period.',
                  style: pw.TextStyle(fontSize: 10, color: muted))
            else
              _pdfTable(
                headers: const ['Date', 'Type', 'Narration', 'Amount'],
                rows: [
                  for (final t in data.transactions.take(200))
                    [
                      _date.format(t.date ?? t.createdAt ?? DateTime.now()),
                      t.type == TransactionType.credit ? 'Income' : 'Expense',
                      (t.narration.trim().isEmpty ? 'Transaction' : t.narration)
                          .replaceAll('\n', ' '),
                      _money.format(
                        t.type == TransactionType.credit
                            ? t.amount
                            : t.amount + (t.charges ?? 0),
                      ),
                    ],
                ],
              ),
            if (data.transactions.length > 200)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 6),
                child: pw.Text(
                  'Showing first 200 of ${data.transactions.length} transactions. Export Excel for the full list.',
                  style: pw.TextStyle(fontSize: 9, color: muted),
                ),
              ),
          ],
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _pdfKv(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(k, style: const pw.TextStyle(fontSize: 11)),
          pw.Text(v,
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _pdfTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF0B3D2E),
      ),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      border: pw.TableBorder.all(color: PdfColor.fromInt(0xFFE5E7EB), width: 0.4),
    );
  }

  static String _buildCsv(
    AnalyticsReportRequest request,
    _ReportData data,
  ) {
    final buf = StringBuffer();
    void row(List<Object?> cells) {
      buf.writeln(cells.map(_csvCell).join(','));
    }

    row(['Fedha Analytics Report']);
    row(['Period', request.periodLabel]);
    row(['Range', _rangeLabel(request)]);
    row(['Generated', _dateTime.format(DateTime.now())]);
    row([]);
    row(['Summary']);
    row(['Metric', 'Value']);
    row(['Total income', data.totals.income]);
    row(['Total expense', data.totals.expense]);
    row(['Net cashflow', data.totals.net]);
    row(['Savings rate %', (data.totals.savingsRate * 100).toStringAsFixed(2)]);
    row([
      'Net change vs previous %',
      pctChange(data.totals.net, data.previous.net).toStringAsFixed(2),
    ]);
    row([]);
    row(['6-month snapshot']);
    row(['Month', 'Income', 'Expense', 'Net']);
    for (final m in data.months) {
      row([m.label, m.income, m.expense, m.net]);
    }

    if (request.includeCategories) {
      row([]);
      row(['Income by category']);
      row(['Category', 'Amount']);
      for (final c in data.incomeCats) {
        row([c.name, c.amount]);
      }
      row([]);
      row(['Expense by category']);
      row(['Category', 'Amount']);
      for (final c in data.expenseCats) {
        row([c.name, c.amount]);
      }
    }

    if (request.includeAccounts) {
      row([]);
      row(['By account']);
      row(['Account', 'Income', 'Expense', 'Net']);
      for (final a in data.accounts) {
        row([a.name, a.income, a.expense, a.income - a.expense]);
      }
    }

    if (request.includeTransactions) {
      row([]);
      row(['Transactions']);
      row(['Date', 'Type', 'Narration', 'Amount', 'Charges', 'Wallet ID']);
      for (final t in data.transactions) {
        row([
          (t.date ?? t.createdAt)?.toIso8601String() ?? '',
          t.type == TransactionType.credit ? 'Income' : 'Expense',
          t.narration,
          t.amount,
          t.charges ?? 0,
          t.walletId ?? '',
        ]);
      }
    }

    // UTF-8 BOM helps Excel detect encoding on Windows.
    return '\uFEFF$buf';
  }

  static String _csvCell(Object? value) {
    final s = '${value ?? ''}';
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }
}

class _ReportData {
  const _ReportData({
    required this.totals,
    required this.previous,
    required this.incomeCats,
    required this.expenseCats,
    required this.months,
    required this.accounts,
    required this.transactions,
  });

  final AnalyticsTotals totals;
  final AnalyticsTotals previous;
  final List<CategorySlice> incomeCats;
  final List<CategorySlice> expenseCats;
  final List<TimeBucket> months;
  final List<_AccountRow> accounts;
  final List<Transaction> transactions;
}

class _AccountRow {
  const _AccountRow({
    required this.name,
    required this.income,
    required this.expense,
  });
  final String name;
  final double income;
  final double expense;
}
