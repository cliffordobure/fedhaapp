import 'package:flutter/material.dart';

class SmsPermissionDialog extends StatelessWidget {
  const SmsPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Access to Financial SMS'),
      content: const Text(
        'To provide accurate financial insights, we need access to your SMS messages. We will use this information to analyze your spending habits and offer personalized recommendations.',
      ),
      actionsAlignment: MainAxisAlignment.center, // Center the buttons
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Deny'), // More descriptive button text
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Allow',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
