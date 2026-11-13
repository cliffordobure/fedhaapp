import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatefulWidget {
  final ValueChanged<int?> onTypeSelected;

  const TransactionTypeSelector({Key? key, required this.onTypeSelected}) : super(key: key);

  @override
  TransactionTypeSelectorState createState() => TransactionTypeSelectorState();
}

class TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  int? _selectedType;
  String? _errorMessage;

  void validateSelection() {
    setState(() {
      _errorMessage = _selectedType == null ? 'Please select a transaction type.' : null;
    });
    if (_selectedType != null) {
      widget.onTypeSelected(_selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = 1;
                  _errorMessage = null; // Clear error message
                });
                widget.onTypeSelected(_selectedType);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: _selectedType == 1 ? Colors.green[200] : Colors.grey[200],
                ),
                child: const Text('Expense'),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = 2;
                  _errorMessage = null; // Clear error message
                });
                widget.onTypeSelected(_selectedType);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  color: _selectedType == 2 ? Colors.green[200] : Colors.grey[200],
                ),
                child: const Text('Income'),
              ),
            ),
          ],
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
