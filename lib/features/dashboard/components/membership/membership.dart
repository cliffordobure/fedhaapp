import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/membership/bloc.dart';
import 'package:fedha/features/dashboard/components/membership/widgets/membership_card.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberShip extends StatefulWidget {
  const MemberShip({Key? key}) : super(key: key);

  @override
  State<MemberShip> createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  @override
  Widget build(BuildContext context) {
    if (context.read<MemberShipBloc>().state.status == ServiceStatus.initial) {
      context.read<MemberShipBloc>().add(StartMemberShip());
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
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              title: Text(
                "Membership",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    color: AppColors.darkBlueColor,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<MemberShipBloc, MembershipState>(
              builder: (context, state) {
                if (state.status == ServiceStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.status == ServiceStatus.loadingFailure) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("failed to load options"),
                        const SizedBox(
                          height: 16,
                        ),
                        TextButton(
                            onPressed: () {
                              context
                                  .read<MemberShipBloc>()
                                  .add(StartMemberShip());
                            },
                            child: const Text("Retry")),
                      ],
                    ),
                  );
                }
                return state.data.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  Basic
                            state.data[MemberOptions.BASIC] != null
                                ? MembershipCard(
                                    memberOption: MemberOptions.BASIC,
                                    background:
                                        Theme.of(context).colorScheme.onPrimary,
                                    primary: AppColors.greyColor,
                                    option: state.data[MemberOptions.BASIC]!,
                                    isCurrent: state.currentOption ==
                                        MemberOptions.BASIC,
                                    isOutlined: true,
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 16,
                            ),
                            // Bronze
                            state.data[MemberOptions.BRONZE] != null
                                ? MembershipCard(
                                    memberOption: MemberOptions.BRONZE,
                                    background: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.1),
                                    primary: AppColors.primaryColor,
                                    option: state.data[MemberOptions.BRONZE]!,
                                    isCurrent: state.currentOption ==
                                        MemberOptions.BRONZE,
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 16,
                            ),
                            // Silver
                            state.data[MemberOptions.SILVER] != null
                                ? MembershipCard(
                                    memberOption: MemberOptions.SILVER,
                                    background:
                                        AppColors.greyColor.withOpacity(.1),
                                    primary: AppColors.darkBlueColor,
                                    option: state.data[MemberOptions.SILVER]!,
                                    isCurrent: state.currentOption ==
                                        MemberOptions.SILVER,
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 16,
                            ),
                            state.data[MemberOptions.PREMIUM] != null
                                ? MembershipCard(
                                    memberOption: MemberOptions.PREMIUM,
                                    background:
                                        AppColors.greyColor.withOpacity(.1),
                                    primary: AppColors.warningColor,
                                    option: state.data[MemberOptions.PREMIUM]!,
                                    isCurrent: state.currentOption ==
                                        MemberOptions.PREMIUM,
                                  )
                                : const SizedBox.shrink(),

                            SizedBox(
                              height: AppBar().preferredSize.height + 16,
                            )
                          ],
                        ),
                      )
                    : Container();
              },
            )),
      ),
    );
  }
}

class IconAndText {
  final IconData icon;
  final String text;

  /// Icons are colored with iconTheme: IconThemeData(color: Colors.teal) in
  /// your roots Theme
  const IconAndText(this.icon, this.text);
}
