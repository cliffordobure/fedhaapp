import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/common_widgets/error_lottie.dart';
import 'package:fedha/features/common_widgets/floating_action_btn.dart';
import 'package:fedha/features/dashboard/components/bills/widgets/bill_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BillTrackerScreen extends StatefulWidget {
  const BillTrackerScreen({Key? key}) : super(key: key);

  @override
  State<BillTrackerScreen> createState() => _BillTrackerScreenState();
}

class _BillTrackerScreenState extends State<BillTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    if (context.read<BillsBloc>().state.status == ServiceStatus.initial) {
      context.read<BillsBloc>().add(StartBillsBloc());
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
                context.pushNamed(Routes.newBill);
              },
            ),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Center(
                  child: Text("Bill Tracker",
                      style: theme.titleMedium!.copyWith(
                          fontSize: 18,
                          color: AppColors.darkBlueColor,
                          fontWeight: FontWeight.w700))),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.calendarBill);
                  },
                  child: const Icon(Icons.calendar_month),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            body: BlocBuilder<BillsBloc, BillsState>(
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
                                          context
                                              .read<BillsBloc>()
                                              .add(SpanSelected(value!));
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
                                      dataSource:
                                          state.selected?.bills.isNotEmpty ??
                                                  false
                                              ? listData(state.selected!.bills)
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
                                "Bills",
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
                                      state.selected!.bills.isNotEmpty
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => BillCard(
                                          bill: state.selected!.bills[index]),
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                            color: Colors.transparent,
                                            height: 8,
                                            indent: 8,
                                            endIndent: 8,
                                          ),
                                      itemCount: state.selected!.bills.length)
                                  : _BillTrackerEmpty(
                                      onConnect: () =>
                                          context.pushNamed(Routes.newBill),
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

List<_ChartData> listData(List<Bill> bills) {
  return List<_ChartData>.from(
    bills
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

class _BillTrackerEmpty extends StatelessWidget {
  const _BillTrackerEmpty({required this.onConnect});

  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight:
            MediaQuery.sizeOf(context).width / 2 - AppBar().preferredSize.height,
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 44,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            'Bill Tracker not connected',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlueColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first bill to start tracking rent, utilities, and other recurring payments.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: const Color(0xff919191),
                ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Connect Bill Tracker',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
