import 'package:fedha/features/dashboard/components/home/widgets/autowallet_bottomsheet.dart';
import 'package:fedha/features/dashboard/components/home/widgets/wallet_form.dart';
import 'package:flutter/material.dart';

class AddWalletBottomSheet extends StatelessWidget {
  const AddWalletBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      StadiumBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    fixedSize: WidgetStateProperty.all(
                        const Size(double.infinity, 52)),
                  ),
                  onPressed: () => _handleAutomaticWallet(context),
                  child: const Text("Automatic"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all(
                        const Size(double.infinity, 52)),
                  ),
                  onPressed: () => _handleManualWallet(context),
                  child: const Text(
                    "Manual",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppBar().preferredSize.height),
        ],
      ),
    );
  }

  /// Opens SMS / payment-channel sync. Mono bank-link was removed, so this
  /// no longer depends on the dead [InitMono] handler.
  void _handleAutomaticWallet(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => const AccountSetupScreen(),
          fullscreenDialog: true,
        ),
      );
    });
  }

  void _handleManualWallet(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    navigator.pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(navigator.context).size;
      final double dialogWidth = screenSize.width * 0.9;
      final double dialogHeight = screenSize.height * 0.7;
      final double borderRadius = screenSize.width * 0.05;

      showDialog(
        context: navigator.context,
        builder: (BuildContext dialogContext) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: dialogWidth,
                maxHeight: dialogHeight,
              ),
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Theme.of(dialogContext).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: const WalletForm(),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
