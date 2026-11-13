import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/section_title.dart';
import 'package:fedha/features/dashboard/components/home/utils/utils.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/message_reading_service/sms_banks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AcceptedBanksPage extends StatefulWidget {
  const AcceptedBanksPage({super.key, required this.wallet});
  final Bank wallet;

  @override
  // ignore: library_private_types_in_public_api
  _AcceptedBanksPageState createState() => _AcceptedBanksPageState();
}

class _AcceptedBanksPageState extends State<AcceptedBanksPage> {
  late Future<List<String>> _supportedBanksFuture;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _supportedBanksFuture = _fetchSupportedBanks();
  }

  Future<List<String>> _fetchSupportedBanks() async {
    return await service<AppPreferences>().getSupportedBanks();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _enableAutomaticWallet() async {
    if (_connecting) return;
    setState(() => _connecting = true);

    final walletsBloc = context.read<WalletsBloc>();
    walletsBloc.add(CreateAutomaticWallet(bank: widget.wallet));
  }

  Future<void> _disableMessageReading() async {
    final prefs = service<AppPreferences>();
    await prefs.removeSupportedBank(widget.wallet.name);
    await prefs.rejectReadMessages();
    if (!mounted) return;
    _showSnackBar(
      context,
      "Text reading for ${widget.wallet.name} has been disabled",
      Colors.red,
    );
    setState(() {
      _supportedBanksFuture = _fetchSupportedBanks();
    });
  }

  Future<void> _toggleMessageReading(bool value) async {
    if (value) {
      await _enableAutomaticWallet();
    } else {
      await _disableMessageReading();
    }
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Center(
        child: Text('Error loading preferences. Please try again later.'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("${widget.wallet.name} Permissions"),
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget _buildMessageReadingSwitch(bool isMessageReadingEnabled) {
    return SwitchListTile(
      title: Text("Allow reading of ${widget.wallet.name}'s messages"),
      value: isMessageReadingEnabled,
      onChanged: _connecting
          ? null
          : (bool value) {
              _toggleMessageReading(value);
            },
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryColor,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Enabling this creates a ${widget.wallet.name} wallet and syncs new SMS transactions from the moment you connect. Your privacy and data security are our top priority.',
              style: TextStyle(
                color: Colors.green.shade800,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletsBloc, WalletsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (!_connecting) return;

        if (state.status == ServiceStatus.submissionSuccess) {
          if (!mounted) return;
          await showSmsDialog(context);
          if (!mounted) return;
          setState(() {
            _connecting = false;
            _supportedBanksFuture = _fetchSupportedBanks();
          });
          _showSnackBar(
            this.context,
            "${widget.wallet.name} connected. SMS sync will import new messages.",
            Colors.green,
          );
          Navigator.of(this.context).popUntil((route) => route.isFirst);
        } else if (state.status == ServiceStatus.submissionFailure) {
          if (!mounted) return;
          setState(() => _connecting = false);
        }
      },
      child: FutureBuilder<List<String>>(
        future: _supportedBanksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _connecting) {
            return Scaffold(
              appBar: _buildAppBar(),
              body: _buildLoading(),
            );
          } else if (snapshot.hasError) {
            return _buildError();
          } else if (snapshot.hasData) {
            final banks = snapshot.data ?? const <String>[];
            final isMessageReadingEnabled = banks.any(
              (b) =>
                  b.toLowerCase() == widget.wallet.name.toLowerCase() ||
                  walletNameMatchesSmsBank(b, widget.wallet.name),
            );
            final hasWallet = context.watch<WalletsBloc>().state.wallets.any(
                  (wallet) =>
                      wallet.bankId == widget.wallet.id ||
                      wallet.name.toLowerCase() ==
                          widget.wallet.name.toLowerCase(),
                );

            return Scaffold(
              appBar: _buildAppBar(),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle(context, "Enable Message Reading"),
                    const SizedBox(height: 12),
                    _buildMessageReadingSwitch(isMessageReadingEnabled),
                    const SizedBox(height: 20),
                    _buildInfoBox(context),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _connecting
                            ? null
                            : () async {
                                if (!hasWallet || !isMessageReadingEnabled) {
                                  await _enableAutomaticWallet();
                                  return;
                                }
                                if (context.mounted) {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }
                              },
                        child: Text(
                          hasWallet && isMessageReadingEnabled
                              ? "Done"
                              : "Connect ${widget.wallet.name}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('No data available.')),
            );
          }
        },
      ),
    );
  }
}
