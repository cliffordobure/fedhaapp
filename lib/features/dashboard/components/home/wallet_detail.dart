import 'package:fedha/common/fedha_gradient_header.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/wallet-details/wallet_details_bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/dashboard/components/home/widgets/bank_card.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum WalletAction { update, delete }

String _sanitizeField(String? value) {
  if (value == null) return '';
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return '';
  return trimmed;
}

class WalletDetail extends StatefulWidget {
  final Wallet wallet;
  final bool? income;

  const WalletDetail({super.key, required this.wallet, this.income});

  @override
  State<WalletDetail> createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  final ScrollController _scrollController = ScrollController();
  late Wallet _wallet;

  @override
  void initState() {
    super.initState();
    _wallet = widget.wallet;
    _scrollController.addListener(_onScroll);
    context
        .read<WalletDetailsBloc>()
        .add(FetchWalletDetails(walletId: _wallet.id));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange) {
      final state = context.read<WalletDetailsBloc>().state;
      if (state.status == ServiceStatus.loadingSuccess &&
          state.walletdetails?.transactions.nextPageUrl != null) {
        final nextPageNumber =
            state.walletdetails!.transactions.currentPage + 1;
        if (nextPageNumber <= state.walletdetails!.transactions.lastPage) {
          context.read<WalletDetailsBloc>().add(
                FetchMoreTransactions(
                  walletId: _wallet.id,
                  nextPage: nextPageNumber,
                ),
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletsBloc, WalletsState>(
      listenWhen: (prev, next) => prev.wallets != next.wallets,
      listener: (context, state) {
        final match = state.wallets.where((w) => w.id == _wallet.id);
        if (match.isNotEmpty) {
          setState(() => _wallet = match.first);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Column(
          children: [
            FedhaGradientHeader(
              title: _sanitizeField(_wallet.institutionName).isNotEmpty
                  ? _sanitizeField(_wallet.institutionName)
                  : _wallet.name,
              showBack: true,
              compact: true,
              onBack: () => context.pop(),
              badge: _sanitizeField(_wallet.currency).isEmpty
                  ? 'KES'
                  : _sanitizeField(_wallet.currency),
              trailing: PopupMenuButton<WalletAction>(
                icon: const Icon(LucideIcons.moreVertical, color: Colors.white),
                onSelected: _handleWalletAction,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: WalletAction.update,
                    child: Text('Update wallet'),
                  ),
                  PopupMenuItem(
                    value: WalletAction.delete,
                    child: Text(
                      'Delete wallet',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              subtitle: _headerSubtitle(),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  String? _headerSubtitle() {
    final name = _sanitizeField(_wallet.accountName);
    final type = _sanitizeField(_wallet.accountType);
    final parts = <String>[
      if (name.isNotEmpty) name,
      if (type.isNotEmpty) type,
    ];
    if (parts.isEmpty) return 'Wallet details & transactions';
    return parts.join(' · ');
  }

  void _handleWalletAction(WalletAction action) {
    switch (action) {
      case WalletAction.update:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          backgroundColor: AppColors.whiteColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: WalletUpdateForm(wallet: _wallet),
          ),
        );
      case WalletAction.delete:
        _showDeleteConfirmationDialog();
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete wallet'),
        content: const Text(
          'Are you sure you want to delete this wallet? '
          'All transactions and related data for this wallet will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.dangerColor),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<WalletsBloc>().add(DeleteWallet(wallletId: _wallet.id));
        context.pop();
      }
    });
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<WalletDetailsBloc, WallletDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case ServiceStatus.loading:
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          case ServiceStatus.loadingFailure:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.wifiOff,
                        size: 40, color: AppColors.fadeBlackColor),
                    const SizedBox(height: 12),
                    Text(
                      'Couldn’t load wallet details',
                      style: TextStyle(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.read<WalletDetailsBloc>().add(
                              FetchWalletDetails(walletId: _wallet.id),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          case ServiceStatus.loadingSuccess:
            return _buildWalletDetails(context, state);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildWalletDetails(BuildContext context, WallletDetailState state) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, txState) {
        final merged = _mergeWalletTransactions(
          server: state.walletdetails?.transactions.data ?? const [],
          local: txState.transactions,
        );
        final filteredTransactions = _filterTransactions(merged);
        final income = filteredTransactions
            .where((t) =>
                t.type == TransactionType.credit &&
                !narrationIsInternalTransfer(t.narration))
            .fold<double>(0, (s, t) => s + t.amount);
        final expense = filteredTransactions
            .where((t) =>
                t.type == TransactionType.debit &&
                !narrationIsInternalTransfer(t.narration))
            .fold<double>(0, (s, t) => s + t.amount + (t.charges ?? 0));

        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: BankCard(wallet: _wallet),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _buildQuickStats(income, expense, filteredTransactions.length),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      'Transactions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.darkBlueColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${filteredTransactions.length}',
                      style: TextStyle(
                        color: AppColors.fadeBlackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (filteredTransactions.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyTransactions())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.separated(
                  itemCount: filteredTransactions.length +
                      (state.walletdetails?.transactions.nextPageUrl != null
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index < filteredTransactions.length) {
                      return _TransactionCard(
                        transaction: filteredTransactions[index],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStats(double income, double expense, int count) {
    final symbol = _sanitizeField(_wallet.currency).isEmpty
        ? 'KES '
        : '${_sanitizeField(_wallet.currency)} ';
    final money = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
    return Row(
      children: [
        Expanded(
          child: _statChip(
            label: 'Income',
            value: money.format(income),
            color: AppColors.primaryColor,
            icon: LucideIcons.arrowUpRight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statChip(
            label: 'Expense',
            value: money.format(expense),
            color: AppColors.dangerColor,
            icon: LucideIcons.arrowDownRight,
          ),
        ),
      ],
    );
  }

  Widget _statChip({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.darkBlueColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.receipt,
              color: AppColors.darkBlueColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'SMS transfers for this wallet show here after inbox sync.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.fadeBlackColor,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> _mergeWalletTransactions({
    required List<Transaction> server,
    required List<Transaction> local,
  }) {
    // Cloud/SMS rows may store bank catalog id; wallet screens use row id.
    final walletIds = {_wallet.id, _wallet.bankId};
    final byCode = <String, Transaction>{};
    for (final t in server) {
      if (t.transactionId.isNotEmpty) byCode[t.transactionId] = t;
    }
    for (final t in local.where(
      (tx) => tx.walletId != null && walletIds.contains(tx.walletId),
    )) {
      if (t.transactionId.isNotEmpty) {
        byCode[t.transactionId] = t;
      }
    }
    final merged = byCode.values.toList()
      ..sort((a, b) {
        final ad =
            a.date ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd =
            b.date ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
    return merged;
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (widget.income == null) return transactions;
    return transactions
        .where((t) =>
            t.type ==
            (widget.income! ? TransactionType.credit : TransactionType.debit))
        .toList();
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueColor.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TransactionTile(transaction: transaction),
    );
  }
}

class WalletUpdateForm extends StatefulWidget {
  final Wallet wallet;

  const WalletUpdateForm({super.key, required this.wallet});

  @override
  State<WalletUpdateForm> createState() => _WalletUpdateFormState();
}

class _WalletUpdateFormState extends State<WalletUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  Bank? selectedBank;
  Currency? selectedCurrency;
  final TextEditingController _accNameController = TextEditingController();
  final TextEditingController _accNumberController = TextEditingController();
  final TextEditingController _accTypeController = TextEditingController();
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _accNameController.text = _sanitizeField(widget.wallet.accountName);
    _accNumberController.text = _sanitizeField(widget.wallet.accountNumber);
    _accTypeController.text = _sanitizeField(widget.wallet.accountType);
  }

  @override
  void dispose() {
    _accNameController.dispose();
    _accNumberController.dispose();
    _accTypeController.dispose();
    super.dispose();
  }

  void _seedSelections(WalletsState state) {
    if (_seeded) return;
    if (state.banks.isEmpty && state.currencies.isEmpty) return;

    Bank? bank;
    for (final b in state.banks) {
      if (b.id == widget.wallet.bankId) {
        bank = b;
        break;
      }
    }

    final walletCurrency = _sanitizeField(widget.wallet.currency);
    Currency? currency;
    for (final c in state.currencies) {
      if (walletCurrency.isNotEmpty &&
          (c.symbol.toUpperCase() == walletCurrency.toUpperCase() ||
              c.name.toUpperCase() == walletCurrency.toUpperCase())) {
        currency = c;
        break;
      }
    }
    if (currency == null) {
      for (final c in state.currencies) {
        if (c.symbol.toUpperCase() == 'KES') {
          currency = c;
          break;
        }
      }
    }
    currency ??= state.currencies.isNotEmpty ? state.currencies.first : null;

    setState(() {
      selectedBank ??= bank;
      selectedCurrency ??= currency;
      _seeded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _seedSelections(state);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update ${widget.wallet.name}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep account details accurate for better tracking.',
                  style: TextStyle(
                    color: AppColors.fadeBlackColor,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Institution',
                  style: _labelStyle(context),
                ),
                const SizedBox(height: 8),
                if (state.status == ServiceStatus.loading &&
                    state.banks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  DropdownButtonFormField<Bank>(
                    value: selectedBank != null &&
                            state.banks.any((b) => b.id == selectedBank!.id)
                        ? state.banks.firstWhere((b) => b.id == selectedBank!.id)
                        : null,
                    items: state.banks
                        .map(
                          (e) => DropdownMenuItem<Bank>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => selectedBank = value),
                    validator: (value) {
                      if (selectedBank == null || value == null) {
                        return 'Please select a bank';
                      }
                      return null;
                    },
                    decoration: getDropDownDecoration(
                      context,
                      true,
                      "Select Institution's name",
                    ),
                  ),
                DefaultInputField(
                  inputAction: TextInputAction.next,
                  textEditingController: _accNameController,
                  title: "Account holder's name",
                  hide: false,
                  validator: (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'Account name is required';
                    }
                    return null;
                  },
                  onSaved: (_) {},
                  hintText: "John's wallet",
                ),
                const SizedBox(height: 4),
                Text('Currency', style: _labelStyle(context)),
                const SizedBox(height: 8),
                DropdownButtonFormField<Currency>(
                  value: selectedCurrency != null &&
                          state.currencies
                              .any((c) => c.id == selectedCurrency!.id)
                      ? state.currencies
                          .firstWhere((c) => c.id == selectedCurrency!.id)
                      : null,
                  items: state.currencies
                      .map(
                        (e) => DropdownMenuItem<Currency>(
                          value: e,
                          child: Text('${e.symbol} — ${e.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedCurrency = value),
                  validator: (value) {
                    if (selectedCurrency == null || value == null) {
                      return 'Please select a currency';
                    }
                    return null;
                  },
                  decoration: getDropDownDecoration(
                    context,
                    true,
                    "Select wallet's currency",
                  ),
                ),
                DefaultInputField(
                  inputAction: TextInputAction.next,
                  textEditingController: _accNumberController,
                  title: 'Account number',
                  hide: false,
                  validator: (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'Account number is required';
                    }
                    if (onValidateVal.trim().toLowerCase() == 'null') {
                      return 'Enter a valid account number';
                    }
                    return null;
                  },
                  onSaved: (_) {},
                  hintText: 'e.g. 0123456789',
                ),
                DefaultInputField(
                  inputAction: TextInputAction.done,
                  textEditingController: _accTypeController,
                  title: 'Account type',
                  hide: false,
                  validator: (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'Account type is required';
                    }
                    return null;
                  },
                  onSaved: (_) {},
                  hintText: 'Savings Account',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.fadeBlackColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          'Update',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          color: const Color(0XFF555555),
          fontWeight: FontWeight.bold,
        );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null ||
        !form.validate() ||
        selectedBank == null ||
        selectedCurrency == null) {
      showError('Fill the form correctly');
      return;
    }

    // Backend expects currency as a STRING symbol (e.g. "KES"), not the id.
    final data = <String, dynamic>{
      'account_number': _accNumberController.text.trim(),
      'institution_name': selectedBank!.name,
      'account_name': _accNameController.text.trim(),
      'currency': selectedCurrency!.symbol,
      'account_type': _accTypeController.text.trim(),
      'bank_id': selectedBank!.id,
    };

    context.read<WalletsBloc>().add(
          UpdateManualWallet(walletId: widget.wallet.id, data: data),
        );
    context.pop();
  }
}
