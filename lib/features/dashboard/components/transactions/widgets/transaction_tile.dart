import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/local/transaction_allocation.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionTile extends StatefulWidget {
  final Transaction transaction;
  const TransactionTile(
      {super.key, required this.transaction, this.onTapCallback});

  final Function()? onTapCallback;

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  TransactionAllocationLink? _link;

  @override
  void initState() {
    super.initState();
    _loadLink();
  }

  @override
  void didUpdateWidget(covariant TransactionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transaction.transactionId !=
        widget.transaction.transactionId) {
      _loadLink();
    }
  }

  Future<void> _loadLink() async {
    final link = await service<LocalDataCache>()
        .loadTransactionLink(widget.transaction.transactionId);
    if (!mounted) return;
    setState(() => _link = link);
  }

  Wallet? _walletFor(List<Wallet> wallets) {
    final id = widget.transaction.walletId;
    if (id == null) return null;
    for (final w in wallets) {
      if (w.id == id || w.bankId == id) return w;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    TextTheme theme = Theme.of(context).textTheme;
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTapCallback,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: BlocBuilder<WalletsBloc, WalletsState>(
              buildWhen: (prev, next) => prev.wallets != next.wallets,
              builder: (context, walletsState) {
                final wallet = _walletFor(walletsState.wallets);
                return Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: AppColors.greyColor.withValues(alpha: 0.45),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: wallet != null
                      ? BankLogoImage(
                          name: wallet.name,
                          shortname: wallet.shortname,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          fallbackIconSize: 18,
                        )
                      : Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 18,
                          color: AppColors.darkBlueColor.withValues(alpha: 0.55),
                        ),
                );
              },
            ),
            title: Text(transaction.narration, style: theme.bodySmall),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTileDate(transaction.date ?? transaction.createdAt!),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
                if (_link != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${_link!.entityType.label}: ${_link!.entityName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: formatAmount(transaction.amount)),
                      ],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: transaction.type == TransactionType.credit
                              ? AppColors.primaryColor
                              : AppColors.dangerColor,
                          fontWeight: FontWeight.bold)),
                ),
                Text(
                  "Charge: ${transaction.currency} ${transaction.charges}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 10, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// formatt date
String formatTileDate(DateTime dateTime) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String time = "${dateTime.hour}:${dateTime.minute}";
  String amPm = dateTime.hour >= 12 ? "PM" : "AM";
  String month = months[dateTime.month - 1].substring(0, 3);

  String date = "$time $amPm, $month ${dateTime.day}";
  return date;
}
