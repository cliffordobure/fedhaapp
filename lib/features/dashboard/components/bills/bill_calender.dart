import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/common_widgets/error_lottie.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BillCalendarScreen extends StatefulWidget {
  const BillCalendarScreen({Key? key}) : super(key: key);

  @override
  State<BillCalendarScreen> createState() => _BillCalendarScreenState();
}

class _BillCalendarScreenState extends State<BillCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    if (context.read<BillsBloc>().state.formStatus == ServiceStatus.initial) {
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
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Center(
                  child: Text("Bill Calendar",
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SfCalendar(
                      view: CalendarView.month,
                      dataSource: BillCalendarDataSource(
                          _getDataSource(state.selected!.bills)),
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment),
                      firstDayOfWeek: 1,
                      initialSelectedDate: DateTime.now(),
                      todayHighlightColor: AppColors.primaryColor,
                      showNavigationArrow: true,
                      // showCurrentTimeIndicator: true,
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}

List<Billing> _getDataSource(List<Bill> bills) {
  final List<Billing> billings = <Billing>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(
    const Duration(hours: 2),
  );
  billings.add(
    Billing(
        eventName: "Kplc Token",
        from: startTime,
        to: endTime,
        background: AppColors.primaryColor,
        isAllDay: false),
  );
  billings.add(
    Billing(
        eventName: "Wifi",
        from: startTime.add(const Duration(days: 2)),
        to: endTime.add(const Duration(days: 2)),
        background: AppColors.primaryColor,
        isAllDay: false),
  );
  return billings;
}

class BillCalendarDataSource extends CalendarDataSource {
  BillCalendarDataSource(List<Billing> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) => appointments![index].eventName;
  // DateTime getSubject(int index) {
  //   return appointments![index].eventName;
  // }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Billing {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  Billing({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });
}
