import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/features/dashboard/components/home/wallet_detail.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final Wallet wallet;
  const WalletCard({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WalletDetail(wallet: wallet);
            },
          );
        },
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(alpha: 0.55),
                      AppColors.darkBlueColor.withValues(alpha: 0.35),
                    ],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: ClipOval(
                    child: BankLogoImage(
                      name: wallet.name,
                      shortname: wallet.shortname,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                wallet.shortname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
