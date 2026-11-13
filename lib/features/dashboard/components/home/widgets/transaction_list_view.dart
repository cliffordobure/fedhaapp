import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_modal.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class TransactionListView extends StatelessWidget {
  final List<Transaction> transactions; // Your actual model
  final ScrollController? scrollController;

  const TransactionListView({
    super.key,
    required this.transactions,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return scrollController == null
        ? ListView.separated(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () =>
                  showTransactionDetailsModal(context, transactions[index]),
              child: TransactionTile(transaction: transactions[index]),
            ),
            separatorBuilder: (_, __) => Divider(
              height: 0,
              thickness: 0,
              color: AppColors.greyColor,
            ),
            itemCount: transactions.length.clamp(0, 10),
          )
        : ListView.separated(
            controller: scrollController, // Add the scroll controller here
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () =>
                  showTransactionDetailsModal(context, transactions[index]),
              child: TransactionTile(transaction: transactions[index]),
            ),
            separatorBuilder: (_, __) => Divider(
              height: 0,
              thickness: 0,
              color: AppColors.greyColor,
            ),
            itemCount: transactions.length,
          );
  }
}
