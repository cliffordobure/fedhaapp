import 'package:fedha/common/custom_loader.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/features/app/blocs/planned_payment/planned_payment_bloc.dart';
import 'package:fedha/features/dashboard/components/categories/categories_icons.dart';
import 'package:fedha/features/dashboard/components/planning/planned_payment/widgets/planned_payement_bottomsheet.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PlannedPaymentDetailScreen extends StatefulWidget {
  const PlannedPaymentDetailScreen(
      {super.key, required this.category, required this.plannedPayment});
  final String category;
  final PlannedPayment plannedPayment;

  @override
  State<PlannedPaymentDetailScreen> createState() =>
      _PlannedPaymentDetailScreenState();
}

class _PlannedPaymentDetailScreenState
    extends State<PlannedPaymentDetailScreen> {
  late PlannedPaymentBloc _bloc;
  @override
  void initState() {
    _bloc = PlannedPaymentBloc();
    _bloc.add(
      PlannedPaymentEvent.detailFetched(id: widget.plannedPayment.id ?? 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              widget.category,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  color: AppColors.darkBlueColor,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),

          // Planned payments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<PlannedPaymentBloc, PlannedPaymentState>(
              bloc: _bloc,
              builder: (context, state) {
                switch (state.status) {
                  case PlannedPaymentStatus.loading:
                    return const Center(child: LogoLoader());

                  case PlannedPaymentStatus.failure:
                    return const Center(
                      child: Text("Failed to load payments history"),
                    );
                  case PlannedPaymentStatus.success:
                    String paymentDateString =
                        widget.plannedPayment.paymentDate;
                    DateTime paymentDate =
                        DateFormat('yyyy-MM-dd').parse(paymentDateString);
                    DateTime today = DateTime.now();
                    int daysDifference = paymentDate.difference(today).inDays;

                    return Column(children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                getMaterialIcon(
                                    widget.plannedPayment.category.name),
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.plannedPayment.name,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.plannedPayment.category.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Ksh ${widget.plannedPayment.amount}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  final RenderBox button =
                                      context.findRenderObject()! as RenderBox;
                                  final position = RelativeRect.fromLTRB(
                                    button.size.width / 2,
                                    button.size.height / 2.2,
                                    1,
                                    0,
                                  );

                                  showMenu(
                                    context: context,
                                    position: position,
                                    items: [
                                      PopupMenuItem(
                                        child: const Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                        onTap: () {
                                          // Handle edit action
                                          showModalBottomSheet(
                                            showDragHandle: true,
                                            useRootNavigator: true,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) =>
                                                FractionallySizedBox(
                                              heightFactor: 1,
                                              child:
                                                  NewPlannedPaymentBottomSheet(
                                                      update: true,
                                                      payment: widget
                                                          .plannedPayment),
                                            ),
                                          );
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                        onTap: () {
                                          context.pop();
                                          context
                                              .read<PlannedPaymentBloc>()
                                              .add(PlannedPaymentEvent.deleted(
                                                  id: widget
                                                          .plannedPayment.id ??
                                                      0));
                                        },
                                      ),
                                    ],
                                  );
                                },
                                icon: const Icon(Icons.more_vert))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Row(
                        children: [
                          Text("Record Payment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.plannedPayment.paymentDate,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Due date in $daysDifference days",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              BlocConsumer<PlannedPaymentBloc,
                                  PlannedPaymentState>(
                                bloc: _bloc,
                                listener: (context, state) {
                                  if (state.status ==
                                      PlannedPaymentStatus.success) {
                                    // _bloc.add(PlannedPaymentEvent.detailFetched(
                                    //     id: widget.plannedPayment.id));
                                  }
                                },
                                builder: (context, paymentstate) {
                                  return paymentstate.status ==
                                          PlannedPaymentStatus.loading
                                      ? const Center(child: LogoLoader())
                                      : OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: const StadiumBorder(),
                                            side: BorderSide(
                                              color: AppColors.primaryColor,
                                            ),
                                            backgroundColor: AppColors
                                                .primaryColor
                                                .withOpacity(0.13),
                                          ),
                                          onPressed: () {
                                            // next payment date
                                            DateTime parsedDate =
                                                DateTime.parse(widget
                                                    .plannedPayment
                                                    .paymentDate);

                                            //current date
                                            DateTime currentDate =
                                                DateTime.now();

                                            if (currentDate
                                                .isAfter(parsedDate)) {
                                              _bloc.add(
                                                PlannedPaymentEvent
                                                    .paymentHistoryAdded(
                                                  id: widget
                                                          .plannedPayment.id ??
                                                      0,
                                                  request: PaymentHistory(
                                                    plannedPaymentsId: widget
                                                            .plannedPayment
                                                            .id ??
                                                        0,
                                                    amount: widget
                                                        .plannedPayment.amount
                                                        .toString(),
                                                    paidAt: widget
                                                        .plannedPayment
                                                        .paymentDate,
                                                    userId: widget
                                                        .plannedPayment.userId,
                                                  ),
                                                ),
                                              );

                                              _bloc.add(PlannedPaymentEvent
                                                  .detailFetched(
                                                      id: widget.plannedPayment
                                                              .id ??
                                                          0));
                                            } else {
                                              showSnackBar(context,
                                                  content:
                                                      "payment date has not yet been reached.",
                                                  bgColor: Colors.red);
                                            }
                                          },
                                          child: const Text("Mark as Paid "));
                                },
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Row(
                        children: [
                          Text("Payments History",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (state.plannedPayment!.paymentHistory == null)
                        const Center(child: Text("No payments history")),
                      if (state.plannedPayment!.paymentHistory != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              ...List.generate(
                                state.plannedPayment!.paymentHistory?.length ??
                                    0,
                                (index) {
                                  final paymentHistory = state
                                      .plannedPayment!.paymentHistory?[index];
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget
                                                  .plannedPayment.paymentDate),
                                              Text(
                                                "Paid ${paymentHistory!.createdAt!}",
                                                style: TextStyle(
                                                  color: AppColors.greyColor,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text("Ksh ${paymentHistory.amount}"),
                                        ],
                                      ),
                                      Divider(
                                        color: AppColors.greyColor,
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        )
                    ]);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
