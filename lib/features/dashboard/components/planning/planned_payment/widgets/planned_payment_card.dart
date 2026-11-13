import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/dashboard/components/categories/widgets/create_subcategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlannedPaymentCard extends StatelessWidget {
  const PlannedPaymentCard({
    super.key,
    required this.text,
    required this.category,
    this.subcategory,
    this.categoryType = 0,
    required this.icon,
    required this.bgColor,
    required this.onPressed,
    this.displayCard = false,
    required this.description,
    required this.price,
  });

  final String text, description, price;
  final int category, categoryType;
  final dynamic subcategory;
  final IconData icon;
  final Color bgColor;
  final bool displayCard;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: CardColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: bgColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF012340),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff919191),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'KES $price',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF012340),
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (displayCard)
                    Builder(
                      builder: (context) {
                        return IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () => _showCategoryMenu(context),
                          icon: const Icon(
                            Icons.more_vert,
                            color: CardColors.greyColor,
                            size: 20,
                          ),
                        );
                      },
                    )
                  else
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: CardColors.greyColor,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
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
            showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: const EdgeInsets.all(16),
                child: CreateSubCategory(
                  subcategory: Subcategory(
                    id: subcategory.id,
                    name: subcategory.name,
                    categoryId: subcategory.categoryId,
                    status: subcategory.status,
                    createdAt: subcategory.createdAt,
                    updatedAt: subcategory.updatedAt,
                  ),
                  update: true,
                  category: category,
                  categoryType: categoryType,
                ),
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
            if (categoryType == 1) {
              context.read<ExpenseBloc>().add(
                    DeleteExpenseSubCategory(subcategoryId: subcategory.id),
                  );
            } else {
              context.read<IncomeBloc>().add(
                    DeleteIncomeSubCategory(subcategoryId: subcategory.id),
                  );
            }
            context.read<ExpenseBloc>().add(LoadCategories());
            context.read<IncomeBloc>().add(FetchIncomeTypes());
          },
        ),
      ],
    );
  }
}

class CardColors {
  static const whiteColor = Colors.white;
  static const greyColor = Colors.grey;
}
