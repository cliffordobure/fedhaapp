import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WalletForm extends StatefulWidget {
  const WalletForm({super.key});

  @override
  State<WalletForm> createState() => _WalletFormState();
}

class _WalletFormState extends State<WalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMobile = GlobalKey<FormState>();

  Bank? selectedBank;
  Bank? selectedMobileBank;
  Currency? selectedBankCurrency;
  Currency? selectedMobileCurrency;

  final TextEditingController _accTypeController = TextEditingController();
  List<String> paymentModes = ["Mobile Money", "Bank"];

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("Bank Card",
                    style: theme.titleLarge!
                        .copyWith(fontSize: _getAdaptiveTextSize(context, 16))),
              ),
              Tab(
                child: Text("Mobile Money",
                    style: theme.titleLarge!
                        .copyWith(fontSize: _getAdaptiveTextSize(context, 16))),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBankForm(context),
            _buildMobileForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBankForm(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(_getAdaptivePadding(context)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, "Payment Channel"),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildBankDropdown(context),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildSectionTitle(context, "Currency"),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildCurrencyDropdown(context, true),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildFormButtons(context, true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileForm(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(_getAdaptivePadding(context)),
                child: Form(
                  key: _formKeyMobile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, "Payment Channel"),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildMobileBankDropdown(context),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildSectionTitle(context, "Currency"),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildCurrencyDropdown(context, false),
                      SizedBox(height: _getAdaptiveSpacing(context)),
                      _buildFormButtons(context, false),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.labelMedium);
  }

  Widget _buildBankDropdown(BuildContext context) {
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        List<Bank> bankOnModes =
            getBanksForSelectedMode(state, paymentModes[1]);

        if (state.status == ServiceStatus.loading) {
          return const CircularProgressIndicator();
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(
            child: Text("Failed to load banks"),
          );
        }

        return _buildDropdown<Bank>(
          value: selectedBank,
          items: bankOnModes,
          onChanged: (value) {
            setState(() {
              selectedBank = value;
            });
          },
          validator: (value) {
            if (selectedBank == null || value == null) {
              return "Please select a bank";
            }
            return null;
          },
          hintText: "Select Institution's name",
          itemBuilder: (Bank bank) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BankLogoImage(
                  name: bank.name,
                  shortname: bank.shortname,
                  height: 20,
                  width: 20,
                  fallbackIconSize: 14,
                ),
              ),
              SizedBox(width: _getAdaptiveSpacing(context) / 2),
              Text(bank.name,
                  style: TextStyle(
                      fontSize: _getAdaptiveTextSize(context, 14),
                      color: Colors.black)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileBankDropdown(BuildContext context) {
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        List<Bank> bankOnModes =
            getBanksForSelectedMode(state, paymentModes[0]);

        if (state.status == ServiceStatus.loading) {
          return const CircularProgressIndicator();
        }
        if (state.status == ServiceStatus.loadingFailure) {
          return const Center(
            child: Text("Failed to load mobile wallets"),
          );
        }

        return _buildDropdown<Bank>(
          value: selectedMobileBank,
          items: bankOnModes,
          onChanged: (value) {
            setState(() {
              selectedMobileBank = value;
            });
          },
          validator: (value) {
            if (selectedMobileBank == null || value == null) {
              return "Please select a bank";
            }
            return null;
          },
          hintText: "Select Institution's name",
          itemBuilder: (Bank bank) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BankLogoImage(
                  name: bank.name,
                  shortname: bank.shortname,
                  height: 20,
                  width: 20,
                  fallbackIconSize: 14,
                ),
              ),
              SizedBox(width: _getAdaptiveSpacing(context) / 2),
              Text(bank.name,
                  style: TextStyle(
                      fontSize: _getAdaptiveTextSize(context, 14),
                      color: Colors.black)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context, bool isBank) {
    return BlocBuilder<WalletsBloc, WalletsState>(
      builder: (context, state) {
        if (state.status == ServiceStatus.loading &&
            state.currencies.isEmpty) {
          return const CircularProgressIndicator();
        }

        final currencies = state.currencies.isNotEmpty
            ? state.currencies
            : const [
                Currency(id: 1, name: 'Kenyan Shilling', symbol: 'KES'),
                Currency(id: 2, name: 'US Dollar', symbol: 'USD'),
              ];

        final selected =
            isBank ? selectedBankCurrency : selectedMobileCurrency;
        final selectedValue = selected != null &&
                currencies.any((c) =>
                    c.symbol.toUpperCase() == selected.symbol.toUpperCase())
            ? currencies.firstWhere((c) =>
                c.symbol.toUpperCase() == selected.symbol.toUpperCase())
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown<Currency>(
              value: selectedValue,
              items: currencies,
              onChanged: (value) {
                setState(() {
                  if (isBank) {
                    selectedBankCurrency = value;
                  } else {
                    selectedMobileCurrency = value;
                  }
                });
              },
              validator: (value) {
                if ((isBank ? selectedBankCurrency : selectedMobileCurrency) ==
                        null ||
                    value == null) {
                  return "Please select a currency";
                }
                return null;
              },
              hintText: "Select KES or USD (dollar account)",
              itemBuilder: (Currency currency) => Text(
                _currencyLabel(currency),
                style: TextStyle(
                  fontSize: _getAdaptiveTextSize(context, 14),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: _getAdaptiveSpacing(context) / 2),
            Text(
              'Tip: you can add both a KES and a USD (dollar) account for the same bank.',
              style: TextStyle(
                fontSize: _getAdaptiveTextSize(context, 12),
                color: AppColors.fadeBlackColor,
                height: 1.3,
              ),
            ),
          ],
        );
      },
    );
  }

  String _currencyLabel(Currency currency) {
    final symbol = currency.symbol.toUpperCase();
    if (symbol == 'USD') return 'US Dollar (USD) — Dollar account';
    if (symbol == 'KES') return 'Kenyan Shilling (KES)';
    final name = currency.name.trim();
    if (name.isEmpty || name.toUpperCase() == symbol) return symbol;
    return '$name ($symbol)';
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String? Function(T?)? validator,
    required String hintText,
    required Widget Function(T) itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: itemBuilder(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: getDropDownDecoration(context, true, hintText),
      style: TextStyle(fontSize: _getAdaptiveTextSize(context, 14)),
    );
  }

  Widget _buildFormButtons(BuildContext context, bool isBank) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: _getAdaptiveTextSize(context, 14)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final form =
                isBank ? _formKey.currentState : _formKeyMobile.currentState;
            if (form!.validate() &&
                (isBank ? selectedBank : selectedMobileBank) != null &&
                (isBank ? selectedBankCurrency : selectedMobileCurrency) !=
                    null) {
              var data = <String, dynamic>{
                "institution_name":
                    (isBank ? selectedBank : selectedMobileBank)!.name,
                "currency":
                    (isBank ? selectedBankCurrency : selectedMobileCurrency)!
                        .symbol
                        .toUpperCase(),
                "bank_id": (isBank ? selectedBank : selectedMobileBank)!.id,
              };
              if (isBank) {
                final accType = _accTypeController.text.trim();
                final currency = (selectedBankCurrency?.symbol ?? 'KES')
                    .toUpperCase();
                data["account_type"] = accType.isNotEmpty
                    ? accType
                    : (currency == 'USD' ? 'Dollar Account' : 'Bank Account');
                // Keep institution name stable for SMS matching; account_type
                // distinguishes the dollar account in the UI.
              } else if ((selectedMobileCurrency?.symbol ?? 'KES')
                      .toUpperCase() ==
                  'USD') {
                data["account_type"] = 'Dollar Account';
              }
              context.read<WalletsBloc>().add(CreateManualWallet(data: data));
              context.pop();
            } else {
              showError("Fill the form correctly");
            }
          },
          child: Text(
            "Save",
            style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: _getAdaptiveTextSize(context, 14)),
          ),
        ),
      ],
    );
  }

  double _getAdaptiveTextSize(BuildContext context, double value) {
    return (MediaQuery.of(context).size.width / 400) * value;
  }

  double _getAdaptiveSpacing(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.02;
  }

  double _getAdaptivePadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.04;
  }

  List<Bank> getBanksForSelectedMode(WalletsState state, String mode) {
    if (mode == paymentModes.first) {
      return state.banks
          .where((element) => element.mode == BankMode.PHONE)
          .toList();
    } else {
      return state.banks
          .where((element) => element.mode == BankMode.BANK)
          .toList();
    }
  }
}
