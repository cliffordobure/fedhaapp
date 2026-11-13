// ignore_for_file: use_build_context_synchronously

import 'package:fedha/common/bank_logo.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/bank/bloc.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Banks extends StatefulWidget {
  const Banks({Key? key}) : super(key: key);

  @override
  State<Banks> createState() => _BanksState();
}

class _BanksState extends State<Banks> {
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<BanksBloc>().state.status == ServiceStatus.initial) {
      context.read<BanksBloc>().add(StartBanksBloc());
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: BlocListener<BanksBloc, BanksState>(
          listener: (context, state) {
            if (state.banksSaved) {
              context.goNamed(Routes.membership);
            }
          },
          listenWhen: (previous, current) =>
              previous.banksSaved != current.banksSaved,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FullWidthButton(
                      text: "Proceed",
                      action: () {
                        // Save selected
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        context.goNamed(Routes.home);
                      },
                      child: const Text("Skip For now"))
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: AppBar().preferredSize.height, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Link Your Bank(s)",
                    style: theme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlueColor),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    "You can add up to 5 banks",
                    style: theme.displayMedium!
                        .copyWith(color: AppColors.darkBlueColor),
                  ),
                  const SizedBox(height: 20),

                  // Fetch banks
                  BlocBuilder<BanksBloc, BanksState>(
                    builder: (context, state) {
                      if (state.status == ServiceStatus.loading) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).width -
                              AppBar().preferredSize.height,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state.status == ServiceStatus.loadingFailure) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).width -
                              AppBar().preferredSize.height,
                          child: Column(
                            children: [
                              const Text("Failed to load banks"),
                              const SizedBox(
                                height: 16,
                              ),
                              TextButton.icon(
                                  onPressed: () {
                                    context
                                        .read<BanksBloc>()
                                        .add(RefreshBanks());
                                  },
                                  icon: const Icon(Icons.replay_outlined),
                                  label: const Text("Retry"))
                            ],
                          ),
                        );
                      }
                      return state.banks.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.banks.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => BankInput(
                                    bank: state.banks[index],
                                    isSelected: state.selected
                                        .contains(state.banks[index].id),
                                  ))
                          : SizedBox(
                              height: MediaQuery.sizeOf(context).width -
                                  AppBar().preferredSize.height,
                              child: const Center(
                                child: Text("No banks found!"),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BankInput extends StatelessWidget {
  const BankInput({super.key, required this.bank, required this.isSelected});
  final Bank bank;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        // Add to selected
        context.read<BanksBloc>().add(
              ToggleSelected(bank.id),
            );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.greyColor, width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.greyColor, width: 1),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: BankLogoImage(
                            name: bank.name,
                            shortname: bank.shortname,
                            height: 35,
                            width: 35,
                            fallbackIconSize: 18,
                          ),
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      bank.name,
                      style: theme.displaySmall!.copyWith(color: Colors.black),
                    )
                  ],
                ),
              ),
              isSelected
                  ? Padding(
                      padding: EdgeInsets.only(right: 5.h),
                      child: Icon(
                        Icons.check_circle,
                        size: 25.h,
                        color: Colors.green,
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
