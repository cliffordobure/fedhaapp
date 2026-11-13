import 'package:fedha/data/models/expense/expense.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/transaction_tile.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class CategoryExpenses extends StatelessWidget {
  const CategoryExpenses({super.key, required this.category});
  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: GroupedListView<Transaction, String>(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          elements: category.transactions,
          groupBy: (element) =>
              "${months[element.createdAt!.month - 1]}, ${element.createdAt!.year}",
          groupSeparatorBuilder: (String groupByValue) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                // margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  groupByValue,
                  style:
                      const TextStyle(color: Color(0xff919191), fontSize: 18),
                ),
              ),
            ],
          ),
          separator: const Divider(
            thickness: 0,
            height: 0,
          ),
          indexedItemBuilder: (context, element, index) {
            if (index < category.transactions.length) {
              return TransactionTile(transaction: category.transactions[index]);
            }
            // else if (state.hasMoreData) {
            //   // Display a loading indicator at the end of the list
            //   return Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: AppColors.primaryColor,
            //       ),
            //     ),
            //   );
            // }
            else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text("End of list"),
                ),
              ); // End of the list, no more items
            }
          },
          itemComparator: (item1, item2) => item1.id.compareTo(item2.id),
          useStickyGroupSeparators: true,
          floatingHeader: true,
          order: GroupedListOrder.ASC,
        ),
      ),
    );
  }
}
