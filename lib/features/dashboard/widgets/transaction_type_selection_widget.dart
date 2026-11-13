import 'package:flutter/material.dart';

class TransactionTypeSelectionWidget extends StatelessWidget {
  final int? selectedType;
  final void Function(int) onTypeSelected;

  const TransactionTypeSelectionWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: const Color(0XFF555555),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getTransactionTypeButton(1, 'Expense', selectedType == 1),
            _getTransactionTypeButton(2, 'Income', selectedType == 2),
          ],
        ),
      ],
    );
  }

  Widget _getTransactionTypeButton(int type, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          color: isSelected ? Colors.green[200] : Colors.grey[200],
        ),
        child: Text(label),
      ),
    );
  }
}
