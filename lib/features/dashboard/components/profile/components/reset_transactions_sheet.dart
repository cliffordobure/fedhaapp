import 'package:fedha/features/app/blocs/data_blocs/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/message_reading_service/scheduller.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Profile → Reset transactions: wipe cloud + local txs and pick SMS start date.
Future<void> showResetTransactionsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _ResetTransactionsSheet(),
  );
}

class _ResetTransactionsSheet extends StatefulWidget {
  const _ResetTransactionsSheet();

  @override
  State<_ResetTransactionsSheet> createState() =>
      _ResetTransactionsSheetState();
}

class _ResetTransactionsSheetState extends State<_ResetTransactionsSheet> {
  late DateTime _trackingStart;
  bool _busy = false;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default: start of current month — a sensible "clean slate" window.
    _trackingStart = DateTime(now.year, now.month, 1);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _trackingStart.isAfter(now) ? now : _trackingStart,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: 'Start tracking SMS from',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _trackingStart = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _runReset() async {
    if (_busy || !_confirmed) return;
    setState(() => _busy = true);
    showLoading('Resetting transactions…');
    try {
      final result = await resetTransactionsAndSmsTracking(
        trackingStart: _trackingStart,
        reimportSms: true,
      );
      if (!result.serverOk) {
        showError(
          result.serverError ??
              'Could not delete cloud transactions. Check your connection.',
        );
        return;
      }

      if (!mounted) return;
      // Reload UI from local DB (includes any SMS re-imported after wipe).
      // Do not ApplyLocalTransactions([]) — that would blank newly imported rows.
      context.read<TransactionsBloc>().add(RefreshTransactions());
      context.read<DataBloc>().add(StartDataBloc());

      showSuccess(
        'Reset done. Tracking SMS from ${DateFormat.yMMMd().format(_trackingStart)}.',
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      showError('Reset failed. Please try again.');
    } finally {
      EasyLoading.dismiss();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final dateLabel = DateFormat.yMMMMd().format(_trackingStart);

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.dangerColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.rotateCcw,
                      color: AppColors.dangerColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reset transactions',
                      style: TextStyle(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Deletes all transactions from this phone and from the cloud, '
                'then re-imports bank/M-Pesa SMS starting from the date you choose. '
                'Wallets, budgets, goals, and planned payments are kept.',
                style: TextStyle(
                  color: AppColors.fadeBlackColor,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Start tracking SMS from',
                style: TextStyle(
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: _busy ? null : _pickDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            dateLabel,
                            style: TextStyle(
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronDown,
                          size: 18,
                          color: AppColors.fadeBlackColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _busy
                    ? null
                    : () => setState(() => _confirmed = !_confirmed),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _confirmed,
                        activeColor: AppColors.dangerColor,
                        onChanged: _busy
                            ? null
                            : (v) =>
                                setState(() => _confirmed = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'I understand this permanently deletes my transaction history.',
                          style: TextStyle(
                            color: AppColors.fadeBlackColor,
                            fontSize: 12.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_busy || !_confirmed) ? null : _runReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.dangerColor.withValues(alpha: 0.4),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _busy ? 'Resetting…' : 'Reset and restart SMS tracking',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.fadeBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
