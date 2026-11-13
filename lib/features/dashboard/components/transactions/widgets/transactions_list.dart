import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/transaction_list_view.dart';
import 'package:fedha/features/dashboard/components/transactions/widgets/statement_import_sheet.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({
    super.key,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // Trigger loading more transactions when scrolled near the bottom
        context.read<TransactionsBloc>().add(LoadNextPageEvent());
      }
    });
  }

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
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: state.filteredTransactions.isNotEmpty
              ? TransactionListView(
                  transactions: state.filteredTransactions,
                  scrollController: _scrollController,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No transactions recorded',
                          style: TextStyle(
                            color: AppColors.darkBlueColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SMS tracking starts from the day you install Fedha. '
                          'Import a bank statement to add earlier history.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.fadeBlackColor,
                            fontSize: 12.5,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton.icon(
                          onPressed: () => showStatementImportSheet(context),
                          icon: const Icon(Icons.upload_file_outlined, size: 18),
                          label: const Text('Import statement'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
