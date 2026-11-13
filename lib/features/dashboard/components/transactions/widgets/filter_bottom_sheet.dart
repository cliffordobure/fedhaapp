import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/transactions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/dashboard/components/home/wallet_detail.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              RadioListTile<TransactionsFilter>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('All transactions'),
                value: TransactionsFilter.ALL,
                groupValue: state.currentFilter,
                onChanged: (value) {
                  context
                      .read<TransactionsBloc>()
                      .add(FilterByType(filter: value!));
                },
              ),
              const Divider(
                height: 0,
                color: Colors.black12,
              ),
              RadioListTile<TransactionsFilter>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Money Out'),
                value: TransactionsFilter.DEBIT,
                groupValue: state.currentFilter,
                onChanged: (value) {
                  context
                      .read<TransactionsBloc>()
                      .add(FilterByType(filter: value!));
                },
              ),
              const Divider(
                height: 0,
                color: Colors.black12,
              ),
              RadioListTile<TransactionsFilter>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Money In'),
                value: TransactionsFilter.CREDIT,
                groupValue: state.currentFilter,
                onChanged: (value) {
                  context
                      .read<TransactionsBloc>()
                      .add(FilterByType(filter: value!));
                },
              ),
              const Divider(
                height: 0,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Bank",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: const Color(
                          0xff919191,
                        ),
                        // fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              BlocBuilder<WalletsBloc, WalletsState>(
                builder: (context, state) {
                  if (state.status == ServiceStatus.loading) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }
                  if (state.status == ServiceStatus.loadingFailure) {
                    return SizedBox(
                      height: 100,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: const Center(
                          child: Text(
                            "An error occurred",
                          ),
                        ),
                      ),
                    );
                  }

                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 100, maxWidth: double.infinity),
                    child: state.wallets.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.wallets.length,
                            itemBuilder: (context, index) => walletItem(
                              wallet: state.wallets[index],
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("No wallets found"),
                          ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class walletItem extends StatelessWidget {
  const walletItem({super.key, required this.wallet});
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // return UpdateDeleteWallet(
              //   wallet: wallet,
              // );
              return WalletDetail(wallet: wallet);
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.greyColor,
              child: CircleAvatar(
                backgroundColor: AppColors.whiteColor,
                radius: 26,
                child: BankLogoImage(
                  name: wallet.name,
                  shortname: wallet.shortname,
                  fit: BoxFit.cover,
                  width: 52,
                  height: 52,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              wallet.shortname,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
