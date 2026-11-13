import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController dateController;
  final void Function(DateTime) onDateSelected;

  const DatePickerWidget({
    Key? key,
    required this.dateController,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  Future<void> getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));
    if (pickerDate != null) {
      setState(() {
        widget.dateController.text =
            DateFormat.yMd().format(pickerDate).toString();
        widget.onDateSelected(pickerDate);
      });
    } else {
      debugPrint("Something is not right");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      textEditingController: widget.dateController,
      inputtype: TextInputType.number,
      title: 'Desired Date',
      inputAction: TextInputAction.done,
      hide: false,
      suffix: IconButton(
        onPressed: getDateFromUser,
        icon: const Icon(
          Icons.access_time_rounded,
          color: Colors.grey,
        ),
      ),
      validator: (onValidateVal) {
        if (onValidateVal.isEmpty) {
          return "Date is required";
        }
        return null;
      },
      onSaved: (String? onSavedVal) {
        logger.info("on saved calles");
      },
      borderRadius: BorderRadius.circular(20),
      hintText: "24th Mar 2024",
    );
  }
}
