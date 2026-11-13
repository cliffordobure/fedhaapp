import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/allocation_link_sheet.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/categorise_bottom_sheet.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

void showTransactionDetailsModal(
  BuildContext context,
  Transaction transaction,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (BuildContext context) {
      return BlocListener<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state.isCategoryUpdated) {
            context.read<TransactionsBloc>().add(StartTransactions());
            Navigator.of(context).pop();
          }
        },
        child: Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: TransactionDetailsContent(transaction: transaction),
        ),
      );
    },
  );
}

class TransactionDetailsContent extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailsContent({super.key, required this.transaction});

  @override
  State<TransactionDetailsContent> createState() =>
      _TransactionDetailsContentState();
}

class _TransactionDetailsContentState extends State<TransactionDetailsContent> {
  bool _isEditing = false;
  late TextEditingController _narrationController;
  late TextEditingController _amountController;
  TransactionAllocationLink? _link;

  bool get _isDebit => widget.transaction.type == TransactionType.debit;

  @override
  void initState() {
    super.initState();
    _narrationController =
        TextEditingController(text: widget.transaction.narration);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _loadLink();
  }

  Future<void> _loadLink() async {
    final link = await service<LocalDataCache>()
        .loadTransactionLink(widget.transaction.transactionId);
    if (!mounted) return;
    setState(() => _link = link);
  }

  @override
  void dispose() {
    _narrationController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  DateTime get _txDate =>
      widget.transaction.date ??
      widget.transaction.createdAt ??
      DateTime.now();

  Future<void> _saveEdits() async {
    final amount = double.tryParse(
          _amountController.text.replaceAll(',', ''),
        ) ??
        widget.transaction.amount;

    context.read<TransactionsBloc>().add(
          UpdateTransaction(
            transactionId: widget.transaction.id,
            transactionCode: widget.transaction.transactionId,
            narration: _narrationController.text.trim(),
            amount: amount,
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                children: [
                  _buildAmountCard(),
                  const SizedBox(height: 12),
                  _buildInfoCard(),
                  const SizedBox(height: 14),
                  _buildPrimaryButton(
                    icon: Icons.category_outlined,
                    label: widget.transaction.categoryId == null
                        ? 'Categorize transaction'
                        : 'Category: ${_getCategoryName(context, widget.transaction)}',
                    color: _isDebit
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CategorySelectionSheet(
                          transactionType: widget.transaction.type,
                          transactionId: widget.transaction.transactionId,
                        ),
                      );
                    },
                  ),
                  if (_isDebit) ...[
                    const SizedBox(height: 10),
                    _buildPrimaryButton(
                      icon: _link != null
                          ? Icons.link_rounded
                          : Icons.add_link_rounded,
                      label: _link != null
                          ? '${_link!.entityType.label}: ${_link!.entityName}'
                          : 'Link to bill / plan / budget / goal',
                      color: AppColors.darkBlueColor,
                      onTap: () async {
                        Navigator.pop(context);
                        await showAllocationLinkSheet(
                          context,
                          widget.transaction,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryButton(
                          icon: Icons.delete_outline_rounded,
                          label: 'Delete',
                          color: AppColors.dangerColor,
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirmationDialog();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSecondaryButton(
                          icon: Icons.ios_share_rounded,
                          label: 'Share',
                          color: AppColors.primaryColor,
                          onTap: _shareTransaction,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlueColor,
            AppColors.darkGreenColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _narrationController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Narration',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  )
                : Text(
                    widget.transaction.narration,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
          ),
          IconButton(
            onPressed: () async {
              if (_isEditing) {
                await _saveEdits();
              } else {
                setState(() => _isEditing = true);
              }
            },
            icon: Icon(
              _isEditing ? Icons.check_circle_rounded : Icons.edit_rounded,
              color: Colors.white,
            ),
            tooltip: _isEditing ? 'Save' : 'Edit',
          ),
          if (_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _narrationController.text = widget.transaction.narration;
                  _amountController.text =
                      widget.transaction.amount.toString();
                });
              },
              icon: const Icon(Icons.close_rounded, color: Colors.white70),
              tooltip: 'Cancel',
            )
          else
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded, color: Colors.white70),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    final accent = _isDebit ? AppColors.dangerColor : AppColors.primaryColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            _isDebit ? 'Expense' : 'Income',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          _isEditing
              ? TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                  decoration: InputDecoration(
                    prefixText: '${widget.transaction.currency ?? 'KES'} ',
                    prefixStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                )
              : Text(
                  '${_isDebit ? '-' : '+'} ${widget.transaction.currency ?? 'KES'} ${widget.transaction.amount}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final dateLabel = DateFormat('dd MMM yyyy · HH:mm').format(_txDate.toLocal());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _infoRow('Ref ID', widget.transaction.transactionId),
          const SizedBox(height: 10),
          _infoRow(
            'Charge',
            '${widget.transaction.currency ?? 'KES'} ${widget.transaction.charges ?? 0}',
          ),
          const SizedBox(height: 10),
          _infoRow('Date', dateLabel),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.fadeBlackColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.45), width: 1.4),
        backgroundColor: color.withValues(alpha: 0.06),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _shareTransaction() {
    final transactionType = _isDebit ? 'Expense' : 'Income';
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(_txDate);
    final categoryName = _getCategoryName(context, widget.transaction);
    final shareText = '''
Transaction Details:
Type: $transactionType
Amount: ${widget.transaction.currency} ${widget.transaction.amount}
Category: $categoryName
Narration: ${widget.transaction.narration}
Date: $formattedDate
Reference ID: ${widget.transaction.transactionId}

Check out the app here: https://app.fedhatrac.com
''';

    Share.share(shareText, subject: 'Transaction Details');
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm deletion'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: AppColors.dangerColor),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TransactionsBloc>().add(
                      DeleteTransaction(
                        transactionId: widget.transaction.id,
                        transactionCode: widget.transaction.transactionId,
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

String _getCategoryName(BuildContext context, Transaction transaction) {
  if (transaction.type == TransactionType.debit) {
    final categories = context.read<ExpenseBloc>().state.categories.data;
    final category = categories.firstWhere(
      (element) => element.id == transaction.categoryId,
      orElse: () => const category_.Category(
          id: -1,
          name: 'Uncategorized',
          subcategories: [],
          status: 1,
          type: 1,
          createdAt: '',
          updatedAt: ''),
    );
    return category.name;
  }

  final incomeTypes = context.read<IncomeBloc>().state.incomeTypes;
  final category = incomeTypes.firstWhere(
    (element) => element.id == transaction.categoryId,
    orElse: () => const category_.Category(
        id: -1,
        name: 'Uncategorized',
        subcategories: [],
        status: 1,
        type: 1,
        createdAt: '',
        updatedAt: ''),
  );
  return category.name;
}
