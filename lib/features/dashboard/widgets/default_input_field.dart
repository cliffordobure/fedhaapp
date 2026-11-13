import 'package:flutter/material.dart';

class DefaultInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType inputtype;
  final String title;
  final TextInputAction inputAction;
  final bool hide;
  final String? Function(String?) validator;
  final void Function(String?)? onSaved;
  final BorderRadius borderRadius;
  final String hintText;
  final Widget? suffix;

  const DefaultInputField({
    Key? key,
    required this.textEditingController,
    this.inputtype = TextInputType.text,
    required this.title,
    required this.inputAction,
    required this.hide,
    required this.validator,
    this.onSaved,
    required this.borderRadius,
    required this.hintText,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: const Color(0XFF555555),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: textEditingController,
          keyboardType: inputtype,
          obscureText: hide,
          textInputAction: inputAction,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: borderRadius,
            ),
            suffixIcon: suffix,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
