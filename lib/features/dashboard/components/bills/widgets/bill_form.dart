import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/bills/bill_types.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

const _suggestedBills = [
  'Rent',
  'Electricity',
  'Water',
  'Internet',
  'School fees',
  'Insurance',
  'Gas',
  'Phone',
];

/// Create / edit form for a tracked bill. Pass [bill] to edit.
class BillForm extends StatefulWidget {
  const BillForm({super.key, this.bill, this.initialTypeName});

  final Bill? bill;
  final String? initialTypeName;

  @override
  State<BillForm> createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  BillType? _type;
  Wallet? _wallet;

  bool get _isEdit => widget.bill != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bill?.name ?? '');
    _amountController = TextEditingController(
      text: widget.bill != null ? '${widget.bill!.amount}' : '',
    );
    final bills = context.read<BillsBloc>();
    if (bills.state.billTypes.isEmpty &&
        bills.state.formStatus != ServiceStatus.loading) {
      bills.add(NewBillForm());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final type = _type;
    final wallet = _wallet;
    if (type == null || wallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a frequency and a wallet')),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    final amount = _amountController.text.trim().replaceAll(',', '');
    // Bills reference the catalog wallet (`bank_id`), not the user wallet.
    final data = {
      'name': _nameController.text.trim(),
      'bill_type': type.id,
      'bill_type_name': type.name,
      'wallet_id': wallet.bankId,
      'wallet': wallet.name,
      'amount': amount,
    };
    final bloc = context.read<BillsBloc>();
    if (_isEdit) {
      bloc.add(EditBill(data, widget.bill!.id));
    } else {
      bloc.add(NewBill(data));
    }
    context.pop();
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete bill?'),
        content: Text('"${widget.bill!.name}" will stop being tracked.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BillsBloc>().add(DeleteBill(widget.bill!.id));
              context.pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: HomeDesign.expense),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: HomeDesign.ink),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEdit ? 'Edit bill' : 'New bill',
          style: HomeDesign.text(
            size: 17,
            weight: FontWeight.w700,
            color: HomeDesign.ink,
          ),
        ),
        actions: [
          if (_isEdit)
            IconButton(
              onPressed: _confirmDelete,
              icon: const Icon(LucideIcons.trash2, color: HomeDesign.expense),
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _label('Bill name'),
              TextFormField(
                controller: _nameController,
                readOnly: _isEdit,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration('e.g. Rent, Electricity'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a bill name' : null,
                onChanged: (_) => setState(() {}),
              ),
              if (!_isEdit) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestedBills.map((name) {
                    final selected = _nameController.text.trim().toLowerCase() ==
                        name.toLowerCase();
                    return ChoiceChip(
                      label: Text(name),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: HomeDesign.mint,
                      backgroundColor: const Color(0xFFF3F4F6),
                      side: BorderSide(
                        color: selected
                            ? HomeDesign.green
                            : const Color(0xFFE5E7EB),
                      ),
                      labelStyle: HomeDesign.text(
                        size: 12,
                        weight: FontWeight.w600,
                        color: selected ? HomeDesign.green : HomeDesign.ink,
                      ),
                      onSelected: (_) => setState(() {
                        _nameController.text = name;
                      }),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              _label('Amount (KES)'),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: _decoration('0'),
                validator: (v) {
                  final n = num.tryParse((v ?? '').replaceAll(',', ''));
                  if (n == null || n <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _label('How often is it paid?'),
              BlocBuilder<BillsBloc, BillsState>(
                buildWhen: (a, b) =>
                    a.billTypes != b.billTypes || a.formStatus != b.formStatus,
                builder: (context, state) {
                  final types = state.billTypes;
                  if (types.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(color: HomeDesign.green),
                    );
                  }
                  _type ??= _initialType(types);
                  return Row(
                    children: types.map((t) {
                      final selected = _type?.id == t.id;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: t == types.last ? 0 : 8),
                          child: _SegmentButton(
                            label: t.name,
                            selected: selected,
                            onTap: () => setState(() => _type = t),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              _label('Pay from'),
              BlocBuilder<WalletsBloc, WalletsState>(
                builder: (context, state) {
                  final wallets = state.wallets;
                  if (wallets.isEmpty) {
                    return Text(
                      state.status == ServiceStatus.loading
                          ? 'Loading wallets…'
                          : 'Add a wallet first to track bills.',
                      style:
                          HomeDesign.text(size: 13, color: HomeDesign.muted),
                    );
                  }
                  if (_wallet == null || !wallets.contains(_wallet)) {
                    _wallet = _initialWallet(wallets);
                  }
                  return DropdownButtonFormField<Wallet>(
                    value: _wallet,
                    isExpanded: true,
                    decoration: _decoration('Select wallet'),
                    items: wallets
                        .map((w) => DropdownMenuItem<Wallet>(
                              value: w,
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: BankLogoImage(
                                      name: w.name,
                                      shortname: w.shortname,
                                      height: 28,
                                      width: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      w.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: HomeDesign.text(
                                          size: 14, color: HomeDesign.ink),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (w) => setState(() => _wallet = w),
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeDesign.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isEdit ? 'Save changes' : 'Add bill',
                    style: HomeDesign.text(
                      size: 15,
                      weight: FontWeight.w700,
                      color: Colors.white,
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

  BillType _initialType(List<BillType> types) {
    final wanted = (widget.initialTypeName ?? 'Monthly').toLowerCase();
    for (final t in types) {
      if (t.name.toLowerCase() == wanted) return t;
    }
    return types.first;
  }

  Wallet _initialWallet(List<Wallet> wallets) {
    final name = widget.bill?.wallet.toLowerCase();
    if (name != null && name.isNotEmpty) {
      for (final w in wallets) {
        if (w.name.toLowerCase() == name) return w;
      }
    }
    return wallets.first;
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: HomeDesign.text(
            size: 13,
            weight: FontWeight.w600,
            color: HomeDesign.ink,
          ),
        ),
      );

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: HomeDesign.text(size: 14, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: _isEdit && hint.startsWith('e.g.')
          ? const Color(0xFFF8FAF9)
          : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border(const Color(0xFFE5E7EB)),
      enabledBorder: border(const Color(0xFFE5E7EB)),
      focusedBorder: border(HomeDesign.green, 1.4),
      errorBorder: border(HomeDesign.expense),
      focusedErrorBorder: border(HomeDesign.expense, 1.4),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? HomeDesign.mint : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? HomeDesign.green : const Color(0xFFE5E7EB),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: HomeDesign.text(
            size: 13,
            weight: FontWeight.w600,
            color: selected ? HomeDesign.green : HomeDesign.ink,
          ),
        ),
      ),
    );
  }
}
