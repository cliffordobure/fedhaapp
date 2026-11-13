import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/subscriptions/bloc.dart';
import 'package:fedha/features/common_widgets/error_lottie.dart';
import 'package:fedha/features/common_widgets/floating_action_btn.dart';
import 'package:fedha/features/dashboard/components/subscriptions/widgets/subscription_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    if (context.read<SubscriptionsBloc>().state.status ==
        ServiceStatus.initial) {
      context.read<SubscriptionsBloc>().add(StartSubscriptionsBloc());
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
            floatingActionButton: ActionBtn(
              onPressed: () {
                context.pushNamed(Routes.newSubscription);
              },
            ),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Center(
                  child: Text("Subscriptions",
                      style: theme.titleMedium!.copyWith(
                          fontSize: 18,
                          color: AppColors.darkBlueColor,
                          fontWeight: FontWeight.w700))),
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
            ),
            body: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
              builder: (context, state) {
                if (state.status == ServiceStatus.loading) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }
                if (state.status == ServiceStatus.loadingFailure) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: LottieError(
                      message: state.message?.message ?? "An error occured",
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Total amount"),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primaryColor
                                                  .withOpacity(.2)),
                                          child: Text(
                                              "Ksh. ${formatAmount(state.selected?.totalAmount.toDouble())}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.greyColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: DropdownButton(
                                        value: state.span,
                                        icon: const Icon(
                                            CupertinoIcons.chevron_down),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        isDense: true,
                                        elevation: 0,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        items: FinancialSpan.values.map<
                                                DropdownMenuItem<
                                                    FinancialSpan>>(
                                            (FinancialSpan value) {
                                          return DropdownMenuItem<
                                              FinancialSpan>(
                                            value: value,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Text(capitalize(
                                                  value.toStringValue)),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          context.read<SubscriptionsBloc>().add(
                                              SubscriptionsSpanSelected(
                                                  value!));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                // Chart
                                SfCircularChart(
                                  legend: const Legend(
                                      isVisible: true,
                                      isResponsive: true,
                                      position: LegendPosition.bottom),
                                  tooltipBehavior: TooltipBehavior(),
                                  series: <CircularSeries>[
                                    DoughnutSeries<_ChartData, String>(
                                      dataSource: state.selected?.subscriptions
                                                  .isNotEmpty ??
                                              false
                                          ? listData(
                                              state.selected!.subscriptions)
                                          : <_ChartData>[
                                              _ChartData("Empty", 100,
                                                  Colors.grey[200])
                                            ],
                                      pointColorMapper: (_ChartData data, _) =>
                                          data.color,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                      innerRadius: '70%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Subscriptions",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: const Color(
                                          0xff919191,
                                        ),
                                        // fontSize: 12,
                                        fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          state.status == ServiceStatus.loading
                              ? Container(
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.sizeOf(context).width / 2 -
                                              AppBar().preferredSize.height),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const CircularProgressIndicator())
                              : state.selected != null &&
                                      state.selected!.subscriptions.isNotEmpty
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          SubscriptionCard(
                                              subscription: state.selected!
                                                  .subscriptions[index]),
                                      separatorBuilder: (context, index) =>
                                            const Divider(
                                              color: Colors.transparent,
                                              height: 8,
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                      itemCount:
                                          state.selected!.subscriptions.length)
                                  : Container(
                                      constraints: BoxConstraints(
                                          minHeight: MediaQuery.sizeOf(context)
                                                      .width /
                                                  2 -
                                              AppBar().preferredSize.height),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: const Center(
                                        child: Text("No item found"),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}

List<_ChartData> listData(List<Subscription> subscriptions) {
  return List<_ChartData>.from(
    subscriptions
        .map(
          (e) => _ChartData(
            e.name,
            e.amount.toDouble(),
          ),
        )
        .toList(),
  );
}

class _ChartData {
  _ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
