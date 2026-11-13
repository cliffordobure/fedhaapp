import 'package:flutter/material.dart';

class GreenButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const GreenButton({
    super.key,
    required this.text,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),

      height: 40, // Set a fixed height
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
