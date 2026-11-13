// ignore_for_file: library_private_types_in_public_api

import 'package:fedha/data/models/user_budgets/user_budgets.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/user_budget/bloc.dart';
import 'package:fedha/features/dashboard/components/planning/widgets/budget_bottomsheet.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.value,
    required this.indicatorColor,
    required this.iconBgColor,
    required this.description,
    required this.widget,
    required this.budget,
  }) : super(key: key);

  final String text, description;
  final double value;
  final Color indicatorColor;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback onPressed;
  final Widget widget;
  final UserBudget budget;

  @override
  _BudgetCardState createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlueColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildMeta(),
            const SizedBox(height: 8),
            _buildDescription(context),
            const SizedBox(height: 10),
            _buildProgressIndicator(),
            _buildBudgetAmounts(),
            const SizedBox(height: 6),
            widget.widget,
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: 8),
        Expanded(child: _buildTitle()),
        _buildExpandButton(context),
      ],
    );
  }

  Container _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.iconBgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        widget.icon,
        color: Colors.white,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _showMenu(context),
          icon: const Icon(Icons.more_vert),
          color: AppColors.fadeBlackColor,
        ),
        IconButton(
          onPressed: widget.onPressed,
          icon: const Icon(LucideIcons.chevronRight, size: 20),
          color: AppColors.fadeBlackColor,
        ),
      ],
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromLTRB(
      button.size.width / 2,
      button.size.height,
      0,
      0,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
          onTap: () => _showEditBottomSheet(context),
        ),
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
          onTap: () => _deleteBudget(context),
        ),
        // PopupMenuItem(
        //   child: const Row(
        //     children: [
        //       Icon(Icons.group_add),
        //       SizedBox(width: 8),
        //       Text('Invite User'),
        //     ],
        //   ),
        //   onTap: () {
        //     // We need to close the menu before showing the modal
        //     // Navigator.of(context).pop();
        //     // Show the invite user modal
        //     // showDialog(
        //     //   context: context,
        //     //   builder: (BuildContext context) =>
        //     //       InviteUserModal(budget: widget.budget),
        //     // );
        //   },
        // ),
      ],
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: false,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: NewBudgetBottomSheet(
            update: true,
            budget: widget.budget,
          ),
        );
      },
    );
  }

  void _deleteBudget(BuildContext context) {
    context
        .read<UserBudgetBloc>()
        .add(DeleteUserBudgetEvent(widget.budget.id ?? 0));
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.description,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  LinearProgressIndicator _buildProgressIndicator() {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(5),
      value: widget.value,
      minHeight: 7,
      backgroundColor: Colors.grey[300],
      color: widget.indicatorColor,
    );
  }

  Widget _buildMeta() {
    final period = (widget.budget.resetPeriod ?? '').trim();
    final account = (widget.budget.associatedWallet ?? '').trim();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _metaChip(
            LucideIcons.calendar,
            period.isEmpty
                ? 'No period'
                : '${period[0].toUpperCase()}${period.substring(1)}',
          ),
          _metaChip(
            LucideIcons.flag,
            'Limit Ksh ${_money(widget.budget.budgetLimitAmount)}',
          ),
          _metaChip(
            LucideIcons.landmark,
            account.isEmpty ? 'No account' : account,
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.fadeBlackColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  static String _money(String? raw) {
    final v = double.tryParse((raw ?? '').replaceAll(',', '')) ?? 0;
    final whole = v.round().toString();
    return whole.replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  }

  Row _buildBudgetAmounts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Spent Ksh ${_money(widget.budget.amount)}",
          style: const TextStyle(fontSize: 10),
        ),
        Text(
          "Limit Ksh ${_money(widget.budget.budgetLimitAmount)}",
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class InviteUserModal extends StatefulWidget {
  final UserBudget budget;

  const InviteUserModal({super.key, required this.budget});

  @override
  _InviteUserModalState createState() => _InviteUserModalState();
}

class _InviteUserModalState extends State<InviteUserModal> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _selectedPermission = 'read_only';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Invite User',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter user email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPermission,
              decoration: InputDecoration(
                labelText: 'Permissions',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'edit_budget', child: Text('Edit Budget')),
                DropdownMenuItem(
                    value: 'add_read_transactions',
                    child: Text('Add and Read Transactions')),
                DropdownMenuItem(value: 'read_only', child: Text('Read Only')),
              ],
              onChanged: (value) =>
                  setState(() => _selectedPermission = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _inviteUser,
          child: const Text(
            'Invite',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _inviteUser() {
    if (_formKey.currentState!.validate()) {
      // Implement the invite logic here
      logger
          .info('Inviting user: $_email with permission: $_selectedPermission');
      Navigator.of(context).pop();
    }
  }
}
