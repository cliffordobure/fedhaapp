import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/features/dashboard/components/home/widgets/message_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';

class SearchBanks extends StatefulWidget {
  const SearchBanks({Key? key}) : super(key: key);

  @override
  State<SearchBanks> createState() => _SearchBanksState();
}

class _SearchBanksState extends State<SearchBanks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletsBloc = context.read<WalletsBloc>();
      if (walletsBloc.state.supportedBanks.isEmpty ||
          walletsBloc.state.status == ServiceStatus.initial) {
        walletsBloc.add(StartWalletBloc());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<WalletsBloc, WalletsState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                _buildMainContent(context, state),
                _buildBottomButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "Supported Payment Channels",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700,
            ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMainContent(BuildContext context, WalletsState state) {
    final TextEditingController searchController = TextEditingController();
    final WalletsBloc banksBloc = context.read<WalletsBloc>();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          _buildSearchBar(searchController, banksBloc),
          const SizedBox(height: 20),
          Expanded(
            child: _buildBanksList(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, WalletsBloc bloc) {
    return SizedBox(
      height: 50,
      child: SearchBar(
        controller: controller,
        onChanged: (value) {
          debugPrint(value);
          bloc.add(FilterBanks(query: value));
        },
        hintText: "Search Payment Channel",
        elevation: WidgetStateProperty.all(0),
        trailing: const [Icon(Icons.search)],
        side: WidgetStateProperty.all(
          const BorderSide(color: Color.fromARGB(255, 211, 210, 210)),
        ),
      ),
    );
  }

  List<Bank> _visibleBanks(WalletsState state) {
    // filteredBanks is kept in sync with supportedBanks on load / search.
    return state.filteredBanks.isNotEmpty
        ? state.filteredBanks
        : state.supportedBanks;
  }

  Widget _buildBanksList(BuildContext context, WalletsState state) {
    final banks = _visibleBanks(state);
    if (state.status == ServiceStatus.loading && banks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (banks.isEmpty) {
      return const Center(child: Text("No supported payment channels found"));
    }
    return ListView.builder(
      itemCount: banks.length,
      itemBuilder: (context, index) =>
          _buildBankItem(context, state, banks, index),
    );
  }

  Widget _buildBankItem(
    BuildContext context,
    WalletsState state,
    List<Bank> banks,
    int index,
  ) {
    final bank = banks[index];
    final WalletsBloc banksBloc = context.read<WalletsBloc>();

    return GestureDetector(
      onTap: () => banksBloc.add(RadioSelectEvent(index: index)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            _buildBankLogo(bank),
            const SizedBox(width: 8),
            Text(bank.name),
            const Spacer(),
            Radio<int>(
              value: index,
              groupValue: state.selectedIndex,
              onChanged: (value) =>
                  banksBloc.add(RadioSelectEvent(index: value!)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankLogo(Bank bank) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BankLogoImage(
        name: bank.name,
        shortname: bank.shortname,
        height: 30,
        width: 30,
        fallbackIconSize: 16,
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, WalletsState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: FullWidthButton(
          action: () => _handleProceedButton(context, state),
          text: "Proceed",
        ),
      ),
    );
  }

  void _handleProceedButton(BuildContext context, WalletsState state) {
    final banks = _visibleBanks(state);
    if (state.selectedIndex != null &&
        state.selectedIndex! >= 0 &&
        state.selectedIndex! < banks.length) {
      Bank selectedBank = banks[state.selectedIndex!];
      if (_isAcceptedBank(selectedBank.name)) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AcceptedBanksPage(wallet: selectedBank),
          ),
        );
      } else {
        context.pop();
        context.pushNamed(Routes.membership);
      }
    } else {
      showSnackBar(
        context,
        content: "Please select a bank",
        bgColor: Colors.red,
      );
    }
  }

  bool _isAcceptedBank(String bankName) {
    const acceptedBanks = [
      "M-Pesa",
      "Airtel Money",
      "T-Kash by Telcom",
      "Co-Operative Bank",
      "Standard Chartered Bank",
      "Equity Bank",
      "I&M Bank",
      "NCBA Bank",
      "Stanbic Bank"
    ];
    final target = bankName.toLowerCase().trim();
    return acceptedBanks.any((b) => b.toLowerCase() == target) ||
        target.contains('i&m') ||
        target.contains('i & m') ||
        target.contains('i and m') ||
        target.contains('equity') ||
        target.contains('standard chartered') ||
        target.contains('stanchart') ||
        target.contains('stanbic') ||
        target.contains('ncba') ||
        target.contains('coop') ||
        target.contains('pesa');
  }
}
