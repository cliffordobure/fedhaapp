import 'package:flutter/material.dart';

void _showInviteUserModal(BuildContext context) {
  String email = '';
  String selectedPermission = 'read_only';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invite User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter user email',
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPermission,
              decoration: const InputDecoration(
                labelText: 'Permissions',
              ),
              items: const [
                DropdownMenuItem(
                    value: 'edit_budget', child: Text('Edit Budget')),
                DropdownMenuItem(
                    value: 'add_read_transactions',
                    child: Text('Add and Read Transactions')),
                DropdownMenuItem(value: 'read_only', child: Text('Read Only')),
              ],
              onChanged: (value) {
                selectedPermission = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Invite'),
            onPressed: () {
              // TODO: Implement the invite logic here
              print(
                  'Inviting user: $email with permission: $selectedPermission');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
