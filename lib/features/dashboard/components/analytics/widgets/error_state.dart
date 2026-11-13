import 'package:flutter/material.dart';

Widget buildErrorState(
    BuildContext context, String errorMessage, VoidCallback? onPressed) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          "Oops! Something went wrong",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Try Again", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
