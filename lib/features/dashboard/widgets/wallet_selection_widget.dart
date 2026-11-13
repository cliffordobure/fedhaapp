import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletSelectionWidget extends StatelessWidget {
  final List<Wallet> wallets;
  final Wallet? selectedWallet;
  final void Function(Wallet?) onWalletSelected;

  const WalletSelectionWidget({
    Key? key,
    required this.wallets,
    required this.selectedWallet,
    required this.onWalletSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Associated Wallet",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: const Color(0XFF555555),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Wallet>(
          value: selectedWallet,
          items: wallets
              .map((e) => DropdownMenuItem<Wallet>(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: onWalletSelected,
          validator: (value) {
            if (selectedWallet == null || value == null) {
              return "Please select a wallet";
            }
            return null;
          },
          decoration: getDropDownDecoration(context, true, "Select wallet"),
        ),
      ],
    );
  }

  InputDecoration getDropDownDecoration(
      BuildContext context, bool isDropdown, String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding:
          EdgeInsets.symmetric(vertical: isDropdown ? 0 : 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
