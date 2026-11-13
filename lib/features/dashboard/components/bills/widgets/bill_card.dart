import 'package:fedha/data/models/bills/user_bills.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BillCard extends StatelessWidget {
  const BillCard({super.key, required this.bill});
  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.pushNamed(Routes.editBill, extra: bill);
      },
      tileColor: AppColors.whiteColor,
      leading: SizedBox(
        width: 50,
        child: bill.img.isNotEmpty && !bill.img.endsWith('/')
            ? ClipOval(
                child: Center(
                  child: Image.network(
                    bill.img,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => _fallbackIcon(),
                  ),
                ),
              )
            : _fallbackIcon(),
      ),
      title: Text(bill.name),
      subtitle: Text(
        bill.id < 0
            ? "Ksh ${formatAmount(bill.amount.toDouble())}  ·  Waiting to sync"
            : "Ksh ${formatAmount(bill.amount.toDouble())}",
      ),
      // trailing: const Icon(CupertinoIcons.chevron_right),
    );
  }

  Widget _fallbackIcon() => CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white70,
        child: Icon(Icons.receipt_long, color: AppColors.primaryColor),
      );
}
