import 'package:fedha/data/models/auth/Delete/delete_account_request.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  final VoidCallback onDeleteSuccess;

  const DeleteAccountBottomSheet({
    Key? key,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  _DeleteAccountBottomSheetState createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _confirmDelete = false;
  String? _passwordError;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitDeletion() {
    if (_formKey.currentState!.validate()) {
      context.read<AccountBloc>().add(
            DeleteAccount(
              password:
                  DeleteAccountRequest(password: _passwordController.text),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final bool isSubmitting =
            state.status == ServiceStatus.submissionInProgress;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text('Delete Account',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      errorText: _passwordError,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  if (state.status == ServiceStatus.submissionFailure)
                    Text(
                      state.message?.message ?? "An error occurred",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 6),
                  CheckboxListTile(
                    title: Text(
                      'I understand that this action cannot be undone',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    value: _confirmDelete,
                    onChanged: (bool? value) {
                      setState(() {
                        _confirmDelete = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: (isSubmitting || !_confirmDelete)
                        ? null
                        : _submitDeletion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Delete Account',
                            style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
