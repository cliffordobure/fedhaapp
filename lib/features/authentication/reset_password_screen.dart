// ignore_for_file: use_build_context_synchronously

import 'package:fedha/data/models/auth/password.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "resetPassword";
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pswController = TextEditingController();
  TextEditingController pswConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.verificationSuccess) {
          // set new passwords
          context.goNamed(
            Routes.resetSuccess,
          );
        }
      },
      listenWhen: (previous, current) =>
          previous.verificationSuccess != current.verificationSuccess,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/Images/Background.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height,
                    ),
                    Text("Reset Password",
                        style: theme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.h),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Text(
                          "Your password should have at least 8 characters, containing a letter and a number",
                          textAlign: TextAlign.center,
                          style: theme.displayMedium,
                        )),
                    SizedBox(height: 30.h),
                    DefaultInputField(
                        textEditingController: pswController,
                        hintText: "********",
                        inputtype: TextInputType.visiblePassword,
                        title: 'Password',
                        validator: (val) {
                          if (val.isEmpty) return 'Password cannot be empty!';
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    DefaultInputField(
                        textEditingController: pswConfirmController,
                        hintText: "********",
                        inputtype: TextInputType.visiblePassword,
                        title: 'Password Confirmation',
                        inputAction: TextInputAction.done,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please confirm your password!';
                          }
                          if (val != pswController.text) {
                            return 'Password Mismatch';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: AppBar().preferredSize.height / 2,
                    ),
                    FullWidthButton(
                      btnheight: 50.h,
                      action: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AccountBloc>().add(
                                PasswordResetEvent(
                                  request: PasswordResetRequest(
                                      email: widget.email,
                                      password: pswController.text),
                                ),
                              );
                        } else {
                          showError("Passwords must match");
                        }
                      },
                      text: "Done",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
