import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/features/app/blocs/bills/bloc.dart';
import 'package:fedha/features/dashboard/components/bills/widgets/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBillScreen extends StatelessWidget {
  static const routeName = "edit_bill";
  const EditBillScreen({Key? key, required this.bill}) : super(key: key);
  final Bill bill;

  @override
  Widget build(BuildContext context) {
    final span = context.read<BillsBloc>().state.span;
    final typeName = switch (span) {
      FinancialSpan.monthly => 'Monthly',
      FinancialSpan.yearly => 'Annually',
      _ => 'Weekly',
    };
    return BillForm(bill: bill, initialTypeName: typeName);
  }
}
