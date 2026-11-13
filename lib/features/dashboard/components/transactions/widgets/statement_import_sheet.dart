import 'dart:io';

import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/data/sync/sync_engine.dart';
import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/statement_import_parser.dart';
import 'package:fedha/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Opens statement import — fits under Transactions and Profile → SMS & history.
Future<void> showStatementImportSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _StatementImportSheet(),
  );
}

class _StatementImportSheet extends StatefulWidget {
  const _StatementImportSheet();

  @override
  State<_StatementImportSheet> createState() => _StatementImportSheetState();
}

class _StatementImportSheetState extends State<_StatementImportSheet> {
  Wallet? _wallet;
  StatementParseResult? _parsed;
  bool _busy = false;
  String? _error;

  List<Wallet> get _wallets => context.read<WalletsBloc>().state.wallets;

  Future<void> _pickFile() async {
    setState(() {
      _error = null;
      _parsed = null;
      _busy = true;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls', 'pdf', 'txt'],
        withData: true,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) {
        setState(() => _busy = false);
        return;
      }

      final file = result.files.single;
      final path = file.path;
      final bytes = file.bytes;

      late final StatementParseResult parsed;
      if (path != null && path.isNotEmpty) {
        parsed = await StatementImportParser.parseFile(File(path));
      } else if (bytes != null && bytes.isNotEmpty) {
        parsed = await StatementImportParser.parseBytes(
          bytes,
          fileName: file.name,
        );
      } else {
        setState(() {
          _busy = false;
          _error = 'Could not open that file on this device.';
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _busy = false;
        _parsed = parsed;
        if (parsed.rows.isEmpty) {
          _error = parsed.warnings.isNotEmpty
              ? parsed.warnings.join('\n')
              : 'No transactions found in the file.';
        }
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error =
            'File picker needs a full app restart after install. '
            'Stop the app completely, then run it again (hot reload is not enough).';
      });
      showError('Restart the app fully to enable file upload');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Could not open file: $e';
      });
    }
  }

  Future<void> _import() async {
    final parsed = _parsed;
    final wallet = _wallet;
    if (parsed == null || parsed.rows.isEmpty || wallet == null || _busy) {
      return;
    }

    setState(() => _busy = true);
    try {
      final cache = service<LocalDataCache>();
      final payloads = <TransactionData>[];
      for (final row in parsed.rows) {
        payloads.add(
          TransactionData(
            name: row.narration,
            wallet: wallet.id,
            amount: row.amount,
            charges: row.charges,
            datetime: row.date,
            code: row.stableCode,
            type: row.isCredit ? 'credit' : 'debit',
            currency: wallet.currency ?? 'KES',
          ),
        );
      }

      final localRows = LocalDataCache.fromTransactionData(payloads);
      final withBalance = <Transaction>[];
      for (var i = 0; i < localRows.length; i++) {
        final bal = parsed.rows[i].balance;
        withBalance.add(
          bal == null ? localRows[i] : localRows[i].copyWith(balance: bal),
        );
      }

      final known = await cache.existingTransactionCodes(
        withBalance.map((t) => t.transactionId),
      );
      final brandNew =
          withBalance.where((t) => !known.contains(t.transactionId)).toList();
      final newPayloads =
          payloads.where((p) => !known.contains(p.code)).toList();

      if (brandNew.isEmpty) {
        if (!mounted) return;
        showSuccess('All rows were already in Fedha — nothing new to import.');
        Navigator.of(context).pop();
        return;
      }

      await cache.mergeTransactions(
        brandNew,
        pendingSync: true,
        uploadPayloads: newPayloads,
      );

      if (!mounted) return;
      context.read<TransactionsBloc>().add(RefreshTransactions());
      context.read<DataBloc>().add(StartDataBloc());
      // Best-effort cloud sync — local rows are already visible.
      // ignore: unawaited_futures
      service<SyncEngine>().syncNow(forcePull: false);

      showSuccess(
        'Imported ${brandNew.length} transaction${brandNew.length == 1 ? '' : 's'}'
        '${known.isNotEmpty ? ' (${known.length} duplicates skipped)' : ''}',
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      showError('Import failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final wallets = _wallets;
    if (wallets.isNotEmpty) _wallet = wallets.first;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final money = NumberFormat.currency(symbol: 'KES ', decimalDigits: 0);
    final rows = _parsed?.rows ?? const <StatementRow>[];

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(18, 12, 18, 12 + bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Import statement',
            style: HomeDesign.text(
              size: 18,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload a bank or M-Pesa statement (Excel, CSV, or PDF). '
            'Rows are added to the selected wallet and used in analytics.',
            style: HomeDesign.text(
              size: 12.5,
              color: HomeDesign.muted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Wallet',
            style: HomeDesign.text(
              size: 13,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 6),
          if (_wallets.isEmpty)
            Text(
              'Add a wallet first, then import a statement into it.',
              style: HomeDesign.text(size: 12, color: HomeDesign.expense),
            )
          else
            DropdownButtonFormField<Wallet>(
              initialValue: _wallet,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: [
                for (final w in _wallets)
                  DropdownMenuItem(
                    value: w,
                    child: Text(
                      w.institutionName?.isNotEmpty == true
                          ? w.institutionName!
                          : w.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (w) => setState(() => _wallet = w),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _pickFile,
            icon: const Icon(LucideIcons.upload, size: 16),
            label: Text(
              _parsed == null ? 'Choose PDF / Excel / CSV' : 'Choose another file',
              style: HomeDesign.text(
                size: 13,
                weight: FontWeight.w600,
                color: HomeDesign.greenDeep,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: HomeDesign.greenDeep,
              side: const BorderSide(color: HomeDesign.greenDeep),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (_busy) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: HomeDesign.text(size: 12, color: HomeDesign.expense),
            ),
          ],
          if (_parsed != null && rows.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${rows.length} transaction${rows.length == 1 ? '' : 's'} ready'
              ' · ${_parsed!.sourceName}',
              style: HomeDesign.text(
                size: 12.5,
                weight: FontWeight.w600,
                color: HomeDesign.ink,
              ),
            ),
            if (_parsed!.warnings.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _parsed!.warnings.join(' '),
                style: HomeDesign.text(size: 11, color: HomeDesign.muted),
              ),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: rows.length.clamp(0, 80),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF0F1F3)),
                itemBuilder: (context, i) {
                  final r = rows[i];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      r.narration,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeDesign.text(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: HomeDesign.ink,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('d MMM yyyy').format(r.date),
                      style:
                          HomeDesign.text(size: 11, color: HomeDesign.muted),
                    ),
                    trailing: Text(
                      '${r.isCredit ? '+' : '-'}${money.format(r.amount)}',
                      style: HomeDesign.text(
                        size: 12.5,
                        weight: FontWeight.w700,
                        color: r.isCredit
                            ? HomeDesign.income
                            : HomeDesign.expense,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (rows.length > 80)
              Text(
                'Showing first 80 of ${rows.length} — all will be imported.',
                style: HomeDesign.text(size: 11, color: HomeDesign.muted),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: (_busy || _wallet == null) ? null : _import,
              icon: const Icon(LucideIcons.check, size: 16),
              label: Text(
                'Import ${rows.length} into Fedha',
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeDesign.greenDeep,
                disabledBackgroundColor:
                    HomeDesign.greenDeep.withValues(alpha: 0.65),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ] else
            const Spacer(),
        ],
      ),
    );
  }
}
