import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class MonthlyTransactions extends StatefulWidget {
  const MonthlyTransactions({
    super.key,
  });

  @override
  State<MonthlyTransactions> createState() => _MonthlyTransactionsState();
}

class _MonthlyTransactionsState extends State<MonthlyTransactions> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(
            child: Text("Failed to load transactions"),
          );
        }

        return Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).width -
                  AppBar().preferredSize.height),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: state.filteredTransactions.isNotEmpty
              ? GroupedListView<Transaction, String>(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  elements: state.filteredTransactions,
                  groupBy: (element) =>
                      "${months[element.createdAt!.month - 1]}, ${element.createdAt!.year}",
                  groupSeparatorBuilder: (String groupByValue) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          groupByValue,
                          style: const TextStyle(
                              color: Color(0xff919191), fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  separator: const Divider(
                    thickness: 0,
                    height: 0,
                  ),
                  indexedItemBuilder: (context, element, index) {
                    if (index < state.filteredTransactions.length) {
                      return TransactionTile(
                          transaction: state.filteredTransactions[index]);
                    } else if (state.hasMoreData) {
                      // Display a loading indicator at the end of the list
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text("End of list"),
                        ),
                      ); // End of the list, no more items
                    }
                  },
                  itemComparator: (item1, item2) =>
                      item1.id.compareTo(item2.id),
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  order: GroupedListOrder.ASC,
                )
              : const Center(
                  child: Text("No transactions recorded"),
                ),
        );
      },
    );
  }
}
