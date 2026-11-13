import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/features/dashboard/components/analytics/sections/analytics_report_service.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

Future<void> showAnalyticsReportSheet({
  required BuildContext context,
  required List<Transaction> transactions,
  required List<Wallet> wallets,
  required DateTime? startDate,
  required DateTime? endDate,
  required String periodLabel,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AnalyticsReportSheet(
      transactions: transactions,
      wallets: wallets,
      startDate: startDate,
      endDate: endDate,
      periodLabel: periodLabel,
    ),
  );
}

class _AnalyticsReportSheet extends StatefulWidget {
  const _AnalyticsReportSheet({
    required this.transactions,
    required this.wallets,
    required this.startDate,
    required this.endDate,
    required this.periodLabel,
  });

  final List<Transaction> transactions;
  final List<Wallet> wallets;
  final DateTime? startDate;
  final DateTime? endDate;
  final String periodLabel;

  @override
  State<_AnalyticsReportSheet> createState() => _AnalyticsReportSheetState();
}

class _AnalyticsReportSheetState extends State<_AnalyticsReportSheet> {
  AnalyticsReportFormat _format = AnalyticsReportFormat.pdf;
  bool _includeCategories = true;
  bool _includeAccounts = true;
  bool _includeTransactions = true;
  bool _busy = false;

  Future<void> _generate() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await AnalyticsReportService.generateAndShare(
        AnalyticsReportRequest(
          transactions: widget.transactions,
          wallets: widget.wallets,
          startDate: widget.startDate,
          endDate: widget.endDate,
          periodLabel: widget.periodLabel,
          format: _format,
          includeCategories: _includeCategories,
          includeAccounts: _includeAccounts,
          includeTransactions: _includeTransactions,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _format == AnalyticsReportFormat.pdf
                ? 'PDF report ready to share'
                : 'Excel (CSV) report ready to share',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not generate report: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: HomeDesign.expense,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(18, 12, 18, 16 + bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 14),
          Text(
            'Generate report',
            style: HomeDesign.text(
              size: 18,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Export insights for ${widget.periodLabel}. Choose PDF or Excel.',
            style: HomeDesign.text(size: 12.5, color: HomeDesign.muted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _FormatTile(
                  selected: _format == AnalyticsReportFormat.pdf,
                  icon: LucideIcons.fileText,
                  title: 'PDF',
                  subtitle: 'Printable summary',
                  onTap: () =>
                      setState(() => _format = AnalyticsReportFormat.pdf),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FormatTile(
                  selected: _format == AnalyticsReportFormat.excel,
                  icon: LucideIcons.sheet,
                  title: 'Excel',
                  subtitle: 'CSV spreadsheet',
                  onTap: () =>
                      setState(() => _format = AnalyticsReportFormat.excel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Include',
            style: HomeDesign.text(
              size: 13,
              weight: FontWeight.w700,
              color: HomeDesign.ink,
            ),
          ),
          const SizedBox(height: 4),
          _ToggleRow(
            label: 'Category breakdown',
            value: _includeCategories,
            onChanged: (v) => setState(() => _includeCategories = v),
          ),
          _ToggleRow(
            label: 'Account breakdown',
            value: _includeAccounts,
            onChanged: (v) => setState(() => _includeAccounts = v),
          ),
          _ToggleRow(
            label: 'Transaction list',
            value: _includeTransactions,
            onChanged: (v) => setState(() => _includeTransactions = v),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _busy ? null : _generate,
              icon: _busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.download, size: 16),
              label: Text(
                _busy ? 'Generating…' : 'Generate & share',
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeDesign.greenDeep,
                disabledBackgroundColor:
                    HomeDesign.greenDeep.withValues(alpha: 0.7),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? HomeDesign.mintSoft : const Color(0xFFF5F7F6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? HomeDesign.green : const Color(0xFFE5E7EB),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? HomeDesign.greenDeep : HomeDesign.muted,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: HomeDesign.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: HomeDesign.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: HomeDesign.text(size: 11, color: HomeDesign.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        label,
        style: HomeDesign.text(
          size: 13,
          weight: FontWeight.w500,
          color: HomeDesign.ink,
        ),
      ),
      value: value,
      activeTrackColor: HomeDesign.green,
      activeThumbColor: Colors.white,
      onChanged: onChanged,
    );
  }
}
