import 'package:fedha/features/dashboard/components/bills/widgets/bill_form.dart';
import 'package:flutter/material.dart';

class NewBillScreen extends StatelessWidget {
  static const routeName = "new_bill";
  const NewBillScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const BillForm();
}
